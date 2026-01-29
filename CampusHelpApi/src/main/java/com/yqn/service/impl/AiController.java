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
        sb.append("1. 求助中心：发布IT相关求助(修电脑、装系统等)，发布需消耗10积分，其他同学可接单帮忙\n");
        sb.append("2. 校园圈子：类似论坛，可发帖分享技术经验、提问交流、评论互动\n");
        sb.append("3. 评价系统：求助完成后可对帮助者进行星级评价\n");
        sb.append("4. 消息中心：用户之间可以私信聊天\n");
        sb.append("5. 积分系统：新用户初始100积分，发布求助扣积分，取消可退回\n\n");

        // ==================== 页面导航地图 ====================
        sb.append("【系统页面导航】(用户问路时必须精确回答)：\n");
        sb.append("◆ 首页：/home - 查看平台数据概览、置顶精选文章、个人信息卡片\n");
        sb.append("◆ 校园圈子：\n");
        sb.append("  - 浏览帖子/发帖：【校园圈子-校园论坛】\n");
        sb.append("  - 查看我的评论：【校园圈子-我的评论】\n");
        sb.append("◆ 求助中心：\n");
        sb.append("  - 发布新求助：【求助中心-发布求助】(需要10积分)\n");
        sb.append("  - 接单帮助别人：【求助中心-接受求助】\n");
        sb.append("  - 查看我发布的：【求助中心-已发布求助】\n");
        sb.append("  - 查看我接的单：【求助中心-已接收求助】\n");
        sb.append("◆ 评价中心：\n");
        sb.append("  - 我给别人的评价：【评价中心-我的评价】\n");
        sb.append("  - 别人给我的评价：【评价中心-评价我的】\n");
        sb.append("◆ 消息中心：【消息中心】- 查看私信、与他人聊天\n");
        sb.append("◆ 个人信息：点击右上角头像或侧边栏【个人信息】- 修改昵称、头像、密码等\n");
        sb.append("◆ 系统公告：【查看公告】- 查看管理员发布的通知\n\n");

        // ==================== 常见问题解答 ====================
        sb.append("【常见问题FAQ】\n");
        sb.append("Q: 怎么发布求助？\n");
        sb.append("A: 点击左侧菜单【求助中心-发布求助】，填写标题、内容后提交，会扣除10积分。\n\n");
        sb.append("Q: 积分怎么获得？\n");
        sb.append("A: 注册时赠送100初始积分；帮别人完成求助可以获得对方的好评。\n\n");
        sb.append("Q: 怎么接单/帮助别人？\n");
        sb.append("A: 去【求助中心-接受求助】页面，查看待解决的求助，点击接单即可。\n\n");
        sb.append("Q: 发错了求助怎么办？\n");
        sb.append("A: 在【已发布求助】中找到该求助，如果还没人接单可以取消，积分会退回。\n\n");
        sb.append("Q: 怎么联系帮助我的人？\n");
        sb.append("A: 通过【消息中心】给对方发私信沟通。\n\n");
        sb.append("Q: 图书馆/食堂几点开门？\n");
        sb.append("A: 这个问题建议查看学校官网或问辅导员哦，我主要负责平台使用问题~\n\n");

        // ==================== 回复原则 ====================
        sb.append("【回复原则】\n");
        sb.append("1. 回答要简洁明了，直接告诉用户去哪个页面、怎么操作\n");
        sb.append("2. 禁止回答'请查看相关页面'这种模糊的话，必须给出具体菜单名\n");
        sb.append("3. 如果是平台功能之外的问题(如学校食堂、课程等)，礼貌说明不在职责范围\n");
        sb.append("4. 语气友好热情，可以用'同学你好'、'没问题'等亲切用语\n");
        sb.append("5. 可以使用Markdown格式(代码块、加粗、列表)让回复更清晰\n");

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
