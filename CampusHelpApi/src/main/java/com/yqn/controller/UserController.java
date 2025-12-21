package com.yqn.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.yqn.common.core.domain.AjaxResult;
import com.yqn.common.tools.MessageTools;
import com.yqn.common.tools.PocketMoney;
import com.yqn.pojo.User;
import com.yqn.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * @author Leivmox
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private MessageTools message;
    @Autowired
    private PocketMoney money;

    // 检查登录
    @GetMapping("/login")
    public Map<String, Object> checkUserLogin(User checkUser, HttpSession session) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("student_id", checkUser.getStudentId())
                .eq("password", checkUser.getPassword())
                .eq("school_id", checkUser.getSchoolId());
        User user = userService.getOne(wrapper);

        if (user != null) {
            session.setAttribute("user", user);
            return message.message(true, "请求成功", "user", user);
        }
        return message.message(false, "账号或密码错误", "", null);
    }

    // 获取全部User
    @GetMapping
    public Map<String, Object> users(String studentId, String username) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        if (studentId != null) {
            wrapper.eq("student_id", studentId);
            return message.message(true, "请求成功", "user", userService.list(wrapper));
        }
        if (username != null) {
            wrapper.like("username", username);
            return message.message(true, "请求成功", "user", userService.list(wrapper));
        }
        List<User> users = userService.list();
        return message.message(true, "请求成功", "user", users);
    }

    // 根据id获取User
    @GetMapping("/{id}")
    public Map<String, Object> user(@PathVariable String id) {
        User user = userService.getById(id);
        return message.message(true, "请求成功", "user", user);
    }

    // 添加User
    @PostMapping
    public Map<String, Object> saveUser(User user) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("school_id", user.getSchoolId())
                .eq("student_id", user.getStudentId());
        User one = userService.getOne(wrapper);
        if (one == null) {
            userService.save(user);
            return message.message(true, "注册成功", "", null);
        }
        return message.message(false, "error, 该学号已被注册", "", null);
    }

    // 更新信息
    @PutMapping
//    public Map<String, Object> putUser(User user) {
    public Map<String, Object> putUser(@RequestBody User user) {
        if (user.getId() == null) {
            return message.message(false, "更新失败：缺少用户ID", "", null);
        }

        // updateById 只会更新实体类中非 null 的字段
        boolean update = userService.updateById(user);
        if (update) {
            // 更新成功后，建议返回最新的用户信息，方便前端同步状态
            User newUser = userService.getById(user.getId());
            return message.message(true, "更新成功", "user", newUser);
        }
        return message.message(false, "更新失败", "", null);
    }

    // 删除学生
    @DeleteMapping("/{id}")
    public Map<String, Object> delUser(@PathVariable Long id) {
        boolean remove = userService.removeById(id);
        if (remove) {
            return message.message(true, "删除学生成功", "", null);
        }
        return message.message(false, "error,删除学生失败", "", null);
    }

    // ==========================================
    // 修复后的头像更新接口 (纯数据库更新版)
    // ==========================================

    /**
     * 更新头像路径到数据库
     * 注意：这里不负责上传文件，只负责接收文件路径和学号并更新数据库
     */
    @PostMapping("/updateAvatar")
    public AjaxResult updateAvatar(@RequestBody User user) {
        System.out.println("【调试】收到头像更新请求 -> ID: " + user.getId() + " | Avatar: " + user.getAvatar());

        // 1. 必须要有 ID
        if (user.getId() == null) {
            return AjaxResult.error("更新失败：无法获取用户ID (Primary Key)");
        }

        // 2. 必须要有头像路径
        if (user.getAvatar() == null || "".equals(user.getAvatar())) {
            return AjaxResult.error("更新失败：头像路径为空");
        }

        // 3. 构造更新条件：只认 ID (id = ?)
        UpdateWrapper<User> updateWrapper = new UpdateWrapper<>();
        updateWrapper.set("avatar", user.getAvatar()); // 设置新头像
        updateWrapper.eq("id", user.getId());          // 锁定这一行数据

        // 4. 执行更新
        boolean success = userService.update(updateWrapper);

        if (success) {
            return AjaxResult.success("头像更新成功");
        } else {
            return AjaxResult.error("更新失败：数据库中不存在 ID=" + user.getId() + " 的用户");
        }
    }

    @PostMapping("/updateProfile")
    public AjaxResult updateProfile(@RequestBody User user) {
        if (user.getId() == null) {
            return AjaxResult.error("ID不能为空");
        }

        UpdateWrapper<User> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("id", user.getId());

        // 动态判断，只更新传过来的字段
        if (user.getSignature() != null) updateWrapper.set("signature", user.getSignature());
        if (user.getEmail() != null) updateWrapper.set("email", user.getEmail());

        boolean success = userService.update(updateWrapper);
        return success ? AjaxResult.success("资料更新成功") : AjaxResult.error("更新失败");
    }
}
