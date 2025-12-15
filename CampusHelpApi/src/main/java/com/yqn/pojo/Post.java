package com.yqn.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.ToString;

import java.util.Date;
import java.util.List;

/**
 * 校园圈子 - 帖子实体类
 * @author Leivmox
 */
@Data
@ToString
// 重点：resultMap 指向 PostMapper.xml 中的 <resultMap id="postResultMap">
//@TableName(value = "post", resultMap = "postResultMap")
@TableName("post")
public class Post {

    /**
     * 主键 ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 发布人 ID (数据库字段: user_id)
     */
    @TableField(value = "user_id")
    private Long userId;

    /**
     * 学校 ID (数据库字段: school_id)
     */
    @TableField(value = "school_id")
    private Long schoolId;

    /**
     * 帖子标题
     */
    private String title;

    /**
     * 帖子内容
     */
    private String content;

    /**
     * 点赞数 (数据库字段: like_count)
     */
    @TableField(value = "like_count")
    private Integer likeCount;

    /**
     * 发布时间 (数据库字段: create_time)
     */
    @TableField(value = "create_time")
    private Date createTime;

    // ================= 以下为关联查询字段 (非数据库本表字段) =================

    /**
     * 发布人对象
     * 通过 XML 中的 <association> 自动封装
     */
    @TableField(exist = false)
    private User publisher;

    /**
     * 该帖子的评论列表
     * 这个通常在 Controller 中单独查询填充，或者通过 XML 的 <collection> 映射
     */
    @TableField(exist = false)
    private List<Comment> comments;

        // --- 新增：关联的帖子对象 ---
    @TableField(exist = false)
    private Post post;
}
