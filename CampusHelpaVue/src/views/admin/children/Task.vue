<template>
  <div class="content">
    <div class="bottom">
      <el-table
        :data="tasks"
        border
        stripe
        highlight-current-row
        :header-cell-style="headerStyle"
        :cell-style="cellStyle"
        :row-style="rowStyle"
        style="width: 100%">
        
        <el-table-column
          prop="publish.username"
          label="发布人"
          min-width="140"
          align="center">
        </el-table-column>
        
        <el-table-column
          label="接受人"
          min-width="140"
          align="center">
          <template slot-scope="scope">
            <span v-if="scope.row.accept">{{scope.row.accept.username}}</span>
            <span v-else class="no-accept">暂无服务</span>
          </template>
        </el-table-column>
        
        <el-table-column
          prop="reward"
          label="求助奖励"
          min-width="110"
          align="center">
        </el-table-column>
        
        <el-table-column
          prop="school.name"
          label="求助所在学校"
          min-width="200"
          align="center">
        </el-table-column>
        
        <el-table-column
          prop="taskTitle"
          label="标题"
          min-width="180"
          align="center"
          show-overflow-tooltip>
        </el-table-column>
        
        <el-table-column
          label="发布时间"
          min-width="160"
          align="center">
          <template slot-scope="scope">
            {{scope.row.createTime ? transform(scope.row.createTime) : '暂无时间'}}
          </template>
        </el-table-column>
        
        <el-table-column
          label="服务时间"
          min-width="160"
          align="center">
          <template slot-scope="scope">
            {{scope.row.orderTime ? transform(scope.row.orderTime) : '暂无时间'}}
          </template>
        </el-table-column>
        
        <el-table-column
          label="完成时间"
          min-width="160"
          align="center">
          <template slot-scope="scope">
            {{scope.row.endTime ? transform(scope.row.endTime) : '暂无时间'}}
          </template>
        </el-table-column>
        
        <el-table-column
          label="求助状态"
          min-width="90"
          align="center">
          <template slot-scope="scope">
            <el-tag :type="statusTag(scope.row.state)">
              {{scope.row.state == 0?'未处理':scope.row.state == 1 ? '处理中' : '已完成'}}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column
          label="操作"
          width="100"
          align="center">
          <template slot-scope="scope">
            <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-info"
              icon-color="red"
              title="确定删除该求助吗？"
              @confirm="del(scope.row.id,scope.row.state)"
            >
              <el-button 
                type="text" 
                size="small" 
                class="delete-btn"
                slot="reference">
                <i class="el-icon-delete"></i>
              </el-button>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
import {formatDate} from '@/util/date';

export default {
  name: "Task",
  methods: {
    statusTag(state) {
      const typeMap = {
        0: 'info',
        1: 'warning',
        2: 'success'
      };
      return typeMap[state] || '';
    },
    
    headerStyle() {
      return {
        background: '#f5f7fa',
        color: '#606266',
        fontWeight: '600',
        borderRight: '1px solid #ebeef5'
      };
    },
    
    cellStyle() {
      return {
        padding: '12px 0',
        borderRight: '1px solid #ebeef5'
      };
    },
    
    rowStyle() {
      return {
        borderBottom: '1px solid #ebeef5'
      };
    },
    
    inquiry(){
      if (this.select == 'entire'){
        this.newList();
      } else {
        this.$post("/task/api/findTaskBySchoolId",{"id":this.select})
          .then(res => {
            this.tasks = res.data.tasks
          })
      }
    },
    
    clickSearch() {
      if(this.input == '已完成'){
        // 可扩展搜索逻辑
      }
    },
    
    del(id,state) {
      if (state == 0){
        this.$del("/task/"+id)
          .then((res) => {
            this.$notifyMsg("成功", res.data.msg, "success")
            this.newList()
          })
      } else {
        this.$msg("该求助已被接收或已完成","error")
      }
    },
    
    newList() {
      this.$get("/task")
        .then((rs) => {
          this.tasks = rs.data.task
        })
    },
    
    transform(time) {
      let date = new Date(time);
      return formatDate(date, 'yyyy-MM-dd hh:mm');
    }
  },
  
  data() {
    return {
      schools:[],
      tasks: [],
      ruleForm: {
        id: 0,
        state: true
      },
      options: [
        {label: "正常", value: "0"},
        {label: "禁用", value: "1"}
      ],
      input:"",
      select: 'entire'
    }
  },
  
  created() {
    this.newList();
    this.$get("school")
      .then(res => {
        this.schools = res.data.schools
      })
  }
}
</script>

<style scoped lang="less">
.content {
  padding: 15px;
  background: #f5f7fa;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
  border: 1px solid #dcdfe6;
  
  .bottom {
    background: #fff;
    border-radius: 6px;
    overflow: hidden;
    box-shadow: 0 1px 6px rgba(0,0,0,0.05);
    border: 1px solid #ebeef5;
  }
}

/deep/ .el-table {
  border-collapse: collapse;
  
  &::before {
    height: 0;
  }
  
  th {
    background: #f5f7fa;
    border-right: 1px solid #ebeef5 !important;
    border-bottom: 1px solid #ebeef5 !important;
  }
  
  td {
    border-right: 1px solid #ebeef5 !important;
    border-bottom: 1px solid #ebeef5 !important;
  }
  
  tr:last-child td {
    border-bottom: none !important;
  }
  
  .el-table__row {
    &:hover {
      background-color: #f5f7fa !important;
    }
  }
}

/deep/ .el-table__fixed, 
/deep/ .el-table__fixed-right {
  border-left: 1px solid #ebeef5;
  
  &:before {
    background: #ebeef5;
  }
}

.no-accept {
  color: #909399;
  font-style: italic;
}

.delete-btn {
  color: #f56c6c;
  font-size: 16px;
  transition: all 0.3s;
  
  &:hover {
    transform: scale(1.2);
  }
}

@media (max-width: 768px) {
  .content {
    padding: 10px;
    
    /deep/ .el-table td {
      padding: 8px 0;
    }
  }
}
</style>