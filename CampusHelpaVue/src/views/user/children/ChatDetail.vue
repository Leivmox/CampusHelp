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
      <el-dropdown trigger="click" @command="handleCommand">
        <i class="el-icon-more" style="cursor: pointer; color: #909399"></i>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="clear" icon="el-icon-delete">清空聊天记录</el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
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
          :key="msg.id || index"
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

            <div class="bubble" :class="{ 'no-bg': msg.type === 1 || msg.type === 2 }">
              <div v-if="msg.type === 1" class="image-msg">
                <el-image 
                  :src="baseUrl + msg.content" 
                  fit="cover"
                  :preview-src-list="[baseUrl + msg.content]"
                  class="chat-image"
                >
                  <div slot="error" class="image-error">
                    <i class="el-icon-picture-outline"></i>
                    <span>图片加载失败</span>
                  </div>
                </el-image>
              </div>
              <div v-else-if="msg.type === 2" class="emoji-msg">
                <img :src="getEmojiUrl(msg.content)" class="emoji-image" />
              </div>
              <div v-else class="text">{{ msg.content }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="chat-footer">
      <el-popover
        placement="top"
        width="380"
        trigger="click"
        v-model="emojiPickerVisible"
      >
        <div class="emoji-picker">
          <div class="emoji-grid">
            <span 
              v-for="(emoji, index) in emojiList" 
              :key="index"
              class="emoji-item"
              @click="sendEmoji(emoji)"
            >
              <img :src="getEmojiUrl(emoji)" class="emoji-thumb" />
            </span>
          </div>
        </div>
        <el-button slot="reference" icon="el-icon-star-on" circle></el-button>
      </el-popover>
      <el-upload
        action="http://localhost:8080/common/upload"
        :data="{ type: 'chat' }"
        name="file"
        :show-file-list="false"
        :on-success="handleImageSuccess"
        :before-upload="beforeImageUpload"
        accept="image/*"
      >
        <el-button icon="el-icon-picture" circle></el-button>
      </el-upload>
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
import { formatDate } from "@/util/date";

const emojiContext = require.context('@/assets/emoji', false, /\.gif$/);
const emojiList = emojiContext.keys().map(key => key.replace('./', ''));

export default {
  name: "ChatDetail",
  data() {
    return {
      baseUrl: "http://localhost:8080",
      targetUserId: null,
      targetUser: {},
      msgList: [],
      inputContent: "",
      loading: false,
      timer: null,
      emojiPickerVisible: false,
      emojiList: emojiList
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    this.targetUserId = this.$route.query.toUser;
    
    if (!this.targetUserId) {
      this.$msg("参数错误，无法聊天", "error");
      this.$router.go(-1);
      return;
    }

    this.initData();

    this.timer = setInterval(() => {
      this.getMessages(true);
    }, 3000);
  },
  beforeDestroy() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
  methods: {
    async initData() {
      this.loading = true;
      await this.getTargetUserInfo();
      await this.getMessages();
      this.loading = false;
      this.scrollToBottom();
    },

    getTargetUserInfo() {
      return this.$get(`/user/${this.targetUserId}`).then((res) => {
        if (res.data.status || res.data.user) {
          this.targetUser = res.data.user || res.data.data;
        }
      });
    },

    getMessages(silent = false) {
      return this.$get("/chat/history", {
        userId: this.user.id,
        targetId: this.targetUserId
      }, silent).then((res) => {
        if (res.data.status) {
          const newMessages = res.data.list || [];
          
          if (silent) {
            const hasNewMessages = this.hasNewMessages(newMessages);
            if (hasNewMessages) {
              const wasAtBottom = this.isScrolledToBottom();
              this.msgList = newMessages;
              if (wasAtBottom) {
                this.$nextTick(() => this.scrollToBottom());
              }
            }
          } else {
            this.msgList = newMessages;
          }
        }
      }).catch(err => {
         if(!silent) console.error(err);
      });
    },

    isScrolledToBottom() {
      const div = this.$refs.chatBox;
      if (!div) return true;
      const threshold = 100;
      return div.scrollHeight - div.scrollTop - div.clientHeight < threshold;
    },

    hasNewMessages(newMessages) {
      if (newMessages.length !== this.msgList.length) {
        return newMessages.length > this.msgList.length;
      }
      
      if (newMessages.length === 0) return false;
      
      const newLast = newMessages[newMessages.length - 1];
      const oldLast = this.msgList[this.msgList.length - 1];
      
      if (newLast.id && oldLast.id) {
        return newLast.id !== oldLast.id;
      }
      
      if (newLast.createTime && oldLast.createTime) {
        const newTime = new Date(newLast.createTime).getTime();
        const oldTime = new Date(oldLast.createTime).getTime();
        return newTime !== oldTime;
      }
      
      return newLast.content !== oldLast.content;
    },

    sendMessage() {
      if (!this.inputContent.trim()) return;

      const content = this.inputContent;
      this.inputContent = "";

      this.$post("/chat/send", {
        senderId: this.user.id,
        receiverId: this.targetUserId,
        content: content,
        type: 0
      }).then((res) => {
        if (res.data.status) {
          this.msgList.push({
             senderId: this.user.id,
             receiverId: this.targetUserId,
             content: content,
             type: 0,
             createTime: new Date(),
             avatar: this.user.avatar
          });
          this.scrollToBottom();
        } else {
          this.$msg("发送失败", "error");
          this.inputContent = content;
        }
      });
    },

    sendEmoji(emoji) {
      this.emojiPickerVisible = false;
      
      this.$post("/chat/send", {
        senderId: this.user.id,
        receiverId: this.targetUserId,
        content: emoji,
        type: 2
      }).then((res) => {
        if (res.data.status) {
          this.msgList.push({
            senderId: this.user.id,
            receiverId: this.targetUserId,
            content: emoji,
            type: 2,
            createTime: new Date(),
            avatar: this.user.avatar
          });
          this.scrollToBottom();
        } else {
          this.$msg("发送失败", "error");
        }
      });
    },

    beforeImageUpload(file) {
      const isImage = file.type.startsWith('image/');
      const isLt5M = file.size / 1024 / 1024 < 5;

      if (!isImage) {
        this.$msg("只能上传图片文件", "error");
        return false;
      }
      if (!isLt5M) {
        this.$msg("图片大小不能超过 5MB", "error");
        return false;
      }
      return true;
    },

    handleImageSuccess(res) {
      if (res.url) {
        this.$post("/chat/send", {
          senderId: this.user.id,
          receiverId: this.targetUserId,
          content: res.url,
          type: 1
        }).then((response) => {
          if (response.data.status) {
            this.msgList.push({
              senderId: this.user.id,
              receiverId: this.targetUserId,
              content: res.url,
              type: 1,
              createTime: new Date(),
              avatar: this.user.avatar
            });
            this.scrollToBottom();
          } else {
            this.$msg("图片发送失败", "error");
          }
        });
      } else {
        this.$msg("图片上传失败", "error");
      }
    },

    handleCommand(command) {
      if (command === "clear") {
        this.clearChatHistory();
      }
    },

    clearChatHistory() {
      this.$confirm("确定要清空与该用户的所有聊天记录吗？此操作不可恢复。", "清空聊天记录", {
        type: "warning"
      }).then(() => {
        this.$del("/chat/clear", {
          userId: this.user.id,
          targetId: this.targetUserId
        }).then((res) => {
          if (res.data.status) {
            this.$msg("聊天记录已清空", "success");
            this.msgList = [];
          } else {
            this.$msg(res.data.msg || "清空失败", "error");
          }
        }).catch(err => {
          console.error(err);
          this.$msg("清空失败", "error");
        });
      }).catch(() => {});
    },

    scrollToBottom() {
      this.$nextTick(() => {
        const div = this.$refs.chatBox;
        if (div) {
          div.scrollTop = div.scrollHeight;
        }
      });
    },

    getAvatarUrl(u) {
      if (!u || !u.avatar) return "";
      if (u.avatar.startsWith("http")) return u.avatar;
      return this.baseUrl + u.avatar;
    },

    getEmojiUrl(filename) {
      return require(`@/assets/emoji/${filename}`);
    },
    
    getAvatarText(name) {
      if (!name) return "U";
      return name.charAt(0).toUpperCase();
    },
    
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
@me-bg: #95ec69;
@other-bg: #ffffff;
@bg-color: #f5f5f5;

.chat-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px);
  background-color: @bg-color;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);

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

  .chat-main {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
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

      &.other {
        align-items: flex-start;
        
        .msg-content-box {
          flex-direction: row;
          .avatar { margin-right: 10px; background-color: #409eff;}
          .bubble {
            background-color: @other-bg;
            color: #333;
            border-top-left-radius: 0;
          }
        }
      }

      &.me {
        align-items: flex-end;

        .msg-content-box {
          flex-direction: row-reverse;
          .avatar { margin-left: 10px; background-color: #ff9900; }
          .bubble {
            background-color: @me-bg;
            color: #000;
            border-top-right-radius: 0;
          }
        }
      }

      .bubble {
        padding: 10px 14px;
        border-radius: 8px;
        box-shadow: 0 1px 2px rgba(0,0,0,0.1);
        font-size: 15px;
        line-height: 1.5;
        word-break: break-all;
        position: relative;
        margin-top: 2px;

        &.no-bg {
          background: transparent !important;
          padding: 0;
          box-shadow: none;
        }

        .image-msg {
          .chat-image {
            max-width: 200px;
            max-height: 200px;
            border-radius: 8px;
            cursor: pointer;
            display: block;
          }

          .image-error {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 150px;
            height: 100px;
            background: #f5f7fa;
            color: #909399;
            font-size: 12px;

            i {
              font-size: 24px;
              margin-bottom: 5px;
            }
          }
        }

        .emoji-msg {
          .emoji-image {
            width: 80px;
            height: 80px;
            display: block;
          }
        }
      }
      
      &.me .bubble.no-bg {
        border-top-right-radius: 0;
      }
      
      &.other .bubble.no-bg {
        border-top-left-radius: 0;
      }
    }
  }

  .chat-footer {
    min-height: 60px;
    background-color: #fff;
    border-top: 1px solid #e4e7ed;
    display: flex;
    align-items: center;
    padding: 10px 15px;
    flex-shrink: 0;
    gap: 10px;

    .input-area {
      flex: 1;
    }
  }
}

.emoji-picker {
  .emoji-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 8px;
    max-height: 250px;
    overflow-y: auto;
    overflow-x: hidden;

    .emoji-item {
      text-align: center;
      cursor: pointer;
      padding: 5px;
      border-radius: 8px;
      transition: background-color 0.2s;
      background: #f9f9f9;

      &:hover {
        background-color: #e6f7ff;
      }

      .emoji-thumb {
        width: 40px;
        height: 40px;
        object-fit: contain;
      }
    }
  }
}
</style>
