<template>
  <div class="page-container">
    <div class="page-header">
      <h3 class="page-title">系统概览</h3>
      <p class="page-desc">校园IT互助系统数据统计</p>
    </div>

    <div class="stats-row">
      <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <div class="stat-icon"><i class="el-icon-user"></i></div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalUsers || 0 }}</div>
          <div class="stat-label">注册用户</div>
        </div>
        <div class="stat-extra">今日新增: {{ stats.todayNewUsers || 0 }}</div>
      </div>
      
      <div class="stat-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
        <div class="stat-icon"><i class="el-icon-document"></i></div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalPosts || 0 }}</div>
          <div class="stat-label">帖子总数</div>
        </div>
        <div class="stat-extra">今日新增: {{ stats.todayNewPosts || 0 }}</div>
      </div>
      
      <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
        <div class="stat-icon"><i class="el-icon-star-on"></i></div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalLikes || 0 }}</div>
          <div class="stat-label">点赞总数</div>
        </div>
      </div>
      
      <div class="stat-card" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
        <div class="stat-icon"><i class="el-icon-chat-dot-round"></i></div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalComments || 0 }}</div>
          <div class="stat-label">评论总数</div>
        </div>
      </div>
    </div>

    <el-row :gutter="20" class="content-row">
      <el-col :span="12">
        <el-card class="box-card" shadow="never">
          <div slot="header" class="card-header">
            <span><i class="el-icon-user"></i> 最新注册用户</span>
            <el-button type="text" @click="$router.push('/admin/home/student')">查看全部</el-button>
          </div>
          <el-table :data="recentUsers" style="width: 100%" size="small">
            <el-table-column prop="username" label="用户名" min-width="100">
              <template slot-scope="scope">
                <div class="user-cell">
                  <el-avatar :size="24" :src="getAvatarUrl(scope.row.avatar)">
                    {{ scope.row.username ? scope.row.username.charAt(0) : 'U' }}
                  </el-avatar>
                  <span>{{ scope.row.username }}</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="studentId" label="学号" min-width="100"></el-table-column>
            <el-table-column label="注册时间" min-width="140">
              <template slot-scope="scope">
                {{ scope.row.createTime | formatDate }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
      
      <el-col :span="12">
        <el-card class="box-card" shadow="never">
          <div slot="header" class="card-header">
            <span><i class="el-icon-document"></i> 最新帖子</span>
            <el-button type="text" @click="$router.push('/admin/home/post')">查看全部</el-button>
          </div>
          <el-table :data="recentPosts" style="width: 100%" size="small">
            <el-table-column prop="title" label="标题" min-width="150" show-overflow-tooltip></el-table-column>
            <el-table-column label="发布者" min-width="80">
              <template slot-scope="scope">
                {{ scope.row.publisher ? scope.row.publisher.username : '未知' }}
              </template>
            </el-table-column>
            <el-table-column label="互动" min-width="80">
              <template slot-scope="scope">
                <span><i class="el-icon-star-on"></i> {{ scope.row.likeCount || 0 }}</span>
              </template>
            </el-table-column>
            <el-table-column label="发布时间" min-width="140">
              <template slot-scope="scope">
                {{ scope.row.createTime | formatDate }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="content-row">
      <el-col :span="12">
        <el-card class="box-card" shadow="never">
          <div slot="header" class="card-header">
            <span><i class="el-icon-s-order"></i> 求助统计</span>
          </div>
          <div class="task-stats">
            <div class="task-stat-item">
              <div class="task-stat-value">{{ taskStats.pending || 0 }}</div>
              <div class="task-stat-label">待接单</div>
            </div>
            <div class="task-stat-item">
              <div class="task-stat-value">{{ taskStats.inProgress || 0 }}</div>
              <div class="task-stat-label">进行中</div>
            </div>
            <div class="task-stat-item">
              <div class="task-stat-value">{{ taskStats.completed || 0 }}</div>
              <div class="task-stat-label">已完成</div>
            </div>
            <div class="task-stat-item total">
              <div class="task-stat-value">{{ taskStats.total || 0 }}</div>
              <div class="task-stat-label">总计</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="12">
        <el-card class="box-card" shadow="never">
          <div slot="header" class="card-header">
            <span><i class="el-icon-pie-chart"></i> 快捷操作</span>
          </div>
          <div class="quick-actions">
            <el-button type="primary" icon="el-icon-office-building" @click="$router.push('/admin/home/school')">
              管理学校
            </el-button>
            <el-button type="success" icon="el-icon-bell" @click="$router.push('/admin/home/notice')">
              发布公告
            </el-button>
            <el-button type="warning" icon="el-icon-document" @click="$router.push('/admin/home/post')">
              帖子管理
            </el-button>
            <el-button type="info" icon="el-icon-s-claim" @click="$router.push('/admin/home/task')">
              求助管理
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { formatDate } from '@/util/date';

export default {
  name: "AdminIndex",
  data() {
    return {
      stats: {},
      recentUsers: [],
      recentPosts: [],
      tasks: [],
      baseUrl: "http://localhost:8080"
    }
  },
  computed: {
    taskStats() {
      const pending = this.tasks.filter(t => t.state === 0).length;
      const inProgress = this.tasks.filter(t => t.state === 1).length;
      const completed = this.tasks.filter(t => t.state === 2).length;
      return {
        pending,
        inProgress,
        completed,
        total: this.tasks.length
      };
    }
  },
  methods: {
    getAvatarUrl(avatar) {
      if (!avatar) return '';
      if (avatar.startsWith('http')) return avatar;
      return this.baseUrl + avatar;
    },
    
    loadStats() {
      this.$get("/admin/stats/overview")
        .then(res => {
          if (res.data.status) {
            this.stats = res.data.stats;
          }
        })
        .catch(() => {
          this.loadStatsFallback();
        });
    },
    
    loadStatsFallback() {
      this.$get("/user").then(res => {
        this.stats.totalUsers = res.data.user ? res.data.user.length : 0;
        const today = new Date().toDateString();
        this.stats.todayNewUsers = res.data.user ? res.data.user.filter(u => 
          new Date(u.createTime).toDateString() === today
        ).length : 0;
      });
      
      this.$get("/post").then(res => {
        this.stats.totalPosts = res.data.posts ? res.data.posts.length : 0;
        const today = new Date().toDateString();
        this.stats.todayNewPosts = res.data.posts ? res.data.posts.filter(p => 
          new Date(p.createTime).toDateString() === today
        ).length : 0;
        this.stats.totalLikes = res.data.posts ? res.data.posts.reduce((sum, p) => 
          sum + (p.likeCount || 0), 0
        ) : 0;
      });
    },
    
    loadRecentUsers() {
      this.$get("/admin/stats/recentUsers", { limit: 5 })
        .then(res => {
          if (res.data.status) {
            this.recentUsers = res.data.users || [];
          }
        })
        .catch(() => {
          this.$get("/user").then(res => {
            this.recentUsers = (res.data.user || []).slice(0, 5);
          });
        });
    },
    
    loadRecentPosts() {
      this.$get("/admin/stats/recentPosts", { limit: 5 })
        .then(res => {
          if (res.data.status) {
            this.recentPosts = res.data.posts || [];
          }
        })
        .catch(() => {
          this.$get("/post").then(res => {
            this.recentPosts = (res.data.posts || []).slice(0, 5);
          });
        });
    },
    
    loadTasks() {
      this.$get("/task").then(res => {
        this.tasks = res.data.task || [];
      });
    }
  },
  created() {
    this.loadStats();
    this.loadRecentUsers();
    this.loadRecentPosts();
    this.loadTasks();
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

.stats-row {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
  
  .stat-card {
    flex: 1;
    padding: 20px;
    border-radius: 12px;
    color: white;
    position: relative;
    overflow: hidden;
    
    .stat-icon {
      position: absolute;
      right: 20px;
      top: 50%;
      transform: translateY(-50%);
      font-size: 60px;
      opacity: 0.2;
    }
    
    .stat-info {
      .stat-value {
        font-size: 36px;
        font-weight: bold;
        margin-bottom: 5px;
      }
      
      .stat-label {
        font-size: 14px;
        opacity: 0.9;
      }
    }
    
    .stat-extra {
      margin-top: 10px;
      font-size: 12px;
      opacity: 0.8;
    }
  }
}

.content-row {
  margin-bottom: 20px;
}

.box-card {
  border-radius: 8px;
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-weight: 600;
    color: #1d2129;
    
    i {
      margin-right: 8px;
      color: #165dff;
    }
  }
}

.user-cell {
  display: flex;
  align-items: center;
  gap: 8px;
}

.task-stats {
  display: flex;
  justify-content: space-around;
  padding: 20px 0;
  
  .task-stat-item {
    text-align: center;
    
    .task-stat-value {
      font-size: 32px;
      font-weight: bold;
      color: #165dff;
    }
    
    .task-stat-label {
      font-size: 14px;
      color: #86909c;
      margin-top: 8px;
    }
    
    &.total .task-stat-value {
      color: #00b42a;
    }
  }
}

.quick-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  padding: 20px 0;
  
  .el-button {
    flex: 1;
    min-width: 120px;
  }
}

@media (max-width: 1200px) {
  .stats-row {
    flex-wrap: wrap;
    
    .stat-card {
      flex: 1 1 calc(50% - 10px);
      margin-bottom: 10px;
    }
  }
}

@media (max-width: 768px) {
  .stats-row .stat-card {
    flex: 1 1 100%;
  }
  
  .content-row .el-col {
    width: 100%;
    margin-bottom: 20px;
  }
}
</style>
