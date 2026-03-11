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
            User userWithAssociation = userService.getByIdWithAssociation(user.getId());
            session.setAttribute("user", userWithAssociation);
            return message.message(true, "请求成功", "user", userWithAssociation);
        }
        return message.message(false, "账号或密码错误", "", null);
    }

    // 获取全部User (带关联数据)
    @GetMapping
    public Map<String, Object> users(String studentId, String username) {
        if (studentId != null) {
            QueryWrapper<User> wrapper = new QueryWrapper<>();
            wrapper.eq("student_id", studentId);
            List<User> users = userService.listWithAssociation();
            List<User> filtered = new java.util.ArrayList<>();
            for (User u : users) {
                if (u.getStudentId().equals(studentId)) {
                    filtered.add(u);
                }
            }
            return message.message(true, "请求成功", "user", filtered);
        }
        if (username != null) {
            List<User> users = userService.listWithAssociation();
            List<User> filtered = new java.util.ArrayList<>();
            for (User u : users) {
                if (u.getUsername() != null && u.getUsername().contains(username)) {
                    filtered.add(u);
                }
            }
            return message.message(true, "请求成功", "user", filtered);
        }
        List<User> users = userService.listWithAssociation();
        return message.message(true, "请求成功", "user", users);
    }

    // 根据id获取User (带关联数据)
    @GetMapping("/{id}")
    public Map<String, Object> user(@PathVariable Long id) {
        User user = userService.getByIdWithAssociation(id);
        return message.message(true, "请求成功", "user", user);
    }

    // 添加User
    @PostMapping
    public Map<String, Object> saveUser(@RequestBody User user) {
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
    public Map<String, Object> putUser(@RequestBody User user) {
        if (user.getId() == null) {
            return message.message(false, "更新失败：缺少用户ID", "", null);
        }

        boolean update = userService.updateById(user);
        if (update) {
            User newUser = userService.getByIdWithAssociation(user.getId());
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

    @PostMapping("/updateAvatar")
    public AjaxResult updateAvatar(@RequestBody User user) {
        System.out.println("【调试】收到头像更新请求 -> ID: " + user.getId() + " | Avatar: " + user.getAvatar());

        if (user.getId() == null) {
            return AjaxResult.error("更新失败：无法获取用户ID (Primary Key)");
        }

        if (user.getAvatar() == null || "".equals(user.getAvatar())) {
            return AjaxResult.error("更新失败：头像路径为空");
        }

        UpdateWrapper<User> updateWrapper = new UpdateWrapper<>();
        updateWrapper.set("avatar", user.getAvatar());
        updateWrapper.eq("id", user.getId());

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

        if (user.getSignature() != null) updateWrapper.set("signature", user.getSignature());
        if (user.getEmail() != null) updateWrapper.set("email", user.getEmail());

        boolean success = userService.update(updateWrapper);
        return success ? AjaxResult.success("资料更新成功") : AjaxResult.error("更新失败");
    }
}
