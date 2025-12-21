<template>
  <div class="content">
    <el-alert
      title="校园圈子 - 分享你的校园生活"
      :closable="false"
      type="success"
      style="margin-bottom: 10px"
    >
    </el-alert>

    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold">最新动态</span>
        <el-button
          style="float: right; padding: 3px 0; font-size: 16px"
          icon="el-icon-edit-outline"
          type="text"
          @click="dialogVisible = true"
        >
          发布论坛
        </el-button>
      </div>

      <div v-if="postList.length > 0">
        <div v-for="(item, index) in postList" :key="index" class="post-item">
          <div class="post-header">
            <div class="user-info-wrapper">
              <el-avatar 
                :size="30" 
                :src="getAvatarUrl(item.publisher)"
                style="background-color: #409eff; font-size: 14px; margin-right: 8px;"
              >
                {{ getAvatarText(item.publisher) }}
              </el-avatar>

              <span class="user-name">{{
                item.publisher ? item.publisher.username : "未知用户"
              }}</span>
            </div>

            <span class="post-time">{{ item.createTime | formatDate }}</span>
          </div>

          <div class="post-content">
            <h3 class="title">{{ item.title }}</h3>
            <p class="text">{{ item.content }}</p>
          </div>

          <div class="post-actions">
            <el-button
              size="mini"
              icon="el-icon-thumb"
              @click="handleLike(item)"
            >
              点赞 ({{ item.likeCount || 0 }})
            </el-button>
            <el-button
              size="mini"
              icon="el-icon-chat-dot-round"
              @click="toggleComment(item)"
            >
              评论 ({{ item.comments ? item.comments.length : 0 }})
            </el-button>
          </div>

          <div class="comment-area">
            <div
              v-for="(c, cIndex) in item.comments"
              :key="cIndex"
              class="comment-row"
            >
              <span class="c-user"
                >{{ c.commenter ? c.commenter.username : "匿名" }}:
              </span>
              <span class="c-content">{{ c.content }}</span>
            </div>

            <div v-if="item.showInput" class="input-wrapper">
              <el-input
                size="small"
                placeholder="写下你的评论..."
                v-model="item.tempComment"
                @keyup.enter.native="submitComment(item)"
              ></el-input>
              <el-button
                type="primary"
                size="small"
                @click="submitComment(item)"
                >发送</el-button
              >
            </div>
          </div>

          <el-divider></el-divider>
        </div>
      </div>
      <el-empty v-else description="暂无动态，快来发布第一条吧！"></el-empty>
    </el-card>

    <el-dialog title="发布新论坛" :visible.sync="dialogVisible" width="50%">
      <el-form label-width="80px">
        <el-form-item label="标题">
          <el-input v-model="newPost.title" placeholder="请输入标题"></el-input>
        </el-form-item>
        <el-form-item label="内容">
          <el-input
            type="textarea"
            :rows="6"
            v-model="newPost.content"
            placeholder="分享新鲜事..."
          ></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitPost">发 布</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";

