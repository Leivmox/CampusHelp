<template>
  <div class="page-container">
    <div class="page-header">
      <h3 class="page-title">用户管理</h3>
      <p class="page-desc">管理系统中的所有用户信息</p>
    </div>

    <el-card class="search-card" shadow="never">
      <div class="search-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索学号或姓名..."
          prefix-icon="el-icon-search"
          clearable
          style="width: 280px"
          @input="filterUsers">
        </el-input>
        
        <el-button type="primary" icon="el-icon-refresh" @click="loadUsers">刷新</el-button>
      </div>
    </el-card>

    <el-card class="stats-card" shadow="never">
      <div class="stats-row">
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <i class="el-icon-user"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ users.length }}</div>
            <div class="stat-label">总用户数</div>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <i class="el-icon-plus"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ todayNewUsers }}</div>
            <div class="stat-label">今日新增</div>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);">
            <i class="el-icon-warning"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ disabledUsers }}</div>
            <div class="stat-label">禁用用户</div>
          </div>
        </div>
      </div>
    </el-card>

    <el-card class="table-card" shadow="never">
      <el-table
        :data="filteredUsers"
        border
        stripe
        highlight-current-row
        style="width: 100%">
        
        <el-table-column label="头像" width="90" align="center">
          <template slot-scope="scope">
            <el-upload
              class="avatar-uploader"
              action="http://localhost:8080/common/upload"
              :show-file-list="false"
              :on-success="(res, file) => handleAvatarSuccess(res, file, scope.row)"
              :before-upload="beforeAvatarUpload"
              :data="{ type: 'avatar' }"
              name="file"
              :headers="headers"
            >
              <el-tooltip content="点击更换头像" placement="top">
                <div class="avatar-wrapper">
                  <el-avatar :size="40" :src="getAvatarUrl(scope.row.avatar)">
                    {{ getAvatarText(scope.row) }}
                  </el-avatar>
                  <div class="avatar-hover-mask">
                    <i class="el-icon-camera"></i>
                  </div>
                </div>
              </el-tooltip>
            </el-upload>
          </template>
        </el-table-column>
        
        <el-table-column prop="studentId" label="学号" min-width="120">
        </el-table-column>
        
        <el-table-column prop="username" label="姓名" min-width="100">
        </el-table-column>
        
        <el-table-column prop="phone" label="手机号" min-width="120">
        </el-table-column>
        
        <el-table-column label="性别" width="80" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.sex === 0 ? 'primary' : 'danger'" size="small">
              {{ scope.row.sex === 0 ? '男' : '女' }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column label="学校" min-width="140" show-overflow-tooltip>
          <template slot-scope="scope">
            {{ scope.row.school ? scope.row.school.name : '-' }}
          </template>
        </el-table-column>
        
        <el-table-column label="院系" min-width="120" show-overflow-tooltip>
          <template slot-scope="scope">
            {{ scope.row.dept ? scope.row.dept.name : '-' }}
          </template>
        </el-table-column>
        
        <el-table-column label="班级" min-width="120" show-overflow-tooltip>
          <template slot-scope="scope">
            {{ scope.row.aclass ? scope.row.aclass.name : '-' }}
          </template>
        </el-table-column>
        
        <el-table-column label="积分" width="90" align="center">
          <template slot-scope="scope">
            <span class="balance">{{ scope.row.balance || 0 }}</span>
          </template>
        </el-table-column>
        
        <el-table-column label="注册时间" min-width="160" align="center">
          <template slot-scope="scope">
            {{ scope.row.createTime | formatDate }}
          </template>
        </el-table-column>
        
        <el-table-column label="状态" width="90" align="center">
          <template slot-scope="scope">
            <el-switch
              :value="scope.row.state === 1"
              active-color="#f56c6c"
              inactive-color="#67c23a"
              @change="toggleStatus(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="140" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button 
              type="primary" 
              size="mini" 
              icon="el-icon-edit"
              plain
              @click="openEditDialog(scope.row)">
            </el-button>
            <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-warning"
              icon-color="red"
              title="确定删除该用户吗？此操作不可恢复！"
              @confirm="delUser(scope.row.id)"
            >
              <el-button 
                type="danger" 
                size="mini" 
                icon="el-icon-delete"
                plain
                slot="reference">
              </el-button>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog
      title="编辑用户信息"
      :visible.sync="editDialogVisible"
      width="500px"
      destroy-on-close>
      <el-form :model="editForm" :rules="editRules" ref="editFormRef" label-width="80px">
        <el-form-item label="学号" prop="studentId">
          <el-input v-model="editForm.studentId" placeholder="请输入学号"></el-input>
        </el-form-item>
        
        <el-form-item label="姓名" prop="username">
          <el-input v-model="editForm.username" placeholder="请输入姓名"></el-input>
        </el-form-item>
        
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="editForm.phone" placeholder="请输入手机号"></el-input>
        </el-form-item>
        
        <el-form-item label="性别" prop="sex">
          <el-radio-group v-model="editForm.sex">
            <el-radio :label="0">男</el-radio>
            <el-radio :label="1">女</el-radio>
          </el-radio-group>
        </el-form-item>
        
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="editForm.email" placeholder="请输入邮箱"></el-input>
        </el-form-item>
        
        <el-form-item label="个性签名" prop="signature">
          <el-input type="textarea" :rows="2" v-model="editForm.signature" placeholder="请输入个性签名"></el-input>
        </el-form-item>
        
        <el-form-item label="积分" prop="balance">
          <el-input-number v-model="editForm.balance" :min="0" :max="99999"></el-input-number>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="editDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitEdit">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { formatDate } from '@/util/date';
import { updateUserAvatar } from '@/api/system/user';

export default {
  name: "AdminStudent",
  data() {
    return {
      users: [],
      filteredUsers: [],
      searchKeyword: '',
      baseUrl: "http://localhost:8080",
      headers: {
        Authorization: localStorage.getItem("token"),
      },
      editDialogVisible: false,
      editForm: {
        id: null,
        studentId: '',
        username: '',
        phone: '',
        sex: 0,
        email: '',
        signature: '',
        balance: 0
      },
      editRules: {
        studentId: [
          { required: true, message: '请输入学号', trigger: 'blur' }
        ],
        username: [
          { required: true, message: '请输入姓名', trigger: 'blur' }
        ],
        phone: [
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
        ],
        email: [
          { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
        ]
      }
    }
  },
  
  computed: {
    todayNewUsers() {
      const today = new Date().toDateString();
      return this.users.filter(u => new Date(u.createTime).toDateString() === today).length;
    },
    
    disabledUsers() {
      return this.users.filter(u => u.state === 1).length;
    }
  },
  
  created() {
    this.loadUsers();
  },
  
  methods: {
    loadUsers() {
      this.$get("/user").then(res => {
        this.users = res.data.user || [];
        this.filterUsers();
      });
    },
    
    filterUsers() {
      if (!this.searchKeyword) {
        this.filteredUsers = this.users;
      } else {
        const keyword = this.searchKeyword.toLowerCase();
        this.filteredUsers = this.users.filter(user => 
          (user.studentId && user.studentId.toLowerCase().includes(keyword)) ||
          (user.username && user.username.toLowerCase().includes(keyword))
        );
      }
    },
    
    toggleStatus(row) {
      const newState = row.state === 1 ? 0 : 1;
      this.$put("/user", { id: row.id, state: newState }).then(res => {
        if (res.data.status) {
          this.$message.success(newState === 1 ? '已禁用该用户' : '已启用该用户');
          this.loadUsers();
        } else {
          this.$message.error('操作失败');
        }
      });
    },
    
    delUser(id) {
      this.$del("/user/" + id).then(res => {
        if (res.data.status) {
          this.$message.success('删除成功');
          this.loadUsers();
        } else {
          this.$message.error(res.data.msg || '删除失败');
        }
      });
    },
    
    openEditDialog(user) {
      this.editForm = {
        id: user.id,
        studentId: user.studentId,
        username: user.username,
        phone: user.phone || '',
        sex: user.sex || 0,
        email: user.email || '',
        signature: user.signature || '',
        balance: user.balance || 0
      };
      this.editDialogVisible = true;
    },
    
    submitEdit() {
      this.$refs.editFormRef.validate(valid => {
        if (valid) {
          this.$put("/user", this.editForm).then(res => {
            if (res.data.status) {
              this.$message.success('修改成功');
              this.editDialogVisible = false;
              this.loadUsers();
            } else {
              this.$message.error(res.data.msg || '修改失败');
            }
          });
        }
      });
    },
    
    beforeAvatarUpload(file) {
      const isImage = file.type === 'image/jpeg' || file.type === 'image/png' || file.type === 'image/gif';
      const isLt5M = file.size / 1024 / 1024 < 5;
      
      if (!isImage) {
        this.$message.error('只能上传 JPG/PNG/GIF 格式的图片!');
        return false;
      }
      if (!isLt5M) {
        this.$message.error('图片大小不能超过 5MB!');
        return false;
      }
      return true;
    },
    
    handleAvatarSuccess(res, file, user) {
      if (res.code === 200 || res.status === 200) {
        const uploadedUrl = res.url || res.data?.url;
        if (!uploadedUrl) {
          this.$message.error('上传失败，未获取到图片地址');
          return;
        }
        
        updateUserAvatar({
          id: user.id,
          studentId: user.studentId,
          avatar: uploadedUrl
        }).then(response => {
          this.$message.success('头像修改成功');
          this.$set(user, 'avatar', uploadedUrl);
        }).catch(() => {
          this.$message.error('头像更新失败');
        });
      } else {
        this.$message.error(res.msg || '头像上传失败');
      }
    },
    
    getAvatarUrl(avatar) {
      if (!avatar) return '';
      if (avatar.startsWith('http')) return avatar;
      return this.baseUrl + avatar;
    },
    
    getAvatarText(user) {
      if (!user || !user.username) return 'U';
      return user.username.charAt(0).toUpperCase();
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
@deep-blue: #165dff;

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

.avatar-uploader {
  display: inline-block;
  
  .avatar-wrapper {
    position: relative;
    cursor: pointer;
    display: inline-block;
    border-radius: 50%;
    
    .avatar-hover-mask {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.5);
      border-radius: 50%;
      display: flex;
      justify-content: center;
      align-items: center;
      opacity: 0;
      transition: opacity 0.3s;
      
      i {
        color: white;
        font-size: 16px;
      }
    }
    
    &:hover .avatar-hover-mask {
      opacity: 1;
    }
  }
}

.balance {
  font-weight: 600;
  color: #ff7d00;
}

/deep/ .el-upload {
  display: flex;
  justify-content: center;
}
</style>
