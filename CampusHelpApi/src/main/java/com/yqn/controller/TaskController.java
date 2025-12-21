package com.yqn.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.yqn.common.tools.MessageTools;
import com.yqn.common.tools.PocketMoney;
import com.yqn.pojo.Task;
import com.yqn.pojo.User;
import com.yqn.service.TaskService;
import com.yqn.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * @author Leivmox
 */
@RestController
@RequestMapping("/task")
@Slf4j
public class TaskController {
    @Autowired
    private TaskService taskService;
    @Autowired
    private UserService userService;
    @Autowired
    private MessageTools message;
    @Autowired
    private PocketMoney money;

    @GetMapping
    public Map<String, Object> tasks(Long id) {
        User user = userService.getById(id);
        List<Task> tasks;
        if (user != null) {
            QueryWrapper<Task> wrapper = new QueryWrapper<>();
            wrapper.eq("user_school_id", user.getSchool().getId());
            tasks = taskService.list(wrapper);
        } else {
            tasks = taskService.list();
        }

        // 🟢 核心增加：遍历拆分图片字符串为列表
        for (Task task : tasks) {
            task.convertStringToList();
        }

        return message.message(true, "请求成功", "task", tasks);
    }

    // 根据id获取task
    @GetMapping("/{id}")
    public Map<String, Object> task(@PathVariable String id) {
        Task task = taskService.getById(id);
        if (task != null) {
            task.convertStringToList(); // 🟢 转换
        }
        return message.message(true, "请求成功", "task", task);
    }

    // 当前登录User, 已发布的task
    @GetMapping("/published")
    public Map<String, Object> published(Long id) {
        return message.message(true, "请求成功", "task", publishAndAcceptMethods(id, "publish_user_id"));
    }

    // 当前登录User, 已接受的task
    @GetMapping("/accepted")
    public Map<String, Object> accepted(Long id) {
        return message.message(true, "请求成功", "task", publishAndAcceptMethods(id, "accept_user_id"));
    }

    // 获取发布和接受的task
    public List<Task> publishAndAcceptMethods(Long id, String field) {
        // User user = (User) session.getAttribute("user");
        QueryWrapper<Task> wrapper = new QueryWrapper<>();
        wrapper.eq(field, id);
        return taskService.list(wrapper);
    }

    // 发布新task
//    @PostMapping
//    public Map<String, Object> saveTask(Task task) {
//        User user = userService.getById(task.getPublishId());
//        if (user.getBalance() >= task.getReward()) {
//            boolean save = taskService.save(task);
//            if (save) {
//                money.transfer("balance=balance-", task.getReward(), user.getStudentId());
//            }
//            return message.message(true, "发布任务成功", "", null);
//        } else {
//            return message.message(false, "余额不足", "", null);
//        }
//    }

    // 发布新task
    @PostMapping
// 必须加 @RequestBody，否则后端收到的 task 字段全是 null
    public Map<String, Object> saveTask(@RequestBody Task task) {
        log.info("接收到发布请求: {}", task);

        // 1. 获取发布者信息
        if (task.getPublishId() == null) {
            return message.message(false, "发布失败：用户ID不能为空", "", null);
        }


        User user = userService.getById(task.getPublishId());
        if (user == null) {
            return message.message(false, "发布失败：用户不存在", "", null);
        }

        // 2. 积分校验 (10个)
        double cost = 10.0;
        if (user.getBalance() == null || user.getBalance() < cost) {
            return message.message(false, "积分不足，无法发布 (当前积分: " + user.getBalance() + ")", "", null);
        }

        // 3. 执行扣分和保存 (简单处理版)
        user.setBalance(user.getBalance() - cost);
        userService.updateById(user); // 更新用户余额

        // 🟢 核心增加：处理图片
        if (task.getImgList() != null) {
            task.convertListToString();
            log.info("图片转换结果: {}", task.getImgUrl()); // 打印一下看这里有没有值
        }


        task.setCreateTime(new java.util.Date());
        task.setState(0); // 待领取
        boolean save = taskService.save(task);

        if (save) {
            return message.message(true, "发布成功，扣除 10 积分", "", null);
        } else {
            return message.message(false, "服务器保存失败", "", null);
        }
    }

