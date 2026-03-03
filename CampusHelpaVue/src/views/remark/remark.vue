<template>
  <div class="page-container">
    <div class="page-header">
      <h3 class="page-title">评价管理</h3>
      <p class="page-desc">查看和管理用户评价记录</p>
    </div>

    <el-card class="search-card" shadow="never">
      <div class="search-bar">
        <div class="filter-group">
          <span class="filter-label">星级筛选:</span>
          <el-select v-model="queryParams.star" placeholder="全部星级" clearable @change="handleQuery">
            <el-option label="全部" value=""></el-option>
            <el-option label="5星" :value="5"></el-option>
            <el-option label="4星" :value="4"></el-option>
            <el-option label="3星" :value="3"></el-option>
            <el-option label="2星" :value="2"></el-option>
            <el-option label="1星" :value="1"></el-option>
          </el-select>
        </div>
        
        <el-button type="primary" icon="el-icon-refresh" @click="getList">刷新</el-button>
      </div>
    </el-card>

    <el-card class="stats-card" shadow="never">
      <div class="stats-row">
        <div class="stat-item" v-for="item in starStats" :key="item.star">
          <div class="stat-icon" :style="getStarGradient(item.star)">
            <i class="el-icon-star-on"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ item.count }}</div>
            <div class="stat-label">{{ item.star }}星评价</div>
          </div>
        </div>
        <div class="stat-item total">
          <div class="stat-icon" style="background: linear-gradient(135deg, #409eff 0%, #79bbff 100%);">
            <i class="el-icon-s-data"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ remarkList.length }}</div>
            <div class="stat-label">总评价</div>
          </div>
        </div>
      </div>
    </el-card>

    <el-card class="table-card" shadow="never">
      <el-table v-loading="loading" :data="remarkList" border stripe highlight-current-row style="width: 100%">
        <el-table-column label="评分" min-width="150" align="center">
          <template slot-scope="scope">
            <el-rate v-model="scope.row.star" disabled show-score text-color="#ff9900"></el-rate>
          </template>
        </el-table-column>

        <el-table-column label="评价内容" min-width="150" align="center" prop="remark" show-overflow-tooltip>
        </el-table-column>
        
        <el-table-column label="求助标题" min-width="150" align="center">
          <template slot-scope="scope">
            <span v-if="scope.row.task">{{ scope.row.task.taskTitle }}</span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        
        <el-table-column label="发布者(求助人)" min-width="120" align="center">
          <template slot-scope="scope">
            <div class="user-cell" v-if="scope.row.task && scope.row.task.publish">
              <el-avatar :size="24" :src="getAvatarUrl(scope.row.task.publish)">
                {{ getAvatarText(scope.row.task.publish) }}
              </el-avatar>
              <span>{{ scope.row.task.publish.username }}</span>
            </div>
            <span v-else>-</span>
          </template>
        </el-table-column>
        
        <el-table-column label="接单者(被评价人)" min-width="120" align="center">
          <template slot-scope="scope">
            <div class="user-cell" v-if="scope.row.task && scope.row.task.accept">
              <el-avatar :size="24" :src="getAvatarUrl(scope.row.task.accept)">
                {{ getAvatarText(scope.row.task.accept) }}
              </el-avatar>
              <span>{{ scope.row.task.accept.username }}</span>
            </div>
            <span v-else>-</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="100" align="center" fixed="right">
          <template slot-scope="scope">
            <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-warning"
              icon-color="red"
              title="确定删除该评价吗？"
              @confirm="handleDelete(scope.row)"
            >
              <el-button 
                size="mini"
                type="danger"
                icon="el-icon-delete"
                plain
                slot="reference">
              </el-button>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { listRemark, getRemark, delRemark, addRemark, updateRemark } from "@/api/remark/remark";

export default {
  name: "Remark",
  data() {
    return {
      loading: true,
      remarkList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 100,
        star: null
      },
      form: {},
      rules: {},
      baseUrl: "http://localhost:8080"
    };
  },
  
  computed: {
    starStats() {
      const stats = [];
      for (let i = 5; i >= 1; i--) {
        stats.push({
          star: i,
          count: this.remarkList.filter(r => r.star === i).length
        });
      }
      return stats;
    }
  },
  
  created() {
    this.getList();
  },
  
  methods: {
    getList() {
      this.loading = true;
      listRemark(this.queryParams).then(res => {
        this.remarkList = res.data.rows || [];
        this.loading = false;
      });
    },
    
    getStarGradient(star) {
      const gradients = {
        5: 'background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);',
        4: 'background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);',
        3: 'background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);',
        2: 'background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);',
        1: 'background: linear-gradient(135deg, #909399 0%, #c0c4cc 100%);'
      };
      return gradients[star] || gradients[1];
    },
    
    cancel() {
      this.open = false;
      this.reset();
    },
    
    reset() {
      this.form = {
        id: null,
        star: null,
        remark: null
      };
    },
    
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    
    handleDelete(row) {
      const ids = row.id;
      delRemark(ids).then(() => {
        this.$message.success("删除成功");
        this.getList();
      });
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
    }
  }
};
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
    gap: 16px;
    flex-wrap: wrap;
    
    .stat-item {
      flex: 1;
      min-width: 100px;
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 16px;
      background: #f7f8fa;
      border-radius: 8px;
      
      .stat-icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        
        i {
          font-size: 20px;
          color: white;
        }
      }
      
      .stat-info {
        .stat-value {
          font-size: 20px;
          font-weight: 600;
          color: #1d2129;
        }
        
        .stat-label {
          font-size: 12px;
          color: #86909c;
          margin-top: 2px;
        }
      }
      
      &.total .stat-value {
        color: #165dff;
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
  justify-content: center;
  gap: 8px;
}
</style>
