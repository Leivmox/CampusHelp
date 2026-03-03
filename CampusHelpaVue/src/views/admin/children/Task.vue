<template>
  <div class="page-container">
    <div class="page-header">
      <h3 class="page-title">求助管理</h3>
      <p class="page-desc">管理校园IT互助系统中的所有求助任务</p>
    </div>

    <el-card class="search-card" shadow="never">
      <div class="search-bar">
        <div class="filter-group">
          <span class="filter-label">状态筛选:</span>
          <el-select v-model="filterStatus" placeholder="全部状态" @change="filterTasks" clearable>
            <el-option label="全部" value=""></el-option>
            <el-option label="待接单" :value="0"></el-option>
            <el-option label="进行中" :value="1"></el-option>
            <el-option label="已完成" :value="2"></el-option>
          </el-select>
        </div>
        
        <el-input
          v-model="searchKeyword"
          placeholder="搜索任务标题..."
          prefix-icon="el-icon-search"
          clearable
          style="width: 280px"
          @input="filterTasks">
        </el-input>
        
        <el-button type="primary" icon="el-icon-refresh" @click="loadTasks">刷新</el-button>
      </div>
    </el-card>

    <el-card class="stats-card" shadow="never">
      <div class="stats-row">
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #909399 0%, #c0c4cc 100%);">
            <i class="el-icon-time"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statusStats.pending }}</div>
            <div class="stat-label">待接单</div>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #e6a23c 0%, #f5d442 100%);">
            <i class="el-icon-loading"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statusStats.inProgress }}</div>
            <div class="stat-label">进行中</div>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #67c23a 0%, #95d475 100%);">
            <i class="el-icon-circle-check"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statusStats.completed }}</div>
            <div class="stat-label">已完成</div>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #409eff 0%, #79bbff 100%);">
            <i class="el-icon-s-order"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ tasks.length }}</div>
            <div class="stat-label">总计</div>
          </div>
        </div>
      </div>
    </el-card>

    <el-card class="table-card" shadow="never">
      <el-table
        :data="filteredTasks"
        border
        stripe
        highlight-current-row
        style="width: 100%">
        
        <el-table-column label="发布人" min-width="120" align="center">
          <template slot-scope="scope">
            <div class="user-cell" v-if="scope.row.publish">
              <el-avatar :size="24" :src="getAvatarUrl(scope.row.publish)">
                {{ getAvatarText(scope.row.publish) }}
              </el-avatar>
              <span>{{ scope.row.publish.username }}</span>
            </div>
            <span v-else>未知</span>
          </template>
        </el-table-column>
        
        <el-table-column label="接单人" min-width="120" align="center">
          <template slot-scope="scope">
            <div class="user-cell" v-if="scope.row.accept">
              <el-avatar :size="24" :src="getAvatarUrl(scope.row.accept)">
                {{ getAvatarText(scope.row.accept) }}
              </el-avatar>
              <span>{{ scope.row.accept.username }}</span>
            </div>
            <span v-else class="no-accept">暂无接单</span>
          </template>
        </el-table-column>
        
        <el-table-column prop="taskTitle" label="任务标题" min-width="180" show-overflow-tooltip>
        </el-table-column>
        
        <el-table-column prop="taskContext" label="任务内容" min-width="200" show-overflow-tooltip>
        </el-table-column>
        
        <el-table-column label="学校" min-width="120" align="center">
          <template slot-scope="scope">
            {{ scope.row.school ? scope.row.school.name : '未知学校' }}
          </template>
        </el-table-column>
        
        <el-table-column label="发布时间" min-width="160" align="center">
          <template slot-scope="scope">
            {{ scope.row.createTime | formatDate }}
          </template>
        </el-table-column>
        
        <el-table-column label="状态" min-width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.state)" size="medium">
              {{ getStatusText(scope.row.state) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="160" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button 
              type="primary" 
              size="mini" 
              icon="el-icon-view"
              plain
              @click="viewTask(scope.row)">
              查看
            </el-button>
            <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-warning"
              icon-color="red"
              title="确定删除该求助吗？"
              @confirm="del(scope.row)"
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
      title="求助详情"
      :visible.sync="dialogVisible"
      width="700px"
      destroy-on-close>
      <div class="task-detail" v-if="currentTask">
        <div class="detail-status">
          <el-tag :type="getStatusType(currentTask.state)" size="large">
            {{ getStatusText(currentTask.state) }}
          </el-tag>
        </div>

        <div class="detail-header">
          <div class="publisher-info">
            <el-avatar :size="50" :src="getAvatarUrl(currentTask.publish)">
              {{ getAvatarText(currentTask.publish) }}
            </el-avatar>
            <div class="publisher-text">
              <div class="name">{{ currentTask.publish ? currentTask.publish.username : '未知用户' }}</div>
              <div class="school">{{ currentTask.school ? currentTask.school.name : '未知学校' }}</div>
            </div>
          </div>
          <div class="publish-time">发布于 {{ currentTask.createTime | formatDate }}</div>
        </div>

        <div class="detail-title">{{ currentTask.taskTitle }}</div>
        
        <div class="detail-content">{{ currentTask.taskContext }}</div>
        
        <div class="detail-images" v-if="currentTask.imgList && currentTask.imgList.length > 0">
          <div class="images-title">图片 ({{ currentTask.imgList.length }}张)</div>
          <div class="images-grid">
            <el-image
              v-for="(img, idx) in currentTask.imgList"
              :key="idx"
              :src="getResUrl(img)"
              :preview-src-list="currentTask.imgList.map(url => getResUrl(url))"
              fit="cover"
              class="detail-img">
            </el-image>
          </div>
        </div>

        <el-divider></el-divider>

        <div class="detail-info">
          <div class="info-item" v-if="currentTask.accept">
            <span class="info-label">接单人:</span>
            <div class="accepter-info">
              <el-avatar :size="32" :src="getAvatarUrl(currentTask.accept)">
                {{ getAvatarText(currentTask.accept) }}
              </el-avatar>
              <span>{{ currentTask.accept.username }}</span>
            </div>
          </div>
          <div class="info-item" v-if="currentTask.orderTime">
            <span class="info-label">接单时间:</span>
            <span>{{ currentTask.orderTime | formatDate }}</span>
          </div>
          <div class="info-item" v-if="currentTask.endTime">
            <span class="info-label">完成时间:</span>
            <span>{{ currentTask.endTime | formatDate }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">奖励积分:</span>
            <span class="reward">{{ currentTask.reward || 0 }}</span>
          </div>
        </div>
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
  name: "AdminTask",
  data() {
    return {
      tasks: [],
      filteredTasks: [],
      filterStatus: '',
      searchKeyword: '',
      baseUrl: "http://localhost:8080",
      dialogVisible: false,
      currentTask: null
    }
  },
  
  computed: {
    statusStats() {
      return {
        pending: this.tasks.filter(t => t.state === 0).length,
        inProgress: this.tasks.filter(t => t.state === 1).length,
        completed: this.tasks.filter(t => t.state === 2).length
      };
    }
  },
  
  created() {
    this.loadTasks();
  },
  
  methods: {
    loadTasks() {
      this.$get("/task").then((rs) => {
        this.tasks = rs.data.task || [];
        this.tasks.forEach(task => {
          if (task.imgUrl) {
            task.imgList = task.imgUrl.split(',').filter(url => url.trim());
          } else {
            task.imgList = [];
          }
        });
        this.filterTasks();
      });
    },
    
    filterTasks() {
      let result = this.tasks;
      
      if (this.filterStatus !== '' && this.filterStatus !== null) {
        result = result.filter(t => t.state === this.filterStatus);
      }
      
      if (this.searchKeyword) {
        const keyword = this.searchKeyword.toLowerCase();
        result = result.filter(t => 
          (t.taskTitle && t.taskTitle.toLowerCase().includes(keyword)) ||
          (t.taskContext && t.taskContext.toLowerCase().includes(keyword))
        );
      }
      
      this.filteredTasks = result;
    },
    
    viewTask(task) {
      this.currentTask = task;
      this.dialogVisible = true;
    },
    
    del(row) {
      if (row.state === 1) {
        this.$msg("该求助正在进行中，无法删除", "warning");
        return;
      }
      
      this.$del("/task/" + row.id).then((res) => {
        if (res.data.status) {
          this.$notifyMsg("成功", res.data.msg, "success");
          this.dialogVisible = false;
          this.loadTasks();
        } else {
          this.$notifyMsg("失败", res.data.msg, "error");
        }
      });
    },
    
    getResUrl(url) {
      if (!url) return "";
      return url.startsWith("http") ? url : this.baseUrl + url;
    },
    
    getAvatarUrl(user) {
      if (!user || !user.avatar) return '';
      const avatar = user.avatar;
      if (avatar.startsWith('http')) return avatar;
      return this.baseUrl + avatar;
    },
    
    getAvatarText(user) {
      if (!user || !user.username) return 'U';
      return user.username.charAt(0).toUpperCase();
    },
    
    getStatusType(state) {
      const types = {
        0: 'info',
        1: 'warning',
        2: 'success'
      };
      return types[state] || 'info';
    },
    
    getStatusText(state) {
      const texts = {
        0: '待接单',
        1: '进行中',
        2: '已完成'
      };
      return texts[state] || '未知';
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

.no-accept {
  color: #86909c;
  font-style: italic;
}

.task-detail {
  .detail-status {
    margin-bottom: 16px;
  }
  
  .detail-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    
    .publisher-info {
      display: flex;
      align-items: center;
      gap: 12px;
      
      .publisher-text {
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
    
    .publish-time {
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
  
  .detail-info {
    .info-item {
      display: flex;
      align-items: center;
      margin-bottom: 12px;
      
      .info-label {
        width: 80px;
        font-size: 14px;
        color: #86909c;
      }
      
      .accepter-info {
        display: flex;
        align-items: center;
        gap: 8px;
      }
      
      .reward {
        font-weight: 600;
        color: #ff7d00;
      }
    }
  }
}
</style>
