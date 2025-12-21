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
          @click="openDialog"
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
                :src="getResUrl(item.publisher ? item.publisher.avatar : '')"
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

          <div class="post-content-wrapper" @click="goToDetail(item.id)" style="cursor: pointer;">
            <div class="post-cover" v-if="item.imgList && item.imgList.length > 0">
              <el-image 
                :src="getResUrl(item.imgList[0])" 
                fit="cover"
                style="width: 150px; height: 100%; border-radius: 4px;">
              </el-image>
            </div>

            <div class="post-text">
              <h3 class="title hover-link">{{ item.title }}</h3>
              <p class="text">{{ item.content }}</p>
            </div>
          </div>

          <div class="post-actions">
            <el-button size="mini" icon="el-icon-thumb" @click.stop="handleLike(item)">
              点赞 ({{ item.likeCount || 0 }})
            </el-button>
            <el-button size="mini" icon="el-icon-chat-dot-round" @click.stop="goToDetail(item.id)">
              评论 ({{ item.comments ? item.comments.length : 0 }})
            </el-button>
          </div>
          
          <el-divider></el-divider>
        </div>
      </div>
      <el-empty v-else description="暂无动态，快来发布第一条吧！"></el-empty>
    </el-card>

    <el-dialog title="发布新论坛" :visible.sync="dialogVisible" width="50%" @close="resetForm">
      <el-form label-width="80px">
        <el-form-item label="标题">
          <el-input v-model="newPost.title" placeholder="请输入标题"></el-input>
        </el-form-item>
        <el-form-item label="内容">
          <el-input type="textarea" :rows="4" v-model="newPost.content" placeholder="分享新鲜事..."></el-input>
        </el-form-item>
        <el-form-item label="图片">
          <el-upload
            action="http://localhost:8080/common/upload"
            :data="{ type: 'post' }"
            name="file"
            list-type="picture-card"
            :limit="9"
            :file-list="fileList"
            :on-success="handleUploadSuccess"
            :on-remove="handleRemove"
            multiple
          >
            <i class="el-icon-plus"></i>
          </el-upload>
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
        imgList: [] 
      },
      fileList: [], 
      baseUrl: "http://localhost:8080"
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    this.getPosts();
  },
  methods: {
    getResUrl(url) {
      if (!url) return "";
      if (url.startsWith("http")) return url;
      return this.baseUrl + url;
    },
    getAvatarText(publisher) {
      if (!publisher || !publisher.username) return "U";
      return publisher.username.charAt(0).toUpperCase();
    },
    getPosts() {
      this.$get("/post", { schoolId: this.user.school.id }).then((res) => {
        if (res.data.status) {
          this.postList = res.data.posts;
        }
      });
    },
    openDialog() {
      this.dialogVisible = true;
    },
    // 上传相关
    handleUploadSuccess(res, file, fileList) {
      if (res.url) {
        this.newPost.imgList.push(res.url);
      } else {
        this.$msg("图片上传返回值异常", "error");
      }
    },
    handleRemove(file, fileList) {
      if (file.response && file.response.url) {
        const urlToRemove = file.response.url;
        this.newPost.imgList = this.newPost.imgList.filter(url => url !== urlToRemove);
      }
    },
    resetForm() {
      this.newPost.title = "";
      this.newPost.content = "";
      this.newPost.imgList = [];
      this.fileList = [];
    },
    submitPost() {
      if (!this.newPost.title || !this.newPost.content) {
        this.$msg("请填写完整信息", "error");
        return;
      }
      this.$post("/post", {
        userId: this.user.id,
        schoolId: this.user.school.id,
        title: this.newPost.title,
        content: this.newPost.content,
        imgList: this.newPost.imgList
      }).then((res) => {
        if (res.data.status) {
          this.$msg(res.data.msg, "success");
          this.dialogVisible = false;
          this.resetForm();
          this.getPosts();
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
    // 🟢 跳转详情页
    goToDetail(postId) {
      this.$router.push({ name: 'PostDetail', params: { id: postId } });
    }
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
/* 样式保留主要的，移除评论区样式 */
.content {
  background: transparent;
  margin: 0;
  padding: 10px 0;

  .box-card {
    border-radius: 8px;
    border: none;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  }

  .post-item {
    margin-bottom: 20px;

    .post-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
      .user-info-wrapper { display: flex; align-items: center; }
      .user-name { font-weight: bold; color: #409eff; font-size: 15px; }
      .post-time { color: #909399; font-size: 13px; }
    }

    .post-content-wrapper {
      display: flex;
      padding-left: 40px;
      margin-bottom: 15px;
      transition: background-color 0.2s; /* 点击反馈 */
      
      &:hover .hover-link {
        color: #409eff; /* 鼠标悬停标题变色 */
      }

      .post-cover {
        flex-shrink: 0;
        width: 150px;
        height: 100px;
        margin-right: 15px;
        overflow: hidden;
      }

      .post-text {
        flex-grow: 1;
        min-width: 0;
        .title {
          margin: 0 0 8px 0;
          font-size: 16px;
          color: #303133;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        .text {
          margin: 0;
          font-size: 14px;
          color: #606266;
          line-height: 1.6;
          display: -webkit-box;
          -webkit-box-orient: vertical;
          -webkit-line-clamp: 3;
          overflow: hidden;
        }
      }
    }

    .post-actions {
      margin-bottom: 15px;
      padding-left: 40px;
    }
  }
}
</style>