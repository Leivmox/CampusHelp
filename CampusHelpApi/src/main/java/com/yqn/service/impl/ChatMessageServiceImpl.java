package com.yqn.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yqn.mapper.ChatMessageMapper;
import com.yqn.pojo.ChatMessage;
import com.yqn.pojo.User;
import com.yqn.service.ChatMessageService;
import com.yqn.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 聊天消息 Service 实现类
 *
 * @author Leivmox
 */
@Service
public class ChatMessageServiceImpl extends ServiceImpl<ChatMessageMapper, ChatMessage> implements ChatMessageService {

    @Autowired
    private ChatMessageMapper chatMessageMapper;

    @Autowired
    private UserService userService;

    @Override
    public List<ChatMessage> getChatHistory(Long userId, Long targetId) {
        return chatMessageMapper.selectChatHistory(userId, targetId);
    }

    @Override
    public List<Map<String, Object>> getRecentContacts(Long userId) {
        // 1. 获取最近联系人的基础数据
        List<Map<String, Object>> contacts = chatMessageMapper.selectRecentContacts(userId);

        // 2. 为每个联系人填充用户详细信息
        List<Map<String, Object>> result = new ArrayList<>();
        for (Map<String, Object> contact : contacts) {
            Map<String, Object> item = new HashMap<>();

            // 获取目标用户ID
            Object targetUserIdObj = contact.get("target_user_id");
            Long targetUserId = null;
            if (targetUserIdObj instanceof Long) {
                targetUserId = (Long) targetUserIdObj;
            } else if (targetUserIdObj instanceof Integer) {
                targetUserId = ((Integer) targetUserIdObj).longValue();
            }

            if (targetUserId != null) {
                // 查询用户信息
                User targetUser = userService.getById(targetUserId);
                item.put("targetUser", targetUser);
            }

            // 复制其他字段
            item.put("lastMessage", contact.get("last_message"));
            item.put("lastTime", contact.get("last_time"));

            // 处理未读数
            Object unreadObj = contact.get("unread_count");
            int unreadCount = 0;
            if (unreadObj instanceof Long) {
                unreadCount = ((Long) unreadObj).intValue();
            } else if (unreadObj instanceof Integer) {
                unreadCount = (Integer) unreadObj;
            }
            item.put("unreadCount", unreadCount);

            result.add(item);
        }

        return result;
    }

    @Override
    public boolean sendMessage(ChatMessage message) {
        // 设置默认值
        if (message.getType() == null) {
            message.setType(0); // 默认文本消息
        }
        if (message.getIsRead() == null) {
            message.setIsRead(0); // 默认未读
        }
        if (message.getCreateTime() == null) {
            message.setCreateTime(new Date());
        }

        return this.save(message);
    }

    @Override
    public void markAsRead(Long senderId, Long receiverId) {
        chatMessageMapper.markAsRead(senderId, receiverId);
    }
}