export default {
  name: "CircleIndex",
  data() {
    return {
      postList: [],
      dialogVisible: false,
      newPost: {
        title: "",
        content: "",
      },
    };
  },
  computed: {
    ...mapState("user", ["user"]), // 获取当前登录用户
  },
  created() {
    this.getPosts();
  },
  methods: {
    // 🟢 修改点 2：添加处理头像URL的方法
    getAvatarUrl(publisher) {
      if (!publisher || !publisher.avatar) return ""; // 没图，返回空，显示文字
      if (publisher.avatar.startsWith("http")) return publisher.avatar;
      return `http://localhost:8080${publisher.avatar}`;
    },

    // 🟢 修改点 3：添加处理文字头像的方法
    getAvatarText(publisher) {
      if (!publisher || !publisher.username) return "U";
      return publisher.username.charAt(0).toUpperCase();
    },

    // 获取列表
    getPosts() {
      // 假设你的后端接口支持 ?schoolId=xxx 传参
      this.$get("/post", { schoolId: this.user.school.id }).then((res) => {
        if (res.data.status) {
          // 为每个帖子增加前端控制字段
          let list = res.data.posts;
          list.forEach((p) => {
            this.$set(p, "showInput", false); // 控制评论框显隐
            this.$set(p, "tempComment", ""); // 绑定输入内容
          });
          this.postList = list;
        }
      });
    },

    // 提交发布
    submitPost() {
      if (!this.newPost.title || !this.newPost.content) {
        this.$msg("请填写完整信息", "error");
        return;
      }
      // 使用表单对象提交，与 TaskController 风格一致
      this.$post("/post", {
        userId: this.user.id,
        schoolId: this.user.school.id,
        title: this.newPost.title,
        content: this.newPost.content,
      }).then((res) => {
        if (res.data.status) {
          this.$msg(res.data.msg, "success");
          this.dialogVisible = false;
          this.newPost.title = "";
          this.newPost.content = "";
          this.getPosts(); // 刷新列表
        } else {
          this.$msg(res.data.msg, "error");
        }
      });
    },

    // 点赞
    handleLike(item) {
      this.$put("/post/like/" + item.id).then((res) => {
        if (res.data.status) {
          item.likeCount++;
          this.$msg("点赞成功", "success");
        }
      });
    },

    // 显示评论框
    toggleComment(item) {
      item.showInput = !item.showInput;
    },

    // 提交评论
    submitComment(item) {
      if (!item.tempComment) {
        this.$msg("评论内容不能为空", "warning");
        return;
      }
      this.$post("/post/comment", {
        postId: item.id,
        userId: this.user.id,
        content: item.tempComment,
      }).then((res) => {
        if (res.data.status) {
          this.$msg("评论成功", "success");
          item.tempComment = "";
          item.showInput = false;
          this.getPosts(); // 刷新显示评论
        } else {
          this.$msg("评论失败", "error");
        }
      });
    },
  },
  filters: {
    formatDate(time) {
      let date = new Date(time);
      return formatDate(date, "yyyy-MM-dd hh:mm");
    },
  },
};
</script>

<style scoped lang="less">
/* 关键修改：容器透明，只留上下间距 */
.content {
  background: transparent;
  margin: 0; /* 左右0，因为Home已经给了20px */
  padding: 10px 0; /* 上下10px */

  /* 卡片美化：圆角、白底 */
  .box-card {
    border-radius: 8px;
    border: none; /* 去掉边框，看起来更干净 */
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  }

  .post-item {
    margin-bottom: 20px;

    /* 🟢 修改点 4：头部样式调整，支持 flex 布局对齐头像 */
    .post-header {
      display: flex;
      justify-content: space-between;
      align-items: center; /* 垂直居中 */
      margin-bottom: 10px;

      .user-info-wrapper {
        display: flex;
        align-items: center;
      }

      .user-name {
        font-weight: bold;
        color: #409eff;
        font-size: 15px;
      }
      .post-time {
        color: #909399;
        font-size: 13px;
      }
    }

    .post-content {
      margin-bottom: 15px;
      /* 这里稍微加一点左内边距，让文字和上面的名字对齐（可选） */
      padding-left: 40px; 
      
      .title {
        margin: 0 0 10px 0;
        font-size: 16px;
        color: #303133;
      }
      .text {
        font-size: 14px;
        color: #606266;
        line-height: 1.6;
      }
    }

    /* 操作按钮也缩进一下，看起来更有层次感 */
    .post-actions {
      margin-bottom: 15px;
      padding-left: 40px;
    }
    
    /* 评论区也缩进 */
    .comment-area {
      background-color: #f9fafc;
      padding: 10px;
      border-radius: 4px;
      margin-left: 40px; /* 缩进 */

      .comment-row {
        font-size: 13px;
        line-height: 20px;
        margin-bottom: 5px;
        .c-user {
          color: #409eff;
        }
        .c-content {
          color: #606266;
        }
      }

      .input-wrapper {
        display: flex;
        margin-top: 10px;
        gap: 10px;
      }
    }
  }
}
</style>