<template>
  <el-row :gutter="20" class="main-layout-row">
    <el-col :xs="24" :sm="24" :md="16" :lg="17">
      <el-card shadow="never" class="detail-card">
        <div slot="header" class="clearfix">
          <el-page-header @back="$router.back()" content="帖子详情"></el-page-header>
        </div>

        <div v-if="loading" class="loading-box">
          <i class="el-icon-loading"></i> 加载中...
        </div>

        <div v-else-if="post">
          <div class="author-info">
            <el-avatar
              :size="40"
              :src="getSafeAvatar(post.publisher)"
              style="background-color: #409eff; color: #fff; margin-right: 10px;"
            >
              {{ getAvatarText(post.publisher) }}
            </el-avatar>
            <div class="author-text">
              <div class="name">
                {{ post.publisher ? post.publisher.username : "匿名" }}
              </div>
              <div class="time">{{ post.createTime | formatDate }}</div>
            </div>
          </div>

          <div class="post-main">
            <div class="title-row">
              <h1 class="main-title">{{ post.title }}</h1>
              <div class="owner-actions" v-if="isOwner">
                <el-button type="text" icon="el-icon-edit" size="medium" @click="handleEdit">修改</el-button>
                <el-popconfirm title="确定删除这个帖子吗？" @confirm="handleDelete" style="margin-left: 10px">
                  <el-button slot="reference" type="text" icon="el-icon-delete" size="medium" class="delete-btn">删除</el-button>
                </el-popconfirm>
              </div>
            </div>
            <div class="main-content">{{ post.content }}</div>

            <div class="img-grid" v-if="post.imgList && post.imgList.length > 0">
              <el-image
                v-for="(img, idx) in post.imgList"
                :key="idx"
                :src="getResUrl(img)"
                :preview-src-list="post.imgList.map((url) => getResUrl(url))"
                fit="cover"
                class="detail-img"
              ></el-image>
            </div>
          </div>

          <div class="action-bar">
            <el-button type="primary" plain round icon="el-icon-thumb" @click="handleLike">
              点赞 {{ post.likeCount || 0 }}
            </el-button>
            <span class="divider"></span>
            <span class="read-info">
              <i class="el-icon-chat-dot-round"></i>
              {{ post.comments ? post.comments.length : 0 }} 条评论
            </span>
          </div>

          <el-divider></el-divider>

          <div class="comment-input-area">
            <el-input
              type="textarea"
              :rows="3"
              placeholder="发一条友善的评论..."
              v-model="commentContent"
              maxlength="200"
              show-word-limit
            ></el-input>
            <div class="btn-wrapper">
              <el-button type="primary" size="small" @click="submitComment">发表评论</el-button>
            </div>
          </div>

          <div class="comment-list">
            <div class="list-title">全部评论</div>
            <div v-if="post.comments && post.comments.length > 0">
              <div v-for="(c, idx) in post.comments" :key="idx" class="comment-item">
                <el-avatar
                  :size="30"
                  :src="getSafeAvatar(c.commenter)"
                  class="c-avatar"
                  style="background-color: #409eff; color: #fff"
                >
                  {{ getAvatarText(c.commenter) }}
                </el-avatar>
                <div class="c-right">
                  <div class="c-user">
                    <span class="u-name">{{ c.commenter ? c.commenter.username : "匿名" }}</span>
                    <span class="c-time">{{ c.createTime | formatDate }}</span>
                  </div>
                  <div class="c-text">{{ c.content }}</div>
                </div>
              </div>
            </div>
            <el-empty v-else description="还没有人评论，抢个沙发吧~" :image-size="60"></el-empty>
          </div>
        </div>
        <el-empty v-else description="帖子不存在或已被删除"></el-empty>
      </el-card>
    </el-col>

    <el-col :xs="24" :sm="24" :md="8" :lg="7">
      <div v-if="post && post.publisher" class="white-block profile-card">
        <div class="profile-bg" :style="{ backgroundImage: `url(${userBgImg})` }"></div>
        <div class="profile-content">
          <div class="avatar-wrap">
            <el-avatar :size="70" :src="getSafeAvatar(post.publisher)" class="user-avatar">
              {{ getAvatarText(post.publisher) }}
            </el-avatar>
          </div>
          <div class="user-name">
            {{ post.publisher.nickname || post.publisher.username }}
          </div>
          <div class="user-role">
            {{ post.publisher.school ? post.publisher.school.name : "未知学校" }} · 发布者
          </div>
          <div class="user-bio" :title="post.publisher.signature">
            {{ post.publisher.signature || "这个发布者很懒，什么都没写..." }}
          </div>
        </div>
        <div class="profile-stats">
          <div class="p-stat-item">
            <div class="num" style="color: #ff9900">{{ post.publisher.balance || 0 }}</div>
            <div class="label">积分</div>
          </div>
          <div class="p-divider"></div>
          <div class="p-stat-item">
            <div class="num">{{ pubStats.publishCount }}</div>
            <div class="label">求助</div>
          </div>
          <div class="p-divider"></div>
          <div class="p-stat-item">
            <div class="num">{{ pubStats.solveCount }}</div>
            <div class="label">解决</div>
          </div>
        </div>
      </div>

      <el-card v-if="post && post.publisher" shadow="never" class="detail-info-card">
        <div slot="header" class="clearfix">
          <span class="card-title">详细资料</span>
        </div>
        <el-descriptions :column="1" border size="small">
          <el-descriptions-item label="用户名">{{ post.publisher.username }}</el-descriptions-item>
          <el-descriptions-item label="学校">
            {{ post.publisher.school ? post.publisher.school.name : "未关联" }}
          </el-descriptions-item>
          <el-descriptions-item label="邮箱">{{ post.publisher.email || "未公开" }}</el-descriptions-item>
        </el-descriptions>
      </el-card>
    </el-col>

    <el-dialog title="修改帖子" :visible.sync="editDialogVisible" width="50%" @close="resetEditForm">
      </el-dialog>
  </el-row>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";
