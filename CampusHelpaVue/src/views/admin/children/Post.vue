<template>
  <div class="page-container">
    <div class="page-header">
      <h3 class="page-title">帖子管理</h3>
      <p class="page-desc">管理校园圈子中的所有帖子内容</p>
    </div>

    <el-card class="search-card" shadow="never">
      <div class="search-bar">
        <div class="filter-group">
          <span class="filter-label">选择学校:</span>
          <el-select v-model="selectSchoolId" placeholder="请选择学校" @change="fetchPosts" clearable>
            <el-option
              v-for="item in schools"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
        </div>
        
        <el-input
          v-model="searchKeyword"
          placeholder="搜索帖子标题或内容..."
          prefix-icon="el-icon-search"
          clearable
          style="width: 280px"
          @input="filterPosts">
        </el-input>
        
        <el-button type="primary" icon="el-icon-refresh" @click="fetchPosts">刷新</el-button>
      </div>
    </el-card>

    <el-card class="stats-card" shadow="never">
      <div class="stats-row">
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <i class="el-icon-document"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ posts.length }}</div>
            <div class="stat-label">帖子总数</div>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <i class="el-icon-star-on"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ totalLikes }}</div>
            <div class="stat-label">点赞总数</div>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
            <i class="el-icon-chat-dot-round"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ totalComments }}</div>
            <div class="stat-label">评论总数</div>
          </div>
        </div>
      </div>
    </el-card>

    <el-card class="table-card" shadow="never">
      <el-table
        :data="filteredPosts"
        border
        stripe
        highlight-current-row
        style="width: 100%">
        
        <el-table-column label="发布人" min-width="120" align="center">
          <template slot-scope="scope">
            <div class="user-cell">
              <el-avatar :size="24" :src="getAvatarUrl(scope.row.publisher)">
                {{ getAvatarText(scope.row.publisher) }}
              </el-avatar>
              <span>{{ scope.row.publisher ? scope.row.publisher.username : '未知用户' }}</span>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column prop="title" label="帖子标题" min-width="180" show-overflow-tooltip>
        </el-table-column>

        <el-table-column prop="content" label="内容摘要" min-width="200" show-overflow-tooltip>
        </el-table-column>
        
        <el-table-column label="互动数据" min-width="120" align="center">
          <template slot-scope="scope">
            <span class="interaction-item">
              <i class="el-icon-star-on" style="color: #f56c6c;"></i> {{ scope.row.likeCount || 0 }}
            </span>
            <span class="interaction-item">
              <i class="el-icon-chat-dot-round" style="color: #409eff;"></i> {{ scope.row.comments ? scope.row.comments.length : 0 }}
            </span>
          </template>
        </el-table-column>
        
        <el-table-column label="发布时间" min-width="160" align="center">
          <template slot-scope="scope">
            {{ scope.row.createTime | formatDate }}
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="220" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button 
              v-if="!scope.row.isTop"
              type="warning" 
              size="mini" 
              icon="el-icon-top"
              plain
              @click="setTop(scope.row)">
              置顶
            </el-button>
            <el-button 
              v-else
              type="info" 
              size="mini" 
              icon="el-icon-bottom"
              plain
              @click="cancelTop(scope.row)">
              取消置顶
            </el-button>
            <el-button 
              type="primary" 
              size="mini" 
              icon="el-icon-view"
              plain
              @click="viewPost(scope.row)">
              查看
            </el-button>
            <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-warning"
              icon-color="red"
              title="确定删除该帖子吗？删除后无法恢复！"
              @confirm="del(scope.row.id)"
            >
              <el-button 
                type="danger" 
                size="mini" 
                slot="reference"
                icon="el-icon-delete"
                plain>
              </el-button>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog
      title="帖子详情"
      :visible.sync="dialogVisible"
      width="700px"
      destroy-on-close>
      <div class="post-detail" v-if="currentPost">
        <div class="detail-header">
          <div class="author-info">
            <el-avatar :size="50" :src="getAvatarUrl(currentPost.publisher)">
              {{ getAvatarText(currentPost.publisher) }}
            </el-avatar>
            <div class="author-text">
              <div class="name">{{ currentPost.publisher ? currentPost.publisher.username : '未知用户' }}</div>
              <div class="school">{{ currentPost.publisher && currentPost.publisher.school ? currentPost.publisher.school.name : '未知学校' }}</div>
            </div>
          </div>
          <div class="post-time">{{ currentPost.createTime | formatDate }}</div>
        </div>
        
        <div class="detail-title">{{ currentPost.title }}</div>
        
        <div class="detail-content">{{ currentPost.content }}</div>
        
        <div class="detail-images" v-if="currentPost.imgList && currentPost.imgList.length > 0">
          <div class="images-title">图片 ({{ currentPost.imgList.length }}张)</div>
          <div class="images-grid">
            <el-image
              v-for="(img, idx) in currentPost.imgList"
              :key="idx"
              :src="getResUrl(img)"
              :preview-src-list="currentPost.imgList.map(url => getResUrl(url))"
              fit="cover"
              class="detail-img">
            </el-image>
          </div>
        </div>

        <el-divider></el-divider>

        <div class="detail-stats">
          <span><i class="el-icon-star-on" style="color: #f56c6c;"></i> {{ currentPost.likeCount || 0 }} 点赞</span>
          <span><i class="el-icon-chat-dot-round" style="color: #409eff;"></i> {{ currentPost.comments ? currentPost.comments.length : 0 }} 评论</span>
        </div>

        <div class="comments-section" v-if="currentPost.comments && currentPost.comments.length > 0">
          <div class="comments-title">评论列表</div>
          <div class="comment-item" v-for="(c, idx) in currentPost.comments" :key="idx">
            <el-avatar :size="32" :src="getAvatarUrl(c.commenter)">
              {{ getAvatarText(c.commenter) }}
            </el-avatar>
            <div class="comment-content">
              <div class="comment-header">
                <span class="commenter-name">{{ c.commenter ? c.commenter.username : '匿名' }}</span>
                <span class="comment-time">{{ c.createTime | formatDate }}</span>
              </div>
              <div class="comment-text">{{ c.content }}</div>
            </div>
            <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-warning"
              icon-color="red"
              title="确定删除该评论吗？"
              @confirm="deleteComment(c.id, idx)"
            >
              <el-button 
                type="text"
                size="mini"
                icon="el-icon-delete"
                class="delete-comment-btn"
                slot="reference">
              </el-button>
            </el-popconfirm>
          </div>
        </div>
        <el-empty v-else description="暂无评论" :image-size="60"></el-empty>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">关 闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { formatDate } from '@/util/date';

