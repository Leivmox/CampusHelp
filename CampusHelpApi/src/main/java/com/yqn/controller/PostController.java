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
import java.util.List;
import java.util.Map;


/**
 * @author Leivmox
 */
@RestController
@RequestMapping("/post")
@Slf4j
public class PostController {

    @Autowired
    private PostService postService;
    @Autowired
    private CommentService commentService;
    @Autowired
    private UserService userService;
    @Autowired
    private MessageTools message;

    // 获取论坛列表 (带评论和用户信息)
    @GetMapping
    public Map<String, Object> posts(Long schoolId) {
        QueryWrapper<Post> wrapper = new QueryWrapper<>();
        // 查询该学校的帖子，按时间倒序
        wrapper.eq("school_id", schoolId).orderByDesc("create_time");
        List<Post> posts = postService.list(wrapper);

        // 遍历每个帖子，填充发布者信息和评论列表
        for (Post post : posts) {
            // 1. 填充发布者 User
            User publisher = userService.getById(post.getUserId());
            post.setPublisher(publisher);

            // 2. 填充该帖子的评论
            QueryWrapper<Comment> commentWrapper = new QueryWrapper<>();
            commentWrapper.eq("post_id", post.getId()).orderByAsc("create_time");
            List<Comment> comments = commentService.list(commentWrapper);

            // 3. 遍历评论，填充评论者 User
            for (Comment c : comments) {
                User commenter = userService.getById(c.getUserId());
                c.setCommenter(commenter);
            }
            post.setComments(comments);
        }

        return message.message(true, "请求成功", "posts", posts);
    }

    // 发布帖子
    @PostMapping
    public Map<String, Object> savePost(Post post) {
        post.setCreateTime(new Date());
        post.setLikeCount(0);

        boolean save = postService.save(post);
        if (save) {
            return message.message(true, "发布成功", "", null);
        }
        return message.message(false, "发布失败", "", null);
    }

    // 点赞功能
    @PutMapping("/like/{id}")
    public Map<String, Object> like(@PathVariable Long id) {
        Post post = postService.getById(id);
        if (post != null) {
            post.setLikeCount(post.getLikeCount() + 1);
            postService.updateById(post);
            return message.message(true, "点赞成功", "", null);
        }
        return message.message(false, "操作失败", "", null);
    }

    // 发布评论
    @PostMapping("/comment")
    public Map<String, Object> saveComment(Comment comment) {
        comment.setCreateTime(new Date());
        boolean save = commentService.save(comment);
        if (save) {
            return message.message(true, "评论成功", "", null);
        }
        return message.message(false, "评论失败", "", null);
    }

    // 管理员或用户删除帖子
    @DeleteMapping("/{id}")
    public Map<String, Object> delPost(@PathVariable Long id) {
        // 1. 先删除该帖子下的所有评论 (保持数据整洁，防止脏数据)
        QueryWrapper<Comment> commentWrapper = new QueryWrapper<>();
        commentWrapper.eq("post_id", id);
        commentService.remove(commentWrapper);

        // 2. 删除帖子本身
        boolean remove = postService.removeById(id);

        if (remove) {
            return message.message(true, "删除成功", "", null);
        }
        return message.message(false, "删除失败", "", null);
    }
}