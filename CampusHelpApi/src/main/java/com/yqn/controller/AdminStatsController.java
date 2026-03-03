package com.yqn.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.yqn.common.tools.MessageTools;
import com.yqn.pojo.Comment;
import com.yqn.pojo.Post;
import com.yqn.pojo.User;
import com.yqn.service.CommentService;
import com.yqn.service.PostService;
import com.yqn.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin/stats")
@Slf4j
public class AdminStatsController {

    @Autowired
    private UserService userService;

    @Autowired
    private PostService postService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private MessageTools message;

    @GetMapping("/overview")
    public Map<String, Object> getOverview() {
        Map<String, Object> stats = new HashMap<>();

        long totalUsers = userService.count();
        stats.put("totalUsers", totalUsers);

        long totalPosts = postService.count();
        stats.put("totalPosts", totalPosts);

        QueryWrapper<Post> postWrapper = new QueryWrapper<>();
        postWrapper.select("IFNULL(SUM(like_count), 0) as totalLikes");
        Map<String, Object> likeStats = postService.getMap(postWrapper);
        stats.put("totalLikes", likeStats != null ? likeStats.get("totalLikes") : 0);

        long totalComments = commentService.count();
        stats.put("totalComments", totalComments);

        QueryWrapper<User> todayUserWrapper = new QueryWrapper<>();
        todayUserWrapper.apply("DATE(create_time) = CURDATE()");
        long todayNewUsers = userService.count(todayUserWrapper);
        stats.put("todayNewUsers", todayNewUsers);

        QueryWrapper<Post> todayPostWrapper = new QueryWrapper<>();
        todayPostWrapper.apply("DATE(create_time) = CURDATE()");
        long todayNewPosts = postService.count(todayPostWrapper);
        stats.put("todayNewPosts", todayNewPosts);

        return message.message(true, "获取成功", "stats", stats);
    }

    @GetMapping("/recentUsers")
    public Map<String, Object> getRecentUsers(@RequestParam(defaultValue = "10") Integer limit) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.orderByDesc("create_time").last("LIMIT " + limit);
        List<User> users = userService.list(wrapper);

        for (User user : users) {
            user.setPassword(null);
        }

        return message.message(true, "获取成功", "users", users);
    }

    @GetMapping("/recentPosts")
    public Map<String, Object> getRecentPosts(@RequestParam(defaultValue = "10") Integer limit) {
        QueryWrapper<Post> wrapper = new QueryWrapper<>();
        wrapper.orderByDesc("create_time").last("LIMIT " + limit);
        List<Post> posts = postService.list(wrapper);

        for (Post post : posts) {
            post.convertStringToList();
            User publisher = userService.getById(post.getUserId());
            post.setPublisher(publisher);
        }

        return message.message(true, "获取成功", "posts", posts);
    }
}
