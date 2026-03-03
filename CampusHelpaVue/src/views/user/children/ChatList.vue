<template>
  <div class="content">
    <el-alert
      title="消息中心 - 查看最近的私信记录"
      :closable="false"
      type="warning"
      style="margin-bottom: 10px"
    >
    </el-alert>

    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold">我的消息</span>
        <el-button
          style="float: right; padding: 3px 0; font-size: 16px"
          icon="el-icon-refresh"
          type="text"
          @click="refreshList"
        >
          刷新
        </el-button>
      </div>

      <div v-if="chatList.length > 0">
        <div
          v-for="(item, index) in chatList"
          :key="index"
          class="chat-item"
        >
          <div class="chat-left" @click="toChat(item.targetUser.id, item.unreadCount)">
            <el-avatar
              :size="50"
              :src="getResUrl(item.targetUser.avatar)"
              style="background-color: #409eff; flex-shrink: 0;"
            >
              {{ getAvatarText(item.targetUser.username) }}
            </el-avatar>
            
            <div class="chat-info">
              <div class="name-row">
                <span class="username">{{ item.targetUser.username }}</span>
                <el-tag size="mini" effect="plain" v-if="item.unreadCount > 0" type="danger">
                  {{ item.unreadCount }} 条未读
                </el-tag>
              </div>
              <p class="last-msg">{{ formatLastMessage(item) }}</p>
            </div>
          </div>

          <div class="chat-right">
            <span class="time">{{ item.lastTime | formatDate }}</span>
            <div class="action-row">
              <span v-if="item.unreadCount > 0" class="unread-dot"></span>
              <el-button size="small" type="primary" plain round @click="toChat(item.targetUser.id, item.unreadCount)">
                发消息
              </el-button>
              <el-button size="small" type="danger" plain round icon="el-icon-delete" @click="deleteChat(item)">
                删除
              </el-button>
            </div>
          </div>
        </div>
      </div>
      
      <el-empty v-else description="暂无最近联系人"></el-empty>
    </el-card>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";

export default {
  name: "ChatList",
  data() {
    return {
      baseUrl: "http://localhost:8080",
      chatList: [],
      timer: null,
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    this.getChatList();
    this.startPolling();
  },
  beforeDestroy() {
    this.stopPolling();
  },
  activated() {
    this.getChatList();
    this.startPolling();
  },
  deactivated() {
    this.stopPolling();
  },
  methods: {
    getResUrl(url) {
      if (!url) return "";
      if (url.startsWith("http")) return url;
      return this.baseUrl + url;
    },
    
    getAvatarText(username) {
      if (!username) return "U";
      return username.charAt(0).toUpperCase();
    },

    formatLastMessage(item) {
      if (!item.lastMessage) return '暂无消息内容';
      if (item.lastMessageType === 1) return '[图片]';
      if (item.lastMessageType === 2) return '[表情]';
      return item.lastMessage;
    },
    
    startPolling() {
      if (this.timer) return;
      this.timer = setInterval(() => {
        this.getChatList(true);
      }, 3000);
    },
    
    stopPolling() {
      if (this.timer) {
        clearInterval(this.timer);
        this.timer = null;
      }
    },
    
    refreshList() {
      this.getChatList();
    },
    
    getChatList(silent = false) {
      this.$get("/chat/recent", { userId: this.user.id }, silent).then(res => {
        if(res.data.status && res.data.list) {
          const newList = res.data.list;
          const hasChanged = this.checkListChanged(newList);
          
          if (hasChanged) {
            this.chatList = newList;
          }
        }
      }).catch(() => {
        if(!silent) {
          console.log("获取消息列表失败");
        }
      });
    },
    
    checkListChanged(newList) {
      if (newList.length !== this.chatList.length) {
        return true;
      }
      
      for (let i = 0; i < newList.length; i++) {
        const newItem = newList[i];
        const oldItem = this.chatList[i];
        
        if (newItem.unreadCount !== oldItem.unreadCount) {
          return true;
        }
        if (newItem.lastMessage !== oldItem.lastMessage) {
          return true;
        }
        if (newItem.lastTime !== oldItem.lastTime) {
          return true;
        }
      }
      
      return false;
    },

    toChat(targetUserId, unreadCount) {
      this.$router.push({
        path: "/home/chat/detail",
        query: { toUser: targetUserId },
      });
    },

    deleteChat(item) {
      this.$confirm(
        `确定删除与 ${item.targetUser.username} 的聊天吗？聊天记录将被清空。`,
        "删除聊天",
        { type: "warning" }
      ).then(() => {
        this.$del("/chat/delete", {
          userId: this.user.id,
          targetId: item.targetUser.id
        }).then((res) => {
          if (res.data.status) {
            this.$msg("聊天已删除", "success");
            this.chatList = this.chatList.filter(
              c => c.targetUser.id !== item.targetUser.id
            );
          } else {
            this.$msg(res.data.msg || "删除失败", "error");
          }
        }).catch(err => {
          console.error(err);
          this.$msg("删除失败", "error");
        });
      }).catch(() => {});
    },
  },
  filters: {
    formatDate(time) {
      if (!time) return "";
      let date = new Date(time);
      return formatDate(date, "MM-dd hh:mm");
    },
  },
};
</script>

<style scoped lang="less">
.content {
  background: transparent;
  margin: 0;
  padding: 10px 0;

  .box-card {
    border-radius: 8px;
    border: none;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  }

  .chat-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 10px;
    border-bottom: 1px solid #f0f0f0;
    transition: background-color 0.2s;

    &:hover {
      background-color: #f9faff;
    }

    &:last-child {
      border-bottom: none;
    }

    .chat-left {
      display: flex;
      align-items: center;
      flex: 1;
      cursor: pointer;
      
      .chat-info {
        margin-left: 15px;
        display: flex;
        flex-direction: column;
        justify-content: center;

        .name-row {
            display: flex;
            align-items: center;
            margin-bottom: 5px;

            .username {
                font-weight: bold;
                font-size: 16px;
                color: #333;
                margin-right: 10px;
            }
        }

        .last-msg {
            color: #909399;
            font-size: 14px;
            margin: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            max-width: 400px;
        }
      }
    }

    .chat-right {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      
      .time {
        color: #c0c4cc;
        font-size: 12px;
        margin-bottom: 8px;
      }
      
      .action-row {
        display: flex;
        align-items: center;
        gap: 8px;
      }
      
      .unread-dot {
        width: 10px;
        height: 10px;
        background-color: #f56c6c;
        border-radius: 50%;
        animation: pulse 1.5s infinite;
      }
    }
  }
}

@keyframes pulse {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.2);
    opacity: 0.7;
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}
</style>
