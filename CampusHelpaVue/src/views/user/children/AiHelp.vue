<template>
  <div class="ai-chat-container">
    <div class="chat-header">
      <div class="header-left">
        <i class="el-icon-magic-stick"></i>
        <span>智能助手 · 小互</span>
      </div>

      <el-tooltip content="清空当前对话并删除缓存" placement="top">
        <el-button
          type="text"
          icon="el-icon-delete"
          class="clear-btn"
          @click="handleClearHistory"
        >
          清空记录
        </el-button>
      </el-tooltip>
    </div>

    <div class="chat-body-wrapper">
      <div class="chat-body" ref="chatBody">
        <div
          v-for="(msg, index) in msgList"
          :key="index"
          :class="['chat-row', msg.role]"
        >
          <template v-if="msg.role === 'ai'">
            <el-avatar shape="circle" :src="aiAvatar" class="avatar" />
            <div class="bubble ai" v-html="renderMarkdown(msg.content)"></div>
            <el-tooltip content="复制" placement="top">
              <i class="el-icon-document-copy copy-btn" @click="copyText(msg.content)"></i>
            </el-tooltip>
          </template>

          <template v-else>
            <div class="bubble user">{{ msg.content }}</div>
            <el-avatar
              shape="circle"
              class="avatar user-avatar"
              :src="userAvatarUrl"
              style="background: #409eff; font-size: 14px; margin-left: 8px"
            >
              {{ userAvatarText }}
            </el-avatar>
          </template>
        </div>

        <div v-if="loading" class="chat-row ai">
          <el-avatar shape="circle" :src="aiAvatar" class="avatar" />
          <div class="bubble ai loading">
            <i class="el-icon-loading"></i> 小互正在思考…
          </div>
        </div>
      </div>
    </div>

    <div class="input-area">
      <div class="quick-questions">
        <span class="quick-label">快捷提问：</span>
        <el-tag 
          v-for="(q, idx) in quickQuestions" 
          :key="idx" 
          size="small" 
          effect="plain"
          class="quick-tag"
          @click="askQuickQuestion(q)"
        >
          {{ q }}
        </el-tag>
      </div>
      <div class="input-wrapper">
        <el-input
          v-model="inputMsg"
          type="textarea"
          :rows="3"
          resize="none"
          placeholder="请输入你的问题，回车发送"
          @keydown.enter.native.prevent="sendMsg"
        />
        <el-button
          type="primary"
          :loading="loading"
          @click="sendMsg"
          class="send-btn"
        >
          发送
        </el-button>
      </div>
    </div>
  </div>
</template>

<script>
import request from "@/util/request";
import { mapState } from "vuex";

