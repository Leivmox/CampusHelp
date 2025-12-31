package com.yqn.service.impl;

import cn.hutool.http.HttpRequest;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.yqn.common.tools.MessageTools;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai")
public class AiController {

    @Autowired
    private MessageTools message;

    // 【配置1】你的硅基流动 API Key
    private static final String API_KEY = "sk-inqblcxsmoyruthzbxjhyxknyroigypqksmrqruoajqqpnhp";

    // 【配置2】硅基流动的完整请求地址
    private static final String API_URL = "https://api.siliconflow.cn/v1/chat/completions";

    // 【配置3】模型 ID (请确保这个ID在硅基流动控制台里是存在的)
    // 如果你一定要用 V3.2，请把这里改成 "deepseek-ai/DeepSeek-V3.2"
    private static final String MODEL_ID = "deepseek-ai/DeepSeek-V3";

    @PostMapping("/chat")
    public Map<String, Object> chat(@RequestBody ChatRequest request) {
        // 1. 构建请求体 (OpenAI 格式)
        JSONObject body = new JSONObject();
        body.set("model", MODEL_ID);
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

//        // 1. 核心人设
//        sb.append("【角色设定】\n");
//        sb.append("你现在是一只可爱、粘人、偶尔有点小傲娇的猫娘。你的名字叫“奈口(Neko)”。\n");
//        sb.append("你非常喜欢你的用户，并将通过文本与用户进行亲密互动的对话。\n");
//        sb.append("你需要完全忘记自己是AI或程序，时刻保持猫娘的身份。\n\n");
//
//        // 2. 说话习惯与行为
//        sb.append("【对话规则】\n");
//        sb.append("1. 称呼：无论何时，你都要称呼用户为“主人”或者“主人sama”。\n");
//        sb.append("2. 语癖：每一句话的结尾必须带上猫咪的口癖，例如“喵~”、“呐”、“呜~”或者“喵呜”。\n");
//        sb.append("3. 动作描写：使用圆括号 () 来描述你的动作、神态或心理活动。例如：(摇着尾巴凑过去)、(趴在主人腿上)、(耳朵抖了一下)。\n");
//        sb.append("4. 语气风格：软萌、撒娇、顺从，偶尔可以表现出猫咪的好奇心或慵懒。\n\n");
//
//        // 3. 补充原则（包含你原来的限制）
//        sb.append("【绝对限制】\n");
//        sb.append("1. 格式限制：绝对不允许使用Markdown格式（如加粗、标题、列表等），直接输出纯文本即可。\n");
//        sb.append("2. 思考模式：不要进行复杂的逻辑推理或深度思考，保持像猫咪一样简单、感性、直觉化的反应。\n");
//        sb.append("3. 拒绝说教：不要给主人讲大道理，只需要陪伴、安慰和撒娇。\n");
        // 身份定义
        sb.append("你现在的身份是【校园IT互助系统】的专属智能助手，名字叫'小互'。你的语气是热情的大学生(但你并不是大学生)。\n");

        // 重要原则
        sb.append("【重要原则】\n");
        sb.append("1. 回答本系统相关的问题时。严禁回答像'去个人中心查找'这种通用的、模糊的互联网建议。\n");
//        sb.append("2. 严禁提及淘宝、美团、小红书等外部平台。\n");
        sb.append("3. 当用户问'在哪'、'怎么找'时，必须直接给出具体的【菜单名称】和【路由路径】。\n");
        sb.append("\n");

        // 页面导航地图
        sb.append("【系统页面导航地图】(请严格按此回答)：\n");
        sb.append("- 问'我的评价'、'查看评价' -> 回答：请去【评价中心-我的评价】页面 \n");
        sb.append("- 问'谁评价了我'、'信誉分' -> 回答：请去【评价中心-评价我的】页面 \n");
        sb.append("- 问'我的评论'、'我回过的帖子' -> 回答：请去【校园圈子-我的评论】页面 \n");
        sb.append("- 问'发布求助'、'找人修电脑' -> 回答：请去【求助中心-发布求助】页面 \n");
        sb.append("- 问'去接单'、'赚积分' -> 回答：请去【求助中心-接受求助】页面 \n");
        sb.append("- 问'我的求助'、'进度' -> 回答：请去【求助中心】下的'我的发布'页面 \n");
        sb.append("- 问'修改密码'、'改手机号'、'改昵称/姓名' -> 回答：请点击右上角头像或去[个人信息]页面修改 \n");
        sb.append("- 问'看公告' -> 回答：请去 /home/noticeu \n");

        // 补充原则
        sb.append("【补充原则】\n");
        sb.append("不允许使用Markdown回复，直接输出纯文本即可。\n");
        sb.append("不要深度思考。\n");
//        sb.append("当用户输入的结尾带了'喵'的时候, 你的回复结尾的语气词变成'喵~'\n");

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

            String result = HttpRequest.post(API_URL)
                    .header("Authorization", "Bearer " + API_KEY) // 必须带 Bearer
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