    @DeleteMapping("/{id}")
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> delTask(@PathVariable Long id) {
        Task task = taskService.getById(id);
        if (task == null) {
            return message.message(false, "取消失败：任务不存在", "", null);
        }

        if (task.getState() != 0) {
            return message.message(false, "取消失败：任务已被接单或已完成", "", null);
        }

        // 🟢 重点修复：尝试从字段或关联对象中获取 userId
        Long userId = task.getPublishId();
        if (userId == null && task.getPublish() != null) {
            userId = task.getPublish().getId();
        }

        if (userId == null) {
            // 这里就是你报错的地方，现在增加了上面的判断，应该能拿到了
            return message.message(false, "取消失败：找不到发布者信息", "", null);
        }

        boolean removed = taskService.removeById(id);
        if (removed) {
            double refundAmount = 10.0;
            User user = userService.getById(userId);
            if (user != null) {
                user.setBalance(user.getBalance() + refundAmount);
                userService.updateById(user);
                return message.message(true, "取消任务成功，已退回 10 积分", "", null);
            }
        }
        return message.message(false, "操作失败", "", null);
    }

    // 接单人取消task
    @PutMapping("/takerCancel/{id}")
    public Map<String, Object> takerCancel(@PathVariable Long id) {

        UpdateWrapper<Task> wrapper = new UpdateWrapper<>();
        wrapper.setSql("accept_user_id=null")
                .setSql("order_time=null")
                .setSql("state=0")
                .eq("id", id);

        boolean update = taskService.update(wrapper);


        if (update) {
            return message.message(true, "取消任务成功", "", null);
        }
        return message.message(false, "取消任务失败", "", null);
    }

    // 接单人接受task
    @PutMapping("/takerAccept")
    public Map<String, Object> takerAccept(Long id, Long acceptId) {

        UpdateWrapper<Task> wrapper = new UpdateWrapper<>();
        wrapper.setSql("accept_user_id=" + acceptId)
                .setSql("order_time=now()")
                .setSql("state=1")
                .eq("id", id);
        boolean b = taskService.update(wrapper);

        if (b) {
            return message.message(true, "接收任务成功", "", null);
        }
        return message.message(false, "接受任务失败", "", null);
    }

    // 完成task
    @PutMapping("/{id}")
//    public Map<String, Object> missionCompleted(@PathVariable Long id) {
//
//        UpdateWrapper<Task> wrapper = new UpdateWrapper<>();
//        wrapper.setSql("end_time=now()")
//                .setSql("state=2")
//                .eq("id", id);
//        boolean b = taskService.update(wrapper);
//
//        if (b) {
//            Task task = taskService.getById(id);
//            if (task != null) {
//                money.transfer("balance=balance+", task.getReward(), task.getAccept().getStudentId());
//            }
//            return message.message(true, "任务完成", "", null);
//        }
//        return message.message(false, "任务完成失败", "", null);
//    }
    public Map<String, Object> missionCompleted(@PathVariable Long id) {

        UpdateWrapper<Task> wrapper = new UpdateWrapper<>();
        wrapper.setSql("end_time=now()")
                .setSql("state=2")
                .eq("id", id);
        boolean b = taskService.update(wrapper);

        if (b) {
            // 不再打赏接单人，删除 money.transfer 调用
            return message.message(true, "任务完成", "", null);
        }
        return message.message(false, "任务完成失败", "", null);
    }

    // 修改task
    @PutMapping("/edit")
    public Map<String, Object> editTask(@RequestBody Task task) { // 🟢 建议加 @RequestBody
        if (task.getId() == null) {
            return message.message(false, "ID不能为空", "", null);
        }

        // 1. 获取数据库原数据，校验权限
        Task dbTask = taskService.getById(task.getId());
        if (dbTask == null) {
            return message.message(false, "任务不存在", "", null);
        }

        // 🟢 2. 处理图片列表转换
        if (task.getImgList() != null) {
            task.convertListToString();
        }

        // 3. 执行更新
        boolean update = taskService.updateById(task);

        if (update) {
            return message.message(true, "修改任务成功", "", null);
        }
        return message.message(false, "修改任务失败", "", null);
    }


}