export default {
  name: "AiChat",
  data() {
    return {
      inputMsg: "",
      loading: false,
      aiAvatar: (() => {
        try {
          return require("@/assets/img/avator_ai.jpg");
        } catch {
          return "";
        }
      })(),
      msgList: [],
      quickQuestions: [
        "怎么发布求助",
        "怎么接单帮助别人",
        "怎么获取积分",
        "悬赏积分怎么选",
        "怎么发帖子",
        "怎么联系对方",
        "发错了求助怎么办"
      ],
    };
  },
  computed: {
    ...mapState("user", ["user"]),

    cacheKey() {
      if (this.user && this.user.id) {
        return `ai_chat_history_${this.user.id}`;
      }
      return "ai_chat_history_guest";
    },

    userAvatarUrl() {
      if (!this.user || !this.user.avatar) return "";
      if (this.user.avatar.startsWith("http")) return this.user.avatar;
      return `http://localhost:8080${this.user.avatar}`;
    },
    userAvatarText() {
      if (!this.user || !this.user.username) return "U";
      return this.user.username.charAt(0).toUpperCase();
    },
  },
  watch: {
    msgList: {
      deep: true,
      handler(val) {
        if (val.length > 0) {
          localStorage.setItem(this.cacheKey, JSON.stringify(val));
        }
      },
    },
  },
  created() {
    this.initChatHistory();
  },
  methods: {
    initChatHistory() {
      const cached = localStorage.getItem(this.cacheKey);
      if (cached) {
        try {
          this.msgList = JSON.parse(cached);
          if (this.msgList.length === 0) this.addWelcomeMsg();
        } catch (e) {
          this.addWelcomeMsg();
        }
      } else {
        this.addWelcomeMsg();
      }
      this.scrollBottom();
    },

    addWelcomeMsg() {
      this.msgList = [
        {
          role: "ai",
          content: "你好，我是校园智能助手小互，有什么可以帮你？",
        },
      ];
    },

    handleClearHistory() {
      this.$confirm("确定要删除当前的所有对话记录吗？", "提示", {
        confirmButtonText: "确定删除",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.msgList = [];
          localStorage.removeItem(this.cacheKey);
          this.addWelcomeMsg();
          this.$msg("记录已清空", "success");
        })
        .catch(() => {});
    },

    sendMsg() {
      if (!this.inputMsg.trim() || this.loading) return;

      const text = this.inputMsg.trim();
      this.msgList.push({ role: "user", content: text });
      this.inputMsg = "";
      this.scrollBottom();
      this.loading = true;

      request({
        url: "/ai/chat",
        method: "post",
        data: { content: text },
        silent: true,
      })
        .then((res) => {
          const reply =
            res.reply || (res.data && res.data.reply) || "我暂时没理解你的问题";
          this.msgList.push({ role: "ai", content: reply });
        })
        .catch(() => {
          this.msgList.push({ role: "ai", content: "网络异常，请稍后再试" });
        })
        .finally(() => {
          this.loading = false;
          this.scrollBottom();
        });
    },

    scrollBottom() {
      this.$nextTick(() => {
        const el = this.$refs.chatBody;
        if (el) el.scrollTop = el.scrollHeight;
      });
    },

    renderMarkdown(text) {
      if (!text) return '';
      let html = text
        .replace(/```([\s\S]*?)```/g, '<pre class="code-block">$1</pre>')
        .replace(/`([^`]+)`/g, '<code class="inline-code">$1</code>')
        .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
        .replace(/\*([^*]+)\*/g, '<em>$1</em>')
        .replace(/^- (.+)$/gm, '<li>$1</li>')
        .replace(/^\d+\. (.+)$/gm, '<li>$1</li>')
        .replace(/\n/g, '<br>');
      if (html.includes('<li>')) {
        html = html.replace(/(<li>.*<\/li>)/gs, '<ul>$1</ul>');
      }
      return html;
    },

    copyText(text) {
      navigator.clipboard.writeText(text).then(() => {
        this.$msg('已复制到剪贴板', 'success');
      }).catch(() => {
        this.$msg('复制失败', 'error');
      });
    },

    askQuickQuestion(question) {
      this.inputMsg = question;
      this.sendMsg();
    },
  },
};
</script>

<style scoped>
.ai-chat-container {
  height: calc(100vh - 105px);
  display: flex;
  flex-direction: column;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
}

.chat-header {
  height: 60px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  background: #f8f9fa;
  border-bottom: 1px solid #e9ecef;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
  font-weight: bold;
  font-size: 18px;
  color: #333;
}

.clear-btn {
  color: #909399;
  font-size: 14px;
  padding: 0;
}
.clear-btn:hover {
  color: #f56c6c;
}

.chat-body-wrapper {
  flex: 1;
  min-height: 0;
  overflow: hidden;
  background: #f8f9fa;
}

.chat-body {
  height: 100%;
  padding: 20px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.chat-row {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  animation: fadeIn 0.3s ease-in;
}
.chat-row.ai {
  justify-content: flex-start;
}
.chat-row.user {
  justify-content: flex-end;
}
.avatar {
  width: 40px;
  height: 40px;
  flex-shrink: 0;
  margin-top: 4px;
  border-radius: 50%;
}
.user-avatar {
  background: #409eff;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  user-select: none;
}
.bubble {
  max-width: 70%;
  padding: 12px 16px;
  border-radius: 12px;
  font-size: 14px;
  line-height: 1.6;
  white-space: pre-wrap;
  word-break: break-word;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
  position: relative;
}
.bubble.ai {
  background: white;
  color: #333;
  border: 1px solid #e9ecef;
  border-top-left-radius: 4px;
}
.bubble.ai:before {
  content: "";
  position: absolute;
  left: -8px;
  top: 12px;
  width: 0;
  height: 0;
  border-top: 8px solid transparent;
  border-bottom: 8px solid transparent;
  border-right: 8px solid white;
}
.bubble.ai:after {
  content: "";
  position: absolute;
  left: -9px;
  top: 12px;
  width: 0;
  height: 0;
  border-top: 8px solid transparent;
  border-bottom: 8px solid transparent;
  border-right: 8px solid #e9ecef;
  z-index: -1;
}
.bubble.user {
  background: linear-gradient(135deg, #409eff, #337ecc);
  color: white;
  border-top-right-radius: 4px;
}
.bubble.user:before {
  content: "";
  position: absolute;
  right: -8px;
  top: 12px;
  width: 0;
  height: 0;
  border-top: 8px solid transparent;
  border-bottom: 8px solid transparent;
  border-left: 8px solid #409eff;
}
.bubble.loading {
  color: #666;
  background: #f0f0f0;
  border: 1px solid #e0e0e0;
}
.bubble.loading:before {
  display: none;
}
.input-area {
  flex-shrink: 0;
  background: #fff;
  border-top: 1px solid #e9ecef;
  padding: 16px 20px;
  box-shadow: 0 -1px 3px rgba(0, 0, 0, 0.05);
}

.quick-questions {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 12px;
}
.quick-label {
  font-size: 12px;
  color: #909399;
}
.quick-tag {
  cursor: pointer;
  transition: all 0.2s;
}
.quick-tag:hover {
  background: #409eff;
  color: white;
  border-color: #409eff;
}

.copy-btn {
  color: #c0c4cc;
  cursor: pointer;
  margin-left: 8px;
  font-size: 14px;
  opacity: 0;
  transition: all 0.2s;
}
.chat-row:hover .copy-btn {
  opacity: 1;
}
.copy-btn:hover {
  color: #409eff;
}

.bubble >>> .code-block {
  background: #2d2d2d;
  color: #f8f8f2;
  padding: 12px;
  border-radius: 6px;
  overflow-x: auto;
  font-family: 'Consolas', 'Monaco', monospace;
  font-size: 13px;
  margin: 8px 0;
  white-space: pre-wrap;
}
.bubble >>> .inline-code {
  background: #f0f0f0;
  color: #e83e8c;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Consolas', 'Monaco', monospace;
  font-size: 13px;
}
.bubble >>> ul {
  margin: 8px 0;
  padding-left: 20px;
}
.bubble >>> li {
  margin: 4px 0;
}
.input-wrapper {
  display: flex;
  gap: 12px;
  align-items: flex-end;
}
.input-wrapper >>> .el-textarea {
  flex: 1;
}
.input-wrapper >>> .el-textarea__inner {
  border: 1px solid #dcdfe6;
  border-radius: 6px;
  padding: 12px;
  font-size: 14px;
  line-height: 1.5;
  resize: none;
  transition: all 0.3s;
}
.input-wrapper >>> .el-textarea__inner:focus {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}
.send-btn {
  height: auto;
  padding: 12px 24px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
}
.send-btn:hover {
  opacity: 0.9;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);
}
.send-btn:active {
  transform: translateY(0);
}
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.chat-body::-webkit-scrollbar {
  width: 6px;
}
.chat-body::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}
.chat-body::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}
.chat-body::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
</style>