import { listPublished, listAccepted } from "@/api/task/task";

export default {
  name: "PostDetail",
  data() {
    return {
      postId: null,
      post: null,
      loading: false,
      commentContent: "",
      baseUrl: "http://localhost:8080",
      userBgImg: require("@/assets/img/user_bg.jpg"),
      pubStats: { publishCount: 0, solveCount: 0 },
      editDialogVisible: false,
      editForm: { id: null, title: "", content: "", imgList: [] },
    };
  },
  computed: {
    ...mapState("user", ["user"]),
    isOwner() {
      if (!this.post || !this.user || !this.post.publisher) return false;
      return this.post.publisher.id === this.user.id;
    },
  },
  created() {
    this.postId = this.$route.params.id;
    this.fetchPostDetail();
  },
  methods: {
    fetchPostDetail() {
      this.loading = true;
      this.$get("/post", { schoolId: this.user.school.id })
        .then((res) => {
          this.loading = false;
          if (res.data.status) {
            let list = res.data.posts || [];
            const found = list.find((p) => p.id == this.postId);
            if (found) {
              this.post = found;
              if (this.post.publisher) {
                this.getPublisherStats(this.post.publisher.id);
              }
            } else {
              this.$msg("未找到该帖子", "error");
            }
          }
        })
        .catch(() => { this.loading = false; });
    },
    getPublisherStats(pubId) {
      listPublished(pubId).then((res) => {
        const list = res.task || (res.data && res.data.task) || [];
        this.pubStats.publishCount = list.length;
      });
      listAccepted(pubId).then((res) => {
        const list = res.task || (res.data && res.data.task) || [];
        this.pubStats.solveCount = list.length;
      });
    },
    getResUrl(url) {
      if (!url) return "";
      return url.startsWith("http") ? url : this.baseUrl + url;
    },
    getSafeAvatar(u) {
      if (!u || !u.avatar) return null;
      return this.getResUrl(u.avatar);
    },
    getAvatarText(u) {
      if (!u || !u.username) return "匿";
      return u.username.charAt(0).toUpperCase();
    },
    handleLike() {
      this.$put("/post/like/" + this.post.id).then((res) => {
        if (res.data.status) {
          this.post.likeCount++;
          this.$msg("点赞成功", "success");
        }
      });
    },
    submitComment() {
      if (!this.commentContent.trim()) return;
      let formData = new FormData();
      formData.append("postId", this.post.id);
      formData.append("userId", this.user.id);
      formData.append("content", this.commentContent);
      this.$post("/post/comment", formData).then((res) => {
        if (res.data.status) {
          this.commentContent = "";
          this.fetchPostDetail();
        }
      });
    },
    handleDelete() {
      this.$del("/post/" + this.post.id).then((res) => {
        if (res.data.status) {
          this.$msg("删除成功", "success");
          this.$router.replace("/home/forum/list");
        }
      });
    },
    handleEdit() {
      this.editForm = { ...this.post };
      this.editDialogVisible = true;
    },
    resetEditForm() {
      this.editDialogVisible = false;
    },
  },
  filters: {
    formatDate(time) {
      if (!time) return "";
      return formatDate(new Date(time), "yyyy-MM-dd hh:mm");
    },
  },
};
</script>

