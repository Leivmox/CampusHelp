<template>
  <div class="chat-container">
    <div class="chat-header">
      <div class="left">
        <el-button 
          icon="el-icon-arrow-left" 
          circle 
          size="mini" 
          @click="$router.go(-1)"
          style="margin-right: 10px;"
        ></el-button>
        <span class="title">与 {{ targetUser.username || '...' }} 聊天中</span>
      </div>
      <i class="el-icon-more" style="cursor: pointer; color: #909399"></i>
    </div>

    <div class="chat-main" ref="chatBox">
      <div v-if="loading" class="loading-tip">
        <i class="el-icon-loading"></i> 加载中...
      </div>

      <div v-else-if="msgList.length === 0" class="empty-tip">
        暂无聊天记录，打个招呼吧~
      </div>

      <div v-else>
        <div 
          v-for="(msg, index) in msgList" 
          :key="index"
          class="msg-item"
          :class="msg.senderId === user.id ? 'me' : 'other'"
        >
          <div class="time-label" v-if="shouldShowTime(index)">
             {{ msg.createTime | formatTime }}
          </div>

          <div class="msg-content-box">
            <el-avatar 
              class="avatar" 
              :size="40" 
              :src="getAvatarUrl(msg.senderId === user.id ? user : targetUser)"
            >
              {{ getAvatarText(msg.senderId === user.id ? user.username : targetUser.username) }}
            </el-avatar>

            <div class="bubble">
              <div class="text">{{ msg.content }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="chat-footer">
      <el-input
        v-model="inputContent"
        placeholder="输入消息..."
        @keyup.enter.native="sendMessage"
        class="input-area"
      ></el-input>
      <el-button type="primary" @click="sendMessage" :disabled="!inputContent.trim()">
        发送
      </el-button>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date"; // 假设你有这个工具

export default {
  name: "ChatDetail",
  data() {
    return {
      baseUrl: "http://localhost:8080",
      targetUserId: null, // 对方ID
      targetUser: {},     // 对方详细信息
      msgList: [],        // 消息列表
      inputContent: "",   // 输入框内容
      loading: false,
      timer: null,        // 定时器用于轮询消息
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    // 1. 获取路由参数中的对方ID
    this.targetUserId = this.$route.query.toUser;
    
    if (!this.targetUserId) {
      this.$msg("参数错误，无法聊天", "error");
      this.$router.go(-1);
      return;
    }

    // 2. 初始化
    this.initData();

    // 3. 开启轮询 (每3秒拉取一次最新消息，模拟实时)
    // 如果你有 WebSocket，这里换成 WebSocket监听
    this.timer = setInterval(() => {
      this.getMessages(true); // true 表示静默刷新，不显示 loading
    }, 3000);
  },
  beforeDestroy() {
    // 页面销毁前清除定时器
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
  methods: {
    // 初始化：获取对方信息 + 获取历史记录
    async initData() {
      this.loading = true;
      await this.getTargetUserInfo();
      await this.getMessages();
      this.loading = false;
      this.scrollToBottom();
    },

    // 获取对方信息
    getTargetUserInfo() {
      return this.$get(`/user/${this.targetUserId}`).then((res) => {
        if (res.data.status || res.data.user) {
          // 兼容你的后端返回结构，可能是 res.data.user 或 res.data.data
          this.targetUser = res.data.user || res.data.data;
        }
      });
    },

    // 获取消息记录
    getMessages(silent = false) {
      // 假设接口： GET /chat/history?userId=我的ID&targetId=对方ID
      return this.$get("/chat/history", {
        userId: this.user.id,
        targetId: this.targetUserId
      }).then((res) => {
        if (res.data.status) {
          const newMessages = res.data.list || [];
          
          // 如果消息数量变多了，说明有新消息，需要滚动到底部
          if (newMessages.length > this.msgList.length) {
            this.msgList = newMessages;
            this.scrollToBottom();
          } else {
            // 数量一样也更新一下，防止状态变化
            this.msgList = newMessages;
          }
        }
      }).catch(err => {
         if(!silent) console.error(err);
      });
    },

    // 发送消息
    sendMessage() {
      if (!this.inputContent.trim()) return;

      const content = this.inputContent; // 暂存
      this.inputContent = ""; // 先清空输入框，体验更好

      // 假设接口：POST /chat/send
      this.$post("/chat/send", {
        senderId: this.user.id,
        receiverId: this.targetUserId,
        content: content,
        type: 0 // 0代表文本
      }).then((res) => {
        if (res.data.status) {
          // 发送成功后，手动把这条消息加到列表里 (或者立即调一次 getMessages)
          // 这里为了流畅，手动 push 一条假的，等轮询或者刷新来同步
          this.msgList.push({
             senderId: this.user.id,
             receiverId: this.targetUserId,
             content: content,
             createTime: new Date(),
             avatar: this.user.avatar // 临时显示
          });
          this.scrollToBottom();
        } else {
          this.$msg("发送失败", "error");
          this.inputContent = content; // 失败还原文本
        }
      });
    },

    // 滚动到底部
    scrollToBottom() {
      this.$nextTick(() => {
        const div = this.$refs.chatBox;
        if (div) {
          div.scrollTop = div.scrollHeight;
        }
      });
    },

    // 工具函数：获取头像链接
    getAvatarUrl(u) {
      if (!u || !u.avatar) return "";
      if (u.avatar.startsWith("http")) return u.avatar;
      return this.baseUrl + u.avatar;
    },
    // 工具函数：文字头像
    getAvatarText(name) {
      if (!name) return "U";
      return name.charAt(0).toUpperCase();
    },
    // 判断是否显示时间 (两条消息间隔超过5分钟才显示)
    shouldShowTime(index) {
      if (index === 0) return true;
      const current = new Date(this.msgList[index].createTime).getTime();
      const prev = new Date(this.msgList[index - 1].createTime).getTime();
      return (current - prev) > 5 * 60 * 1000;
    }
  },
  filters: {
    formatTime(val) {
      if(!val) return "";
      return formatDate(new Date(val), "MM-dd hh:mm");
    }
  }
};
</script>

<style scoped lang="less">
/* 定义气泡颜色变量 */
@me-bg: #95ec69;      /* 微信绿 */
@other-bg: #ffffff;   /* 白色 */
@bg-color: #f5f5f5;   /* 聊天背景灰 */

.chat-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px); /* 减去顶部导航的高度，根据实际调整 */
  background-color: @bg-color;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);

  /* 1. 顶部样式 */
  .chat-header {
    height: 50px;
    background-color: #fff;
    border-bottom: 1px solid #e4e7ed;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 15px;
    flex-shrink: 0;

    .left {
      display: flex;
      align-items: center;
      .title {
        font-weight: 600;
        font-size: 16px;
        color: #303133;
      }
    }
  }

  /* 2. 消息区域样式 */
  .chat-main {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
    /* 平滑滚动 */
    scroll-behavior: smooth; 

    .loading-tip, .empty-tip {
      text-align: center;
      color: #909399;
      margin-top: 20px;
      font-size: 14px;
    }

    .msg-item {
      margin-bottom: 20px;
      display: flex;
      flex-direction: column;

      .time-label {
        align-self: center;
        background-color: rgba(0,0,0,0.1);
        color: #fff;
        font-size: 12px;
        padding: 2px 8px;
        border-radius: 4px;
        margin-bottom: 10px;
      }

      .msg-content-box {
        display: flex;
        align-items: flex-start;
        max-width: 80%;
      }

      /* 对方的消息 (左侧) */
      &.other {
        align-items: flex-start;
        
        .msg-content-box {
          flex-direction: row;
          .avatar { margin-right: 10px; background-color: #409eff;}
          .bubble {
            background-color: @other-bg;
            color: #333;
            border-top-left-radius: 0; // 左上角尖角
          }
        }
      }

      /* 我的消息 (右侧) */
      &.me {
        align-items: flex-end;

        .msg-content-box {
          flex-direction: row-reverse;
          .avatar { margin-left: 10px; background-color: #ff9900; }
          .bubble {
            background-color: @me-bg;
            color: #000;
            border-top-right-radius: 0; // 右上角尖角
          }
        }
      }

      /* 通用气泡样式 */
      .bubble {
        padding: 10px 14px;
        border-radius: 8px;
        box-shadow: 0 1px 2px rgba(0,0,0,0.1);
        font-size: 15px;
        line-height: 1.5;
        word-break: break-all; /* 防止长英文不换行 */
        position: relative;
        margin-top: 2px;
      }
    }
  }

  /* 3. 底部输入区 */
  .chat-footer {
    min-height: 60px;
    background-color: #fff;
    border-top: 1px solid #e4e7ed;
    display: flex;
    align-items: center;
    padding: 10px 15px;
    flex-shrink: 0;

    .input-area {
      margin-right: 10px;
    }
  }
}
</style>