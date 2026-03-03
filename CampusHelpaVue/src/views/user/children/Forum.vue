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
        <div style="float: right; display: flex; align-items: center; gap: 10px;">
          <el-select v-model="sortType" size="small" style="width: 110px" @change="applySort">
            <el-option label="时间排序" value="time"></el-option>
            <el-option label="点赞排序" value="likes"></el-option>
            <el-option label="评论排序" value="comments"></el-option>
          </el-select>
          <el-button
            :type="sortOrder === 'desc' ? 'primary' : 'default'"
            size="small"
            :icon="sortOrder === 'desc' ? 'el-icon-sort-down' : 'el-icon-sort-up'"
            @click="toggleSortOrder"
          >
            {{ sortOrder === 'desc' ? '降序' : '升序' }}
          </el-button>
          <el-button
            type="text"
            icon="el-icon-edit-outline"
            @click="openDialog"
          >
            发布论坛
          </el-button>
        </div>
      </div>

      <div v-if="sortedPostList.length > 0">
        <div v-for="(item, index) in sortedPostList" :key="index" class="post-item">
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
            <el-button 
                size="mini" 
                :type="item.isLiked ? 'danger' : ''"
                :icon="item.isLiked ? 'el-icon-star-on' : 'el-icon-thumb'"
                :plain="!item.isLiked"
                @click.stop="handleLike(item)"
            >
              {{ item.isLiked ? '已赞' : '点赞' }} ({{ item.likeCount || 0 }})
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
      baseUrl: "http://localhost:8080",
      sortType: 'time',
      sortOrder: 'desc'
    };
  },
  computed: {
    ...mapState("user", ["user"]),
    sortedPostList() {
      return this.applySort();
    }
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

    // 🔴 修改点 2：获取列表时，告诉后端是谁在看（传 userId）
    getPosts() {
      this.$get("/post", { 
          schoolId: this.user.school.id,
          userId: this.user.id
      }).then((res) => {
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

    // 🔴 修改点 3：点赞逻辑对接新接口
    handleLike(item) {
      // 拼接参数：userId, targetId, targetType=1(帖子)
      const url = `/like?userId=${this.user.id}&targetId=${item.id}&targetType=1`;
      
      this.$put(url).then((res) => {
        if (res.data.status) {
            // 后端返回当前最新的状态
            const isLikedNow = res.data.isLiked;
            item.isLiked = isLikedNow;

            // 更新数字显示
            if (isLikedNow) {
                item.likeCount = (item.likeCount || 0) + 1;
                this.$msg("点赞成功", "success");
            } else {
                if (item.likeCount > 0) item.likeCount--;
                this.$msg("取消点赞", "info");
            }
        } else {
             this.$msg(res.data.msg, "error");
        }
      });
    },

    goToDetail(postId) {
      this.$router.push({ name: 'PostDetail', params: { id: postId } });
    },
    
    toggleSortOrder() {
      this.sortOrder = this.sortOrder === 'desc' ? 'asc' : 'desc';
    },
    
    applySort() {
      let list = [...this.postList];
      
      if (this.sortType === 'time') {
        list.sort((a, b) => {
          const timeA = new Date(a.createTime).getTime();
          const timeB = new Date(b.createTime).getTime();
          return this.sortOrder === 'desc' ? timeB - timeA : timeA - timeB;
        });
      } else if (this.sortType === 'likes') {
        list.sort((a, b) => {
          const likesA = a.likeCount || 0;
          const likesB = b.likeCount || 0;
          return this.sortOrder === 'desc' ? likesB - likesA : likesA - likesB;
        });
      } else if (this.sortType === 'comments') {
        list.sort((a, b) => {
          const commentsA = a.comments ? a.comments.length : 0;
          const commentsB = b.comments ? b.comments.length : 0;
          return this.sortOrder === 'desc' ? commentsB - commentsA : commentsA - commentsB;
        });
      }
      
      return list;
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