<style scoped lang="less">
/* 核心布局优化：不再有背景色 */
.main-layout-row {
  padding: 20px;
  max-width: 1300px;
  margin: 0 auto;
}

.detail-card {
  border-radius: 8px;
  border: 1px solid #ebeef5; /* 增加轻微边框，在纯白背景下更好看 */
}

/* 交互栏 */
.action-bar {
  display: flex;
  align-items: center;
  margin-top: 20px;
  padding: 10px 0;
  .divider { flex: 1; }
  .read-info {
    color: #909399;
    font-size: 14px;
    i { margin-right: 5px; }
  }
}

/* 评论区 */
.comment-item {
  display: flex;
  padding: 15px 0;
  border-bottom: 1px solid #f2f6fc;
  .c-right {
    flex: 1;
    margin-left: 12px;
    .c-user {
      display: flex;
      justify-content: space-between;
      margin-bottom: 6px;
      .u-name { font-weight: 600; color: #1a1a1a; font-size: 14px; }
      .c-time { color: #999; font-size: 12px; }
    }
    .c-text { font-size: 14px; color: #555; line-height: 1.6; }
  }
}

.comment-input-area {
  margin: 20px 0;
  background: #f9fafc;
  padding: 15px;
  border-radius: 8px;
  .btn-wrapper {
    margin-top: 12px;
    display: flex;
    justify-content: flex-end;
  }
}

/* 右侧发布者卡片 */
.profile-card {
  overflow: hidden;
  background: #fff;
  border-radius: 8px;
  border: 1px solid #ebeef5;
  margin-bottom: 15px;
  .profile-bg {
    height: 80px;
    background-position: center;
    background-size: cover;
  }
  .profile-content {
    text-align: center;
    margin-top: -35px;
    padding-bottom: 15px;
    border-bottom: 1px solid #f0f0f0;
    .avatar-wrap {
      display: inline-block;
      padding: 3px;
      background: #fff;
      border-radius: 50%;
    }
    .user-name { font-size: 18px; font-weight: bold; margin-top: 5px; }
    .user-role { font-size: 12px; color: #909399; }
    .user-bio { font-size: 13px; color: #606266; padding: 0 15px; margin-top: 8px; }
  }
  .profile-stats {
    display: flex;
    padding: 15px 0;
    .p-stat-item { flex: 1; text-align: center; }
    .p-divider { width: 1px; height: 20px; background: #eee; }
    .num { font-weight: bold; font-size: 16px; }
    .label { font-size: 12px; color: #999; }
  }
}

/* 详细资料卡片 */
.detail-info-card {
  border-radius: 8px;
}

.author-info {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  .author-text {
    .name { font-weight: bold; font-size: 16px; color: #303133; }
    .time { font-size: 12px; color: #909399; margin-top: 2px; }
  }
}

.post-main .main-title { font-size: 22px; margin-bottom: 15px; }
.post-main .main-content { line-height: 1.8; white-space: pre-wrap; margin-bottom: 20px; }

.img-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  .detail-img { width: 140px; height: 140px; border-radius: 4px; }
}

.list-title {
  font-weight: bold;
  border-left: 4px solid #409eff;
  padding-left: 10px;
  margin-bottom: 15px;
}
</style>