export default {
  name: "AdminPost",
  data() {
    return {
      schools: [],
      posts: [],
      filteredPosts: [],
      selectSchoolId: null,
      searchKeyword: '',
      baseUrl: "http://localhost:8080",
      dialogVisible: false,
      currentPost: null
    }
  },
  
  computed: {
    totalLikes() {
      return this.posts.reduce((sum, p) => sum + (p.likeCount || 0), 0);
    },
    totalComments() {
      return this.posts.reduce((sum, p) => sum + (p.comments ? p.comments.length : 0), 0);
    }
  },
  
  created() {
    this.loadSchools();
  },
  
  methods: {
    loadSchools() {
      this.$get("/school").then(res => {
        this.schools = res.data.school || [];
        if (this.schools.length > 0) {
          this.selectSchoolId = this.schools[0].id;
          this.fetchPosts();
        }
      });
    },
    
    fetchPosts() {
      if (!this.selectSchoolId) {
        this.posts = [];
        this.filteredPosts = [];
        return;
      }
      
      this.$get("/post", { schoolId: this.selectSchoolId })
        .then((rs) => {
          if (rs.data.status) {
            this.posts = rs.data.posts || [];
            this.posts.forEach(post => {
              if (post.imgUrl) {
                post.imgList = post.imgUrl.split(',').filter(url => url.trim());
              } else {
                post.imgList = [];
              }
            });
            this.filterPosts();
          } else {
            this.$msg("获取列表失败", "error");
          }
        });
    },
    
    filterPosts() {
      if (!this.searchKeyword) {
        this.filteredPosts = this.posts;
      } else {
        const keyword = this.searchKeyword.toLowerCase();
        this.filteredPosts = this.posts.filter(post => 
          (post.title && post.title.toLowerCase().includes(keyword)) ||
          (post.content && post.content.toLowerCase().includes(keyword))
        );
      }
    },
    
    viewPost(post) {
      this.currentPost = post;
      this.dialogVisible = true;
    },
    
    del(id) {
      this.$del("/post/" + id).then((res) => {
        if (res.data.status) {
          this.$notifyMsg("成功", "帖子已删除", "success");
          this.dialogVisible = false;
          this.fetchPosts();
        } else {
          this.$notifyMsg("失败", res.data.msg, "error");
        }
      });
    },
    
    setTop(post) {
      this.$put("/post/top/" + post.id).then((res) => {
        if (res.data.status) {
          this.$notifyMsg("成功", "已置顶", "success");
          post.isTop = 1;
          this.fetchPosts();
        } else {
          this.$notifyMsg("失败", res.data.msg, "error");
        }
      });
    },
    
    cancelTop(post) {
      this.$put("/post/untop/" + post.id).then((res) => {
        if (res.data.status) {
          this.$notifyMsg("成功", "已取消置顶", "success");
          post.isTop = 0;
          this.fetchPosts();
        } else {
          this.$notifyMsg("失败", res.data.msg, "error");
        }
      });
    },
    
    deleteComment(commentId, index) {
      this.$del("/comment/" + commentId).then((res) => {
        if (res.data.status) {
          this.$message.success("评论已删除");
          this.currentPost.comments.splice(index, 1);
          this.currentPost.comments = [...this.currentPost.comments];
          let postIndex = this.posts.findIndex(p => p.id === this.currentPost.id);
          if (postIndex !== -1) {
            this.posts[postIndex].comments = this.currentPost.comments;
          }
        } else {
          this.$message.error(res.data.msg || "删除失败");
        }
      });
    },
    
    getResUrl(url) {
      if (!url) return "";
      return url.startsWith("http") ? url : this.baseUrl + url;
    },
    
    getAvatarUrl(publisher) {
      if (!publisher || !publisher.avatar) return '';
      const avatar = publisher.avatar;
      if (avatar.startsWith('http')) return avatar;
      return this.baseUrl + avatar;
    },
    
    getAvatarText(publisher) {
      if (!publisher || !publisher.username) return 'U';
      return publisher.username.charAt(0).toUpperCase();
    },
  },
  
  filters: {
    formatDate(time) {
      if (!time) return '-';
      let date = new Date(time);
      return formatDate(date, 'yyyy-MM-dd hh:mm');
    }
  }
}
</script>

