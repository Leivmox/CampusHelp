package com.yqn.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.ToString;

import java.util.Date;

/**
 * 校园圈子 - 评论实体类
 *
 * @author Leivmox
 */
@Data
@ToString
// 重点：resultMap 指向 CommentMapper.xml 中的 <resultMap id="commentResultMap">
//@TableName(value = "comment", resultMap = "commentResultMap")
@TableName("comment")
public class Comment {

    /**
     * 主键 ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 所属帖子 ID (数据库字段: post_id)
     */
    @TableField(value = "post_id")
    private Long postId;

    /**
     * 评论人 ID (数据库字段: user_id)
     */
    @TableField(value = "user_id")
    private Long userId;

    /**
     * 评论内容
     */
    private String content;

    /**
     * 评论时间 (数据库字段: create_time)
     */
    @TableField(value = "create_time")
    private Date createTime;

    // ================= 以下为关联查询字段 (非数据库本表字段) =================

    /**
     * 评论人对象
     * 通过 XML 中的 <association> 自动封装
     */
    @TableField(exist = false)
    private User commenter;
        // 关联的帖子对象 (用于在"我的评论"中显示帖子标题)
    @TableField(exist = false)
    private Post post;
}
