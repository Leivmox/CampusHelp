package com.yqn.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.ToString;

import java.util.Date;

/**
 * 聊天消息实体类
 *
 * @author Leivmox
 */
@Data
@ToString
@TableName("chat_message")
public class ChatMessage {

    /**
     * 消息ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 发送者ID
     */
    @TableField(value = "sender_id")
    private Long senderId;

    /**
     * 接收者ID
     */
    @TableField(value = "receiver_id")
    private Long receiverId;

    /**
     * 消息内容
     */
    private String content;

    /**
     * 消息类型：0文本 1图片 2文件
     */
    private Integer type;

    /**
     * 是否已读：0未读 1已读
     */
    @TableField(value = "is_read")
    private Integer isRead;

    /**
     * 发送时间
     */
    @TableField(value = "create_time")
    private Date createTime;

    // ================= 以下为关联查询字段 (非数据库本表字段) =================

    /**
     * 发送者信息
     */
    @TableField(exist = false)
    private User sender;

    /**
     * 接收者信息
     */
    @TableField(exist = false)
    private User receiver;
}
