<template>
  <div class="content">
    <!-- 顶部筛选栏 (复用逻辑，管理员通常需要按学校查看帖子) -->
    <div class="search-box" style="margin-bottom: 15px; display: flex; align-items: center;">
      <span style="margin-right: 10px; font-weight: bold; color: #606266;">选择学校:</span>
      <el-select v-model="selectSchoolId" placeholder="请选择学校" @change="fetchPosts">
        <el-option
          v-for="item in schools"
          :key="item.id"
          :label="item.name"
          :value="item.id">
        </el-option>
      </el-select>
      <el-button type="primary" icon="el-icon-refresh" style="margin-left: 10px" @click="fetchPosts">刷新列表</el-button>
    </div>

    <div class="bottom">
      <el-table
        :data="posts"
        border
        stripe
        highlight-current-row
        :header-cell-style="headerStyle"
        :cell-style="cellStyle"
        :row-style="rowStyle"
        style="width: 100%">
        
        <!-- 发布人 -->
        <el-table-column
          label="发布人"
          min-width="120"
          align="center">
          <template slot-scope="scope">
             <el-tag size="small" type="info" v-if="scope.row.publisher">{{ scope.row.publisher.username }}</el-tag>
             <span v-else>未知用户</span>
          </template>
        </el-table-column>
        
        <!-- 帖子标题 -->
        <el-table-column
          prop="title"
          label="帖子标题"
          min-width="150"
          align="center"
          show-overflow-tooltip>
        </el-table-column>

        <!-- 帖子内容 (截取显示) -->
        <el-table-column
          prop="content"
          label="内容摘要"
          min-width="200"
          align="center"
          show-overflow-tooltip>
        </el-table-column>
        
        <!-- 数据统计 -->
        <el-table-column
          label="互动数据"
          min-width="120"
          align="center">
          <template slot-scope="scope">
            <span style="margin-right: 10px"><i class="el-icon-thumb"></i> {{ scope.row.likeCount || 0 }}</span>
            <span><i class="el-icon-chat-dot-round"></i> {{ scope.row.comments ? scope.row.comments.length : 0 }}</span>
          </template>
        </el-table-column>
        
        <!-- 发布时间 -->
        <el-table-column
          label="发布时间"
          min-width="160"
          align="center">
          <template slot-scope="scope">
            {{ scope.row.createTime ? transform(scope.row.createTime) : '暂无时间' }}
          </template>
        </el-table-column>
        
        <!-- 操作 -->
        <el-table-column
          label="操作"
          width="120"
          align="center">
          <template slot-scope="scope">
            <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-warning"
              icon-color="red"
              title="确定强制删除该帖子吗？"
              @confirm="del(scope.row.id)"
            >
              <el-button 
                type="danger" 
                size="mini" 
                slot="reference"
                icon="el-icon-delete">
                删除
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
  name: "AdminPost",
  data() {
    return {
      schools: [], // 学校列表
      posts: [],   // 帖子列表
      selectSchoolId: null // 当前选中的学校ID
    }
  },
  
//   created() {
//     // 1. 先获取所有学校
//     this.$get("school").then(res => {
//         if(res.data.schools && res.data.schools.length > 0){
//             this.schools = res.data.schools;
//             // 默认选中第一个学校并加载数据
//             this.selectSchoolId = this.schools[0].id;
//             this.fetchPosts();
//         }
//       });
//   },
created() {
    // 1. 先获取所有学校
    this.$get("school").then(res => {
        // --- 调试代码开始 ---
        console.log("后端返回的学校数据:", res);
        // --- 调试代码结束 ---

        // 注意：这里检查的是 res.data.schools
        // 如果你的 MessageTools 返回的是 "data" 或 "school" (单数)，这里就会失败
        if(res.data.schools && res.data.schools.length > 0){
            this.schools = res.data.schools;
            this.selectSchoolId = this.schools[0].id;
            this.fetchPosts();
        } else {
            // 如果走到这里，说明格式不对，或者列表为空
            console.log("数据格式不对，或者列表为空");
            // 备用方案：防止后端 key 写成单数 'school'
            if(res.data.school) {
                 this.schools = res.data.school;
            }
        }
      });
  },
  methods: {
    // 获取帖子列表
    fetchPosts() {
      if(!this.selectSchoolId) return;
      
      this.$get("/post", { schoolId: this.selectSchoolId })
        .then((rs) => {
          if(rs.data.status){
             this.posts = rs.data.posts;
          } else {
             this.$msg("获取列表失败", "error");
          }
        });
    },
    
    // 删除帖子
    del(id) {
      this.$del("/post/" + id).then((res) => {
          if(res.data.status){
            this.$notifyMsg("成功", "帖子已删除", "success");
            this.fetchPosts(); // 刷新列表
          } else {
            this.$notifyMsg("失败", res.data.msg, "error");
          }
      });
    },
    
    // 时间格式化
    transform(time) {
      let date = new Date(time);
      return formatDate(date, 'yyyy-MM-dd hh:mm');
    },

    // --- 以下样式方法直接复用 Task.vue ---
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
  }
}
</script>

<style scoped lang="less">
// 直接复用 Task.vue 的样式，保证风格统一
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
</style>