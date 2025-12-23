package com.yqn.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.yqn.common.tools.MessageTools;
import com.yqn.pojo.Comment;
import com.yqn.pojo.Post;
import com.yqn.pojo.UserLike;
import com.yqn.service.CommentService;
import com.yqn.service.PostService;
import com.yqn.service.UserLikeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.Map;

@RestController
@RequestMapping("/like") // 统一路径 /like
@Slf4j
public class UserLikeController {

    @Autowired
    private UserLikeService userLikeService;
    @Autowired
    private PostService postService;
    @Autowired
    private CommentService commentService; // 假设你有点赞评论的需求
    @Autowired
    private MessageTools message;

    /**
     * 通用点赞/取消点赞接口
     * * @param userId     谁点的赞
     * @param targetId   点赞目标的ID (帖子ID 或 评论ID)
     * @param targetType 类型 (1-帖子, 2-评论)
     */
    @PutMapping
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> toggleLike(@RequestParam Long userId,
                                          @RequestParam Long targetId,
                                          @RequestParam Integer targetType) {

        if (userId == null || targetId == null || targetType == null) {
            return message.message(false, "参数不完整", "", null);
        }

        // 1. 查询是否已经点赞
        QueryWrapper<UserLike> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId);
        wrapper.eq("target_id", targetId);
        wrapper.eq("target_type", targetType);

        UserLike existLike = userLikeService.getOne(wrapper);
        boolean isLikedNow;

        // 2. 判断是【取消点赞】还是【新增点赞】
        if (existLike != null) {
            // --- 取消点赞 ---
            userLikeService.removeById(existLike.getId());
            updateLikeCount(targetId, targetType, -1); // 封装一个方法去更新数量
            isLikedNow = false;
        } else {
            // --- 新增点赞 ---
            UserLike newLike = new UserLike();
            newLike.setUserId(userId);
            newLike.setTargetId(targetId);
            newLike.setTargetType(targetType);
            newLike.setCreateTime(new Date());
            userLikeService.save(newLike);
            updateLikeCount(targetId, targetType, 1);
            isLikedNow = true;
        }

        String msg = isLikedNow ? "点赞成功" : "取消点赞";
        return message.message(true, msg, "isLiked", isLikedNow);
    }

    /**
     * 辅助方法：更新 帖子 或 评论 的点赞数量
     * @param countChange +1 或 -1
     */
    private void updateLikeCount(Long targetId, Integer targetType, int countChange) {
        if (targetType == 1) {
            // 更新帖子
            Post post = postService.getById(targetId);
            if (post != null) {
                // 防止减成负数
                int newCount = post.getLikeCount() + countChange;
                if (newCount < 0) newCount = 0;

                post.setLikeCount(newCount);
                postService.updateById(post);
            }
        } else if (targetType == 2) {
            // 更新评论 (假设 Comment 也有 like_count 字段)
            Comment comment = commentService.getById(targetId);
            if (comment != null) {
                // 同样的逻辑...
                // comment.setLikeCount(...)
                // commentService.updateById(comment);
            }
        }
    }
}