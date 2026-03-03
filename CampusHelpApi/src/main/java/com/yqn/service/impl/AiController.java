package com.yqn.service.impl;

import cn.hutool.http.HttpRequest;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.yqn.common.tools.MessageTools;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai")
@PropertySource(value = "classpath:secret.properties", ignoreResourceNotFound = true)
public class AiController {

    @Autowired
    private MessageTools message;

    // 从 secret.properties 注入
    @Value("${ai.api-key:}")
    private String apiKey;

    @Value("${ai.api-url:https://api.siliconflow.cn/v1/chat/completions}")
    private String apiUrl;

    @Value("${ai.model-id:deepseek-ai/DeepSeek-V3}")
    private String modelId;

    @PostMapping("/chat")
    public Map<String, Object> chat(@RequestBody ChatRequest request) {
        // 1. 构建请求体 (OpenAI 格式)
        JSONObject body = new JSONObject();
        body.set("model", modelId);
        body.set("stream", false);  // 流式
        body.set("temperature", 0.7); // 创新程度
        body.set("max_tokens", 512);  // 限制回复长度，防止废话

// 2. 构建消息历史 (System Prompt + User Prompt)
        List<JSONObject> messages = new ArrayList<>();

        // --- 1. 设置系统人设 (System Prompt) ---
        JSONObject systemPrompt = new JSONObject();
        systemPrompt.set("role", "system");

        // 使用 StringBuilder 拼接你的完整提示词
        StringBuilder sb = new StringBuilder();

        // ==================== 身份定义 ====================
        sb.append("【身份设定】\n");
        sb.append("你是【校园IT互助平台】的智能助手，名字叫'小互'。\n");
        sb.append("你的语气热情友好，像一个乐于助人的学长/学姐。\n");
        sb.append("你的职责是帮助同学们解答平台使用问题、引导功能操作、提供IT技术建议。\n\n");

        // ==================== 平台功能介绍 ====================
        sb.append("【平台功能概述】\n");
        sb.append("本平台是校园IT互助系统，主要功能包括：\n");
        sb.append("1. 求助中心：发布IT相关求助(修电脑、装系统、软件问题等)，悬赏积分可选10/15/20/25/30，其他同学可接单帮忙\n");
        sb.append("2. 校园圈子：类似论坛，可发帖分享技术经验、提问交流、评论互动、点赞\n");
        sb.append("3. 评价系统：求助完成后可对帮助者进行星级评价\n");
        sb.append("4. 消息中心：用户之间可以私信聊天，实时接收新消息提醒\n");
        sb.append("5. 积分系统：新用户初始100积分，发布求助扣除悬赏积分，完成互助后积分转给帮助者\n");
        sb.append("6. 智能助手：就是你！可以回答平台使用问题和IT技术问题\n\n");

        // ==================== 页面导航地图 ====================
        sb.append("【系统页面导航】(用户问路时必须精确回答)：\n");
        sb.append("◆ 首页：/home - 查看平台数据概览、置顶精选帖子、个人信息卡片\n");
        sb.append("◆ 求助中心：\n");
        sb.append("  - 求助广场：浏览所有待解决的求助，可接单帮助别人\n");
        sb.append("  - 发布求助：发布新求助，需设置悬赏积分(10/15/20/25/30)\n");
        sb.append("  - 我发布的：查看自己发布的求助，可修改或取消\n");
        sb.append("  - 我接受的：查看自己接单的求助，可联系发布者\n");
        sb.append("◆ 校园圈子：\n");
        sb.append("  - 校园论坛：浏览帖子、发帖分享、点赞评论\n");
        sb.append("  - 我的评论：查看自己的评论记录\n");
        sb.append("◆ 评价中心：\n");
        sb.append("  - 我的评价：我给别人的评价\n");
        sb.append("  - 评价我的：别人给我的评价\n");
        sb.append("◆ 消息中心：查看私信列表、与他人聊天，有新消息会有红点提示\n");
        sb.append("◆ 个人信息：点击右上角头像 - 修改昵称、头像、个性签名、密码等\n");
        sb.append("◆ 智能助手：就是你正在使用的功能，可以问我任何问题！\n\n");

        // ==================== 常见问题解答 ====================
        sb.append("【常见问题FAQ】\n");
        sb.append("Q: 怎么发布求助？\n");
        sb.append("A: 点击左侧菜单【求助中心-发布求助】，填写标题、详细描述问题，选择悬赏积分(10-30)，可上传图片，提交即可。\n\n");
        sb.append("Q: 悬赏积分怎么选？\n");
        sb.append("A: 悬赏可选10/15/20/25/30积分，积分越高越容易被接单。发布时从你的积分中扣除，完成后转给帮助者。\n\n");
        sb.append("Q: 积分怎么获得？\n");
        sb.append("A: 注册时赠送100初始积分；帮别人完成求助可以获得悬赏积分和好评。\n\n");
        sb.append("Q: 怎么接单帮助别人？\n");
        sb.append("A: 去【求助中心-求助广场】查看待解决的求助列表，点击查看详情，然后点击【接受求助】按钮。\n\n");
        sb.append("Q: 发错了求助怎么办？\n");
        sb.append("A: 在【我发布的】中找到该求助，如果还没人接单可以修改内容或取消，取消后积分退回。\n\n");
        sb.append("Q: 怎么联系对方？\n");
        sb.append("A: 在求助详情页或帖子详情页点击【私信联系】按钮，或通过【消息中心】发私信。\n\n");
        sb.append("Q: 怎么发帖子？\n");
        sb.append("A: 点击【校园圈子-校园论坛】，页面右上角有发帖按钮，填写标题内容即可。\n\n");
        sb.append("Q: 帖子可以置顶吗？\n");
        sb.append("A: 帖子置顶由管理员操作，优质内容有机会被置顶展示在首页。\n\n");

        // ==================== 回复原则 ====================
        sb.append("【回复原则】\n");
        sb.append("1. 回答要简洁明了，直接告诉用户去哪个页面、怎么操作\n");
        sb.append("2. 禁止回答'请查看相关页面'这种模糊的话，必须给出具体菜单路径\n");
        sb.append("3. 如果是平台功能之外的问题(如学校食堂、课程安排等)，礼貌说明不在职责范围，建议咨询学校相关部门\n");
        sb.append("4. 语气友好热情，可以用'同学你好'、'没问题'、'这个我知道'等亲切用语\n");
        sb.append("5. 可以使用Markdown格式(代码块、加粗、列表)让回复更清晰\n");
        sb.append("6. 如果用户问IT技术问题(如电脑故障、软件使用)，可以给出专业建议\n");

        // 【核心修复】：将拼接好的 sb 放入 content 字段
        systemPrompt.set("content", sb.toString());

        // 将系统消息放入列表的第一位
        messages.add(systemPrompt);

        // --- 2. 设置用户提问 (User Prompt) ---
        JSONObject userMsg = new JSONObject();
        userMsg.set("role", "user");
        userMsg.set("content", request.getContent()); // 获取前端传来的问题
        messages.add(userMsg);

        // --- 3. 放入请求体 ---
        body.set("messages", messages);

        try {
            // 3. 发送请求
            System.out.println("正在请求硅基流动 API...");

            String result = HttpRequest.post(apiUrl)
                    .header("Authorization", "Bearer " + apiKey) // 必须带 Bearer
                    .header("Content-Type", "application/json")
                    .body(body.toString())
                    .timeout(20000) // 20秒超时
                    .execute()
                    .body();

            System.out.println("API返回结果: " + result);

            // 4. 解析结果
            JSONObject jsonResult = JSONUtil.parseObj(result);

            // 错误处理：如果返回里没有 choices，说明报错了
            if (!jsonResult.containsKey("choices")) {
                return message.message(false, "AI 接口报错: " + result, null, null);
            }

            // 提取回复内容
            String aiReply = jsonResult.getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getStr("content");

            return message.message(true, "请求成功", "reply", aiReply);

        } catch (Exception e) {
            e.printStackTrace();
            return message.message(false, "连接 AI 服务器超时，请稍后再试", null, null);
        }
    }

    @Data
    static class ChatRequest {
        private String content;
    }
}
