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
          @click="getChatList"
        >
          刷新
        </el-button>
      </div>

      <div v-if="chatList.length > 0">
        <div
          v-for="(item, index) in chatList"
          :key="index"
          class="chat-item"
          @click="toChat(item.targetUser.id)"
        >
          <div class="chat-left">
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
              <p class="last-msg">{{ item.lastMessage || '暂无消息内容' }}</p>
            </div>
          </div>

          <div class="chat-right">
            <span class="time">{{ item.lastTime | formatDate }}</span>
            <el-button size="small" type="primary" plain round>
              发消息
            </el-button>
          </div>
        </div>
      </div>
      
      <el-empty v-else description="暂无最近联系人"></el-empty>
    </el-card>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date"; // 假设你有这个工具类

export default {
  name: "ChatList",
  data() {
    return {
      baseUrl: "http://localhost:8080", // 根据实际情况修改
      // 模拟数据结构，你需要把这里替换成从后端获取的数据
      chatList: [
        // 示例数据
        /*
        {
          targetUser: { id: 101, username: "Admin", avatar: "" },
          lastMessage: "你好，请问有什么可以帮你的？",
          lastTime: new Date(),
          unreadCount: 2
        }
        */
      ],
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    this.getChatList();
  },
  methods: {
    // 处理头像链接
    getResUrl(url) {
      if (!url) return "";
      if (url.startsWith("http")) return url;
      return this.baseUrl + url;
    },
    // 处理文字头像
    getAvatarText(username) {
      if (!username) return "U";
      return username.charAt(0).toUpperCase();
    },
    
    // 获取最近联系人列表
    getChatList() {
      // 🟢 这里需要调用后端接口获取最近聊过天的人
      // 假设接口是 /chat/recent-list?userId=xxx
      // 这里先写个空的请求逻辑，你可以根据后端接口修改
      
      this.$get("/chat/recent", { userId: this.user.id }).then(res => {
         if(res.data.status && res.data.list) {
            this.chatList = res.data.list;
         }
      }).catch(() => {
         // 如果还没后端，先不报错
         console.log("获取消息列表失败或接口未定义");
      });
    },

    // 跳转到详情页
    toChat(targetUserId) {
      this.$router.push({
        path: "/home/chat/detail",
        query: { toUser: targetUserId },
      });
    },
  },
  filters: {
    formatDate(time) {
      if (!time) return "";
      let date = new Date(time);
      // 简单格式化，你可以用你项目里的 util
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

  /* 列表项样式 */
  .chat-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 10px;
    border-bottom: 1px solid #f0f0f0;
    cursor: pointer;
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
            // 单行省略
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
    }
  }
}
</style>