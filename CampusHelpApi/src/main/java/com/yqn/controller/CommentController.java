package com.yqn.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.yqn.common.tools.MessageTools;
import com.yqn.pojo.Comment;
import com.yqn.pojo.Post;
import com.yqn.service.CommentService;
import com.yqn.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*; // 导入这里的所有注解，包括 DeleteMapping

import java.util.List;
import java.util.Map;

/**
 * @author Leivmox
 */
@RestController
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;
    @Autowired
    private PostService postService;
    @Autowired
    private MessageTools message;

    // 获取“我”发布的评论
    @GetMapping("/my")
    public Map<String, Object> getMyComments(Long userId) {
        QueryWrapper<Comment> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId).orderByDesc("create_time");
        List<Comment> comments = commentService.list(wrapper);

        for (Comment comment : comments) {
            Post post = postService.getById(comment.getPostId());
            if (post != null) {
                comment.setPost(post);
            } else {
                Post deletedPost = new Post();
                deletedPost.setTitle("该帖子已被删除");
                comment.setPost(deletedPost);
            }
        }

        return message.message(true, "请求成功", "comments", comments);
    }


    // 删除评论接口
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteComment(@PathVariable Long id) {
        boolean remove = commentService.removeById(id);
        if (remove) {
            return message.message(true, "删除成功", "", null);
        }
        return message.message(false, "删除失败", "", null);
    }

}
