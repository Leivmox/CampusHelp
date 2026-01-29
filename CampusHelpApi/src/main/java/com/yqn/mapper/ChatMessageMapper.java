package com.yqn.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yqn.pojo.ChatMessage;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;
import java.util.Map;

/**
 * 聊天消息 Mapper
 *
 * @author Leivmox
 */
public interface ChatMessageMapper extends BaseMapper<ChatMessage> {

    /**
     * 获取两个用户之间的聊天记录
     *
     * @param userId   当前用户ID
     * @param targetId 对方用户ID
     * @return 消息列表
     */
    @Select("SELECT * FROM chat_message " +
            "WHERE (sender_id = #{userId} AND receiver_id = #{targetId}) " +
            "   OR (sender_id = #{targetId} AND receiver_id = #{userId}) " +
            "ORDER BY create_time ASC")
    List<ChatMessage> selectChatHistory(@Param("userId") Long userId, @Param("targetId") Long targetId);

    /**
     * 获取最近联系人列表（包含最后一条消息）
     * 使用子查询获取每个会话的最新消息
     *
     * @param userId 当前用户ID
     * @return 最近联系人列表
     */
    @Select("SELECT " +
            "  CASE WHEN m.sender_id = #{userId} THEN m.receiver_id ELSE m.sender_id END AS target_user_id, " +
            "  m.content AS last_message, " +
            "  m.create_time AS last_time, " +
            "  (SELECT COUNT(*) FROM chat_message " +
            "   WHERE sender_id = CASE WHEN m.sender_id = #{userId} THEN m.receiver_id ELSE m.sender_id END " +
            "     AND receiver_id = #{userId} AND is_read = 0) AS unread_count " +
            "FROM chat_message m " +
            "WHERE m.id IN ( " +
            "  SELECT MAX(id) FROM chat_message " +
            "  WHERE sender_id = #{userId} OR receiver_id = #{userId} " +
            "  GROUP BY CASE WHEN sender_id = #{userId} THEN receiver_id ELSE sender_id END " +
            ") " +
            "ORDER BY m.create_time DESC")
    List<Map<String, Object>> selectRecentContacts(@Param("userId") Long userId);

    /**
     * 将某人发给我的消息标记为已读
     *
     * @param senderId   发送者ID (对方)
     * @param receiverId 接收者ID (我)
     * @return 影响行数
     */
    @Update("UPDATE chat_message SET is_read = 1 " +
            "WHERE sender_id = #{senderId} AND receiver_id = #{receiverId} AND is_read = 0")
    int markAsRead(@Param("senderId") Long senderId, @Param("receiverId") Long receiverId);
}