<style scoped lang="less">
.page-container {
  padding: 0;
}

.page-header {
  margin-bottom: 20px;
  
  .page-title {
    font-size: 22px;
    font-weight: 600;
    color: #1d2129;
    margin: 0 0 8px 0;
  }
  
  .page-desc {
    font-size: 14px;
    color: #86909c;
    margin: 0;
  }
}

.search-card {
  margin-bottom: 16px;
  border-radius: 8px;
  
  /deep/ .el-card__body {
    padding: 16px 20px;
  }
  
  .search-bar {
    display: flex;
    align-items: center;
    gap: 16px;
    
    .filter-group {
      display: flex;
      align-items: center;
      gap: 10px;
      
      .filter-label {
        font-weight: 500;
        color: #606266;
      }
    }
  }
}

.stats-card {
  margin-bottom: 16px;
  border-radius: 8px;
  
  /deep/ .el-card__body {
    padding: 20px;
  }
  
  .stats-row {
    display: flex;
    gap: 24px;
    
    .stat-item {
      flex: 1;
      display: flex;
      align-items: center;
      gap: 16px;
      padding: 16px;
      background: #f7f8fa;
      border-radius: 8px;
      
      .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        
        i {
          font-size: 24px;
          color: white;
        }
      }
      
      .stat-info {
        .stat-value {
          font-size: 24px;
          font-weight: 600;
          color: #1d2129;
        }
        
        .stat-label {
          font-size: 13px;
          color: #86909c;
          margin-top: 4px;
        }
      }
    }
  }
}

.table-card {
  border-radius: 8px;
  
  /deep/ .el-card__body {
    padding: 0;
  }
  
  /deep/ .el-table {
    th {
      background: #f7f8fa !important;
      color: #1d2129;
      font-weight: 500;
    }
    
    .el-table__row:hover {
      background-color: #f7f8fa !important;
    }
  }
}

.user-cell {
  display: flex;
  align-items: center;
  gap: 8px;
}

.interaction-item {
  margin-right: 10px;
  
  i {
    vertical-align: middle;
  }
}

.post-detail {
  .detail-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    
    .author-info {
      display: flex;
      align-items: center;
      gap: 12px;
      
      .author-text {
        .name {
          font-size: 16px;
          font-weight: 600;
          color: #1d2129;
        }
        
        .school {
          font-size: 13px;
          color: #86909c;
          margin-top: 4px;
        }
      }
    }
    
    .post-time {
      font-size: 13px;
      color: #86909c;
    }
  }
  
  .detail-title {
    font-size: 20px;
    font-weight: 600;
    color: #1d2129;
    margin-bottom: 16px;
  }
  
  .detail-content {
    font-size: 15px;
    color: #4e5969;
    line-height: 1.8;
    white-space: pre-wrap;
    margin-bottom: 20px;
  }
  
  .detail-images {
    .images-title {
      font-size: 14px;
      font-weight: 500;
      color: #1d2129;
      margin-bottom: 12px;
    }
    
    .images-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      
      .detail-img {
        width: 120px;
        height: 120px;
        border-radius: 8px;
      }
    }
  }
  
  .detail-stats {
    display: flex;
    gap: 24px;
    font-size: 14px;
    color: #86909c;
    
    i {
      margin-right: 4px;
    }
  }
  
  .comments-section {
    margin-top: 20px;
    
    .comments-title {
      font-size: 15px;
      font-weight: 500;
      color: #1d2129;
      margin-bottom: 16px;
      padding-left: 10px;
      border-left: 3px solid #165dff;
    }
    
    .comment-item {
      display: flex;
      gap: 12px;
      padding: 12px 0;
      border-bottom: 1px solid #f2f3f5;
      
      &:last-child {
        border-bottom: none;
      }
      
      .comment-content {
        flex: 1;
        
        .comment-header {
          display: flex;
          justify-content: space-between;
          margin-bottom: 6px;
          
          .commenter-name {
            font-size: 14px;
            font-weight: 500;
            color: #1d2129;
          }
          
          .comment-time {
            font-size: 12px;
            color: #86909c;
          }
        }
        
        .comment-text {
          font-size: 14px;
          color: #4e5969;
          line-height: 1.6;
        }
      }
      
      .delete-comment-btn {
        color: #f56c6c;
        padding: 5px;
        
        &:hover {
          color: #f78989;
        }
      }
    }
  }
}
</style>
