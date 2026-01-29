package com.yqn.controller;

import com.yqn.common.tools.MessageTools;
import com.yqn.pojo.ChatMessage;
import com.yqn.service.ChatMessageService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 聊天消息 Controller
 *
 * @author Leivmox
 */
@RestController
@RequestMapping("/chat")
@Slf4j
public class ChatController {

    @Autowired
    private ChatMessageService chatMessageService;

    @Autowired
    private MessageTools message;

    /**
     * 获取最近联系人列表
     * GET /chat/recent?userId=xxx
     *
     * @param userId 当前用户ID
     * @return 最近联系人列表
     */
    @GetMapping("/recent")
    public Map<String, Object> getRecentContacts(Long userId) {
        if (userId == null) {
            return message.message(false, "用户ID不能为空", "", null);
        }

        List<Map<String, Object>> list = chatMessageService.getRecentContacts(userId);
        return message.message(true, "请求成功", "list", list);
    }

    /**
     * 获取与某人的聊天记录
     * GET /chat/history?userId=xxx&targetId=xxx
     *
     * @param userId   当前用户ID
     * @param targetId 对方用户ID
     * @return 聊天记录列表
     */
    @GetMapping("/history")
    public Map<String, Object> getChatHistory(Long userId, Long targetId) {
        if (userId == null || targetId == null) {
            return message.message(false, "参数不完整", "", null);
        }

        // 获取聊天记录
        List<ChatMessage> list = chatMessageService.getChatHistory(userId, targetId);

        // 将对方发给我的消息标记为已读
        chatMessageService.markAsRead(targetId, userId);

        return message.message(true, "请求成功", "list", list);
    }

    /**
     * 发送消息
     * POST /chat/send
     *
     * @param chatMessage 消息对象 (senderId, receiverId, content, type)
     * @return 发送结果
     */
    @PostMapping("/send")
    public Map<String, Object> sendMessage(@RequestBody ChatMessage chatMessage) {
        log.info("【发送消息】{} -> {}: {}", chatMessage.getSenderId(), chatMessage.getReceiverId(), chatMessage.getContent());

        // 参数校验
        if (chatMessage.getSenderId() == null) {
            return message.message(false, "发送者ID不能为空", "", null);
        }
        if (chatMessage.getReceiverId() == null) {
            return message.message(false, "接收者ID不能为空", "", null);
        }
        if (chatMessage.getContent() == null || chatMessage.getContent().trim().isEmpty()) {
            return message.message(false, "消息内容不能为空", "", null);
        }

        // 发送消息
        boolean success = chatMessageService.sendMessage(chatMessage);

        if (success) {
            return message.message(true, "发送成功", "", null);
        }
        return message.message(false, "发送失败", "", null);
    }

    /**
     * 标记消息为已读
     * PUT /chat/read?senderId=xxx&receiverId=xxx
     *
     * @param senderId   发送者ID (对方)
     * @param receiverId 接收者ID (我)
     * @return 操作结果
     */
    @PutMapping("/read")
    public Map<String, Object> markAsRead(Long senderId, Long receiverId) {
        if (senderId == null || receiverId == null) {
            return message.message(false, "参数不完整", "", null);
        }

        chatMessageService.markAsRead(senderId, receiverId);
        return message.message(true, "已标记为已读", "", null);
    }
}
