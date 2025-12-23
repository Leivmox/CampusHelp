package com.yqn.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.ToString;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * 校园圈子 - 帖子实体类
 */
@Data
@ToString
@TableName("post")
public class Post {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @TableField(value = "user_id")
    private Long userId;

    @TableField(value = "school_id")
    private Long schoolId;

    private String title;

    private String content;

    @TableField(value = "like_count")
    private Integer likeCount;

    @TableField(value = "create_time")
    private Date createTime;

    // 🟢 1. 数据库对应的字段：存字符串 "url1,url2,url3"
    @TableField(value = "img_url")
    private String imgUrl;

    // ================= 以下为关联/虚拟字段 =================

    @TableField(exist = false)
    private User publisher;

    @TableField(exist = false)
    private List<Comment> comments;

    // 🟢 2. 前端用的字段：存数组 ["url1", "url2", "url3"]
    @TableField(exist = false)
    private List<String> imgList;


    // 🟢 新增：标记当前用户是否点赞 (数据库没这个字段，是查出来的)
    // Integer或者Boolean都可以，SQL里返回1或0
    @TableField(exist = false)
    private Boolean isLiked;
    // --- 核心工具方法 ---

    /**
     * 保存前调用：把 List 变成 String (逗号拼接)
     * 前端传 ["a.jpg", "b.jpg"] -> 存库 "a.jpg,b.jpg"
     */
    public void convertListToString() {
        if (this.imgList != null && !this.imgList.isEmpty()) {
            this.imgUrl = String.join(",", this.imgList);
        } else {
            // 如果前端传了空数组，或者没传，视情况置空
            // this.imgUrl = null;
        }
    }

    /**
     * 查询后调用：把 String 变成 List (逗号拆分)
     * 库里 "a.jpg,b.jpg" -> 返回前端 ["a.jpg", "b.jpg"]
     */
    public void convertStringToList() {
        if (this.imgUrl != null && !this.imgUrl.isEmpty()) {
            String[] split = this.imgUrl.split(",");
            this.imgList = Arrays.asList(split);
        } else {
            this.imgList = new ArrayList<>();
        }
    }
}
