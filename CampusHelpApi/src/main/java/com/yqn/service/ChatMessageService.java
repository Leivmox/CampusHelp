package com.yqn.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yqn.pojo.ChatMessage;

import java.util.List;
import java.util.Map;

/**
 * 聊天消息 Service 接口
 *
 * @author Leivmox
 */
public interface ChatMessageService extends IService<ChatMessage> {

    /**
     * 获取两个用户之间的聊天记录
     *
     * @param userId   当前用户ID
     * @param targetId 对方用户ID
     * @return 消息列表
     */
    List<ChatMessage> getChatHistory(Long userId, Long targetId);

    /**
     * 获取最近联系人列表
     *
     * @param userId 当前用户ID
     * @return 最近联系人列表（包含用户信息、最后一条消息、未读数）
     */
    List<Map<String, Object>> getRecentContacts(Long userId);

    /**
     * 发送消息
     *
     * @param message 消息对象
     * @return 是否发送成功
     */
    boolean sendMessage(ChatMessage message);

    /**
     * 将对方发给我的消息标记为已读
     *
     * @param senderId   发送者ID (对方)
     * @param receiverId 接收者ID (我)
     */
    void markAsRead(Long senderId, Long receiverId);
}
