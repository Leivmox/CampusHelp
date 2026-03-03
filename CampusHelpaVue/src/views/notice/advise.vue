<template>
  <div class="page-container">
    <div class="page-header">
      <h3 class="page-title">公告管理</h3>
      <p class="page-desc">发布和管理系统公告通知</p>
    </div>

    <el-card class="search-card" shadow="never">
      <div class="search-bar">
        <el-input
          v-model="queryParams.noticeTitle"
          placeholder="搜索公告标题..."
          prefix-icon="el-icon-search"
          clearable
          style="width: 280px"
          @keyup.enter.native="handleQuery">
        </el-input>
        
        <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
        <el-button type="success" icon="el-icon-plus" @click="handleAdd">发布公告</el-button>
      </div>
    </el-card>

    <el-card class="stats-card" shadow="never">
      <div class="stats-row">
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <i class="el-icon-bell"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ adviseList.length }}</div>
            <div class="stat-label">公告总数</div>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <i class="el-icon-time"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ todayNewCount }}</div>
            <div class="stat-label">今日新增</div>
          </div>
        </div>
      </div>
    </el-card>

    <el-card class="table-card" shadow="never">
      <el-table v-loading="loading" :data="adviseList" border stripe highlight-current-row style="width: 100%">
        <el-table-column label="序号" align="center" prop="noticeId" width="80" />
        <el-table-column label="公告标题" align="center" prop="noticeTitle" min-width="200" show-overflow-tooltip />
        <el-table-column label="公告内容" align="center" prop="noticeContent" min-width="300" show-overflow-tooltip />
        <el-table-column label="创建者" align="center" prop="createBy" width="120" />

        <el-table-column label="创建时间" align="center" prop="createTime" width="160">
          <template slot-scope="scope">
            {{ transform(scope.row.createTime) }}
          </template>
        </el-table-column>

        <el-table-column label="操作" width="160" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="primary"
              icon="el-icon-edit"
              plain
              @click="handleUpdate(scope.row)">
              修改
            </el-button>
            <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-warning"
              icon-color="red"
              title="确定删除该公告吗？"
              @confirm="handleDelete(scope.row)"
            >
              <el-button
                size="mini"
                type="danger"
                icon="el-icon-delete"
                plain
                slot="reference">
                删除
              </el-button>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="公告标题" prop="noticeTitle">
          <el-input v-model="form.noticeTitle" placeholder="请输入公告标题" />
        </el-form-item>
        <el-form-item label="公告内容" prop="noticeContent">
          <el-input
            resize="none"
            type="textarea"
            :autosize="{ minRows: 6, maxRows: 10}"
            placeholder="请输入公告内容"
            v-model="form.noticeContent">
          </el-input>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" placeholder="请输入备注（选填）" />
        </el-form-item>
        <el-form-item label="创建者" prop="createBy">
          <el-input v-model="form.createBy" placeholder="请输入创建者名称" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listAdvise, getAdvise, delAdvise, addAdvise, updateAdvise } from "@/api/notice/advise";
import { formatDate } from '@/util/date';

export default {
  name: "Advise",
  data() {
    return {
      loading: true,
      adviseList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 100,
        noticeTitle: null,
        noticeContent: null,
      },
      form: {},
      rules: {
        noticeTitle: [
          { required: true, message: "公告标题不能为空", trigger: "blur" }
        ],
        noticeContent: [
          { required: true, message: "公告内容不能为空", trigger: "blur" }
        ],
      }
    };
  },
  
  computed: {
    todayNewCount() {
      const today = new Date().toDateString();
      return this.adviseList.filter(item => 
        new Date(item.createTime).toDateString() === today
      ).length;
    }
  },
  
  created() {
    this.getList();
  },
  
  methods: {
    getList() {
      this.loading = true;
      listAdvise(this.queryParams).then(response => {
        this.adviseList = response.data.rows || [];
        this.loading = false;
      });
    },
    
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "发布公告";
    },

    handleUpdate(row) {
      this.reset();
      const noticeId = row.noticeId;
      getAdvise(noticeId).then(response => {
        this.form = response.data.data;
        this.open = true;
        this.title = "修改公告";
      });
    },

    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.noticeId != null) {
            updateAdvise(this.form).then(response => {
              this.$message.success("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addAdvise(this.form).then(response => {
              this.$message.success("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    
    handleDelete(row) {
      const noticeIds = row.noticeId;
      delAdvise(noticeIds).then(response => {
        this.$message.success("删除成功");
        this.getList();
      });
    },
    
    cancel() {
      this.open = false;
      this.reset();
    },
    
    reset() {
      this.form = {
        noticeId: null,
        noticeTitle: null,
        noticeContent: null,
        createBy: null,
        createTime: null,
        remark: null
      };
    },
    
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    
    transform(time) {
      if (!time) return '-';
      let date = new Date(time);
      return formatDate(date, 'yyyy-MM-dd hh:mm');
    }
  },
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
</style>
