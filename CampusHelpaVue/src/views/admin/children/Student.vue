<template>
  <div class="content">
    <div class="center">
      <el-input 
        placeholder="请输入内容" 
        v-model="input" 
        class="input-with-select search-box"
        @keydown.enter.native="clickSearch">
        <el-select v-model="select" slot="prepend" placeholder="请选择" value="1">
          <el-option label="学号" value="1"></el-option>
          <el-option label="姓名" value="2"></el-option>
        </el-select>
        <el-button slot="append" icon="el-icon-search" @click="clickSearch"></el-button>
      </el-input>
    </div>

    <div class="bottom">
      <el-table
        :data="users"
        stripe
        highlight-current-row
        :header-cell-style="headerStyle"
        :cell-style="cellStyle"
        style="width: 100%">
        <el-table-column 
          prop="studentId" 
          label="学号" 
          width="130" 
          fixed="left">
        </el-table-column>
        
        <el-table-column 
          prop="username" 
          label="姓名" 
          width="100">
        </el-table-column>
        
        <el-table-column 
          prop="phone" 
          label="手机号" 
          width="120">
        </el-table-column>
        
        <el-table-column 
          label="性别" 
          width="80">
          <template slot-scope="scope">
            <span :class="['gender-tag', scope.row.sex==0 ? 'male' : 'female']">
              {{scope.row.sex==0?'男':'女'}}
            </span>
          </template>
        </el-table-column>
        
        <el-table-column 
          prop="school.name" 
          label="学校" 
          min-width="180" 
          show-overflow-tooltip>
        </el-table-column>
        
        <el-table-column 
          prop="dept.name" 
          label="所在系" 
          width="120" 
          show-overflow-tooltip>
        </el-table-column>
        
        <el-table-column 
          prop="aclass.name" 
          label="班级" 
          width="140" 
          show-overflow-tooltip>
        </el-table-column>
        
        <!-- <el-table-column 
          label="余额" 
          width="90" 
          align="right">
          <template slot-scope="scope">
            <span class="balance-cell">¥{{scope.row.balance}}</span>
          </template>
        </el-table-column> -->
        
        <el-table-column 
          label="禁用用户" 
          width="110">
          <template slot-scope="scope">
            <el-switch
              :value="scope.row.state ==1"
              active-color="#13ce66"
              inactive-color="#ff4949"
              @change="edit(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        
        <el-table-column 
          label="操作" 
          width="90" 
          fixed="right">
          <template slot-scope="scope">
            <el-popconfirm 
              confirm-button-text='好的'
              cancel-button-text='不用了'
              icon="el-icon-info"
              icon-color="red"
              title="确定删除该学生吗？"
              @confirm="del(scope.row.id)"
            >
              <el-button 
                type="text" 
                size="mini" 
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
export default {
  name: "Student",
  methods: {
    headerStyle() {
      return {
        background: '#eef1f6',
        color: '#606266',
        fontWeight: '600',
        fontSize: '14px',
        padding: '12px 0',
        border: '1px solid #ebeef5',
        borderBottom: '1px solid #dcdfe6'
      }
    },
    
    cellStyle() {
      return {
        padding: '12px 0',
        fontSize: '13px',
        border: '1px solid #ebeef5'
      }
    },
    
    clickSearch() {
      let parameter = {};
      if (this.input) {
        parameter = this.select == 1 
          ? {"studentId": this.input} 
          : {"username": this.input};
        this.$get("/user", parameter)
          .then((res) => {
            this.users = res.data.user
            this.input = ""
          })
      } else {
        this.newList()
      }
    },
    
    del(id) {
      this.$del("/user/"+id)
        .then((res) => {
          this.$notifyMsg("成功", res.data.msg, "success")
          this.newList()
        })
    },
    
    edit(row) {
      row.state = row.state == 1 ? 0 : 1;
      this.$put("/user", {id: row.id, state: row.state})
        .then((res) => {
          this.$notifyMsg("成功", res.data.msg, "success")
          this.newList()
        })
        .catch(() => {
          // 恢复原始状态
          row.state = row.state == 1 ? 0 : 1;
          this.$notifyMsg("失败", "操作失败", "error")
        })
    },
    
    newList() {
      this.$get("/user")
        .then((rs) => {
          this.users = rs.data.user
        })
    },
  },
  
  data() {
    return {
      users: [],
      input: '',
      select: '1'
    }
  },
  
  created() {
    this.newList()
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
  
  .center {
    width: 100%;
    margin-bottom: 20px;
    
    .search-box {
      max-width: 600px;
      margin: 0 auto;
      
      /deep/ .el-select .el-input {
        width: 100px;
      }
    }
  }
  
  .bottom {
    background: #fff;
    border-radius: 6px;
    overflow: hidden;
    box-shadow: 0 1px 6px rgba(0,0,0,0.05);
    border: 1px solid #ebeef5;
  }
}

.el-table {
  border: 1px solid #ebeef5;
  border-radius: 6px;
  overflow: hidden;
  
  /deep/ th {
    background: #eef1f6;
    color: #606266;
    font-weight: 600;
    font-size: 14px;
    padding: 12px 0;
    border: 1px solid #ebeef5;
    border-bottom: 1px solid #dcdfe6;
  }
  
  /deep/ td {
    padding: 12px 0;
    font-size: 13px;
    border: 1px solid #ebeef5;
  }
  
  /deep/ .el-table__body tr:nth-child(2n) {
    background: #fafafa;
  }
  
  /deep/ .el-table__body tr:hover {
    background: #f5f7fa !important;
  }
  
  /deep/ .el-table__fixed, 
  /deep/ .el-table__fixed-right {
    border-left: 1px solid #ebeef5;
    border-right: 1px solid #ebeef5;
    
    &:before {
      background: #ebeef5;
    }
  }
  
  /deep/ .el-table__fixed-right-patch {
    border-bottom: 1px solid #ebeef5;
    border-left: 1px solid #ebeef5;
    background: #eef1f6;
  }
  
  /deep/ .el-table__row {
    &:last-child {
      td {
        border-bottom: none;
      }
    }
  }
}

.gender-tag {
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 12px;
  border: 1px solid #ebeef5;
  
  &.male {
    background: #ecf5ff;
    color: #409eff;
  }
  
  &.female {
    background: #fdf6ec;
    color: #e6a23c;
  }
}

.balance-cell {
  font-family: monospace;
  font-weight: 500;
  color: #67c23a;
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
    
    .center {
      .search-box {
        max-width: 100%;
      }
    }
    
    /deep/ .el-table td {
      padding: 8px 0;
    }
  }
}
</style>