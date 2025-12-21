package com.yqn.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.yqn.common.core.domain.AjaxResult;
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

    // 获取论坛列表 (带评论、用户信息、多图拆分)
// 获取论坛列表 (支持 查全校 OR 查个人)
    @GetMapping
    public Map<String, Object> posts(Long schoolId, Long userId) { // 🟢 1. 增加 userId 参数
        QueryWrapper<Post> wrapper = new QueryWrapper<>();

        // 必须查该学校
        wrapper.eq("school_id", schoolId);

        // 🟢 2. 核心修改：如果有 userId，就只查这个人的；没有就查所有人的
        if (userId != null) {
            wrapper.eq("user_id", userId);
        }

        wrapper.orderByDesc("create_time");

        List<Post> posts = postService.list(wrapper);

        // 遍历每个帖子 (保持原有逻辑不变)
        for (Post post : posts) {
            // 将数据库的长字符串拆分成图片列表给前端
            post.convertStringToList();

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
    // 🟢 修改：建议加上 @RequestBody 以便接收前端的 imgList 数组
    @PostMapping
    public Map<String, Object> savePost(@RequestBody Post post) {

        log.info("【发布调试】接收到的参数: {}", post);
        log.info("【发布调试】图片列表: {}", post.getImgList());

        post.setCreateTime(new Date());
        post.setLikeCount(0);

        // 🟢 核心修改：如果前端传了图片列表，合并成字符串存入数据库
        // 前端传: { "title": "...", "imgList": ["url1", "url2"] }
        if (post.getImgList() != null && !post.getImgList().isEmpty()) {
            post.convertListToString();
            log.info("【发布调试】转换后的imgUrl: {}", post.getImgUrl());
        }

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
        // 1. 先删除该帖子下的所有评论
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

    // ==========================================
    // 🟢 核心修改：单独更新帖子图片 (支持多图)
    // ==========================================

    /**
     * 单独更新帖子图片
     * 前端传 JSON: { "id": 1, "imgList": ["url1", "url2"] }
     */
    @PostMapping("/updatePostImg")
    public AjaxResult updatePostImg(@RequestBody Post post) {
        log.info("【调试】收到更新请求 -> PostID: {}", post.getId());

        // 1. 校验 ID
        if (post.getId() == null) {
            return AjaxResult.error("更新失败：无法获取帖子ID");
        }

        // 🟢 2. 处理多图逻辑
        // 如果前端传的是 imgList，先转换成 String
        if (post.getImgList() != null && !post.getImgList().isEmpty()) {
            post.convertListToString();
        }

        // 简单校验：imgUrl 不能为空 (你也可以根据业务需求允许为空，即删除所有图片)
        if (post.getImgUrl() == null) {
            // 如果你想允许清空图片，可以把这里注释掉，或者改为设置空字符串
            return AjaxResult.error("更新失败：图片数据为空");
        }

        log.info("【调试】转换后的数据库存储字符串: {}", post.getImgUrl());

        // 3. 构造更新条件
        UpdateWrapper<Post> updateWrapper = new UpdateWrapper<>();
        updateWrapper.set("img_url", post.getImgUrl()); // 设置逗号拼接后的字符串
        updateWrapper.eq("id", post.getId());           // 锁定帖子

        // 4. 执行更新
        boolean success = postService.update(updateWrapper);

        if (success) {
            return AjaxResult.success("帖子图片更新成功");
        } else {
            return AjaxResult.error("更新失败：找不到 ID=" + post.getId() + " 的帖子");
        }
    }

    // 🟢 新增：修改帖子内容 (标题、内容、图片)
// 🟢 修复后：修改帖子内容 (保持与其他接口格式一致)
    @PutMapping
    public Map<String, Object> updatePost(@RequestBody Post post) {
        if (post.getId() == null) {
            return message.message(false, "ID不能为空", null, null);
        }

        // 处理图片列表转字符串
        if (post.getImgList() != null) {
            post.convertListToString();
        }

        // 执行更新
        boolean success = postService.updateById(post);

        if (success) {
            // 注意：这里必须用 message.message 返回，前端才能识别 status: true
            return message.message(true, "修改成功", null, null);
        } else {
            return message.message(false, "修改失败", null, null);
        }
    }
}
