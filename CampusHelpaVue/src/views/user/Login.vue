<template>
  <div class="login-container">
    <el-card class="login-card">
      <!-- 登录表单 -->
      <div v-show="!isShow" class="login-form">
        <h2>校园IT互助系统</h2>
        <el-input 
          prefix-icon="el-icon-user"
          v-model="studentId"
          placeholder="请输入学号"
          maxlength="11"
          oninput="value=value.replace(/[^\d]/g,'')"
        ></el-input>
        
        <el-input 
          prefix-icon="el-icon-lock"
          v-model="password"
          placeholder="请输入密码"
          show-password
          @keyup.enter="toLogin('sign')"
        ></el-input>
        
        <el-select 
          v-model="schoolId" 
          placeholder="请选择学校"
          filterable
          class="school-select"
        >
          <el-option
            v-for="item in school"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          ></el-option>
        </el-select>
        
        <el-button 
          type="primary" 
          class="login-btn"
          @click="toLogin('sign')"
          :loading="loading"
        >登录</el-button>
        
        <div class="auth-actions">
          <router-link to="/admin" class="action-link">管理员入口</router-link>
        </div>
      </div>
      
      <!-- 注册表单 -->
      <div v-show="isShow" class="register-form">
        <h2>立即注册</h2>
        <label>
          <span>学号</span>
          <el-input 
            prefix-icon="el-icon-user"
            v-model="studentId"
            placeholder="请输入学号"
            maxlength="11"
            oninput="value=value.replace(/[^\d]/g,'')"
          ></el-input>
        </label>
        
        <label>
          <span>密码</span>
          <el-input 
            prefix-icon="el-icon-lock"
            v-model="password"
            placeholder="请输入密码"
            show-password
          ></el-input>
        </label>
        
        <label>
          <span>选择学校</span>
          <el-select 
            v-model="schoolId" 
            placeholder="请选择学校"
            filterable
            class="school-select"
          >
            <el-option
              v-for="item in school"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            ></el-option>
          </el-select>
        </label>
        
        <el-button 
          type="primary" 
          class="login-btn"
          @click="toLogin('register')"
        >注册</el-button>
      </div>
      
      <!-- 切换按钮 -->
      <div class="switch-btn" @click="isShow = !isShow">
        {{ isShow ? '已有账号？登录' : '还未注册？注册' }}
      </div>
    </el-card>
  </div>
</template>

<script>
import { setCookie, getCookie } from "@/util/util";
import md5 from 'js-md5';

export default {
  name: "Login",
  data() {
    return {
      isShow: false,
      loading: false,
      studentId: "",
      password: "",
      school: [],
      schoolId: ''
    }
  },
  created() {
    this.$get("/school")
      .then((res) => {
        this.school = res.data.school
      })
  },
  methods: {
    toLogin(val) {
      if (this.studentId && this.password && this.schoolId) {
        this.loading = true;
        
        // 登录
        if (val === 'sign') {
          this.$get("/user/login", {
            "studentId": this.studentId,
            "password": md5(this.password),
            "schoolId": this.schoolId
          }).then((res) => {
            this.loading = false;
            if (res.data.status) {
              if (res.data.user.state == 0) {
                sessionStorage.setItem("user", JSON.stringify(res.data.user));
                this.$msg(`${res.data.user.username || res.data.user.studentId}，登录成功`, "success");
                this.$router.push("/home");
              } else {
                this.$msg('该用户已被冻结，请联系管理员', "error");
              }
            } else {
              this.$msg(res.data.msg, "error");
            }
          }).catch(() => this.loading = false);
          
        } 
        // 注册
        else {
          this.$post("/user", {
            "studentId": this.studentId,
            "password": md5(this.password),
            "schoolId": this.schoolId
          }).then((res) => {
            this.loading = false;
            if (res.data.status) {
              this.$msg(res.data.msg, "success");
              this.isShow = false;
              this.studentId = "";
              this.password = "";
              this.schoolId = "";
            } else {
              this.$msg(res.data.msg, "error");
            }
          }).catch(() => this.loading = false);
        }
      } else {
        this.$msg("请填写正确的信息", "error");
        this.loading = false;
      }
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  background-size: cover;
  background-image: url("../../assets/img/bg.jpg");
}

.login-card {
  width: 90%;
  max-width: 420px;
  border-radius: 16px;
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
  background: rgba(255, 255, 255, 0.95);
  animation: fadeIn 0.8s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.login-form, .register-form {
  padding: 30px;
}

h2 {
  text-align: center;
  margin-bottom: 25px;
  color: #1f2d3d;
  font-size:28px;
}

.el-input, .el-select {
  margin-bottom: 20px;
  width: 100%;
}

.school-select {
  display: block;
}

.login-btn {
  width: 100%;
  height: 48px;
  font-size: 18px;
  font-weight: 500;
  border-radius: 10px;
  background: linear-gradient(to right, #4b6cb7, #182848);
  border: none;
  box-shadow: 0 4px 12px rgba(75, 108, 183, 0.3);
  transition: all 0.3s ease;
  color: white;
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 14px rgba(75, 108, 183, 0.4);
}

.login-btn:active {
  transform: translateY(1px);
}

.auth-actions {
  text-align: right;
  margin-top: 15px;
}

.action-link {
  color: #4b6cb7;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s ease;
  font-size: 14px;
}

.action-link:hover {
  color: #182848;
  text-decoration: underline;
}

.switch-btn {
  text-align: center;
  padding: 15px;
  color: #4b6cb7;
  cursor: pointer;
  border-top: 1px solid #eee;
}

/* 响应式适配 */
@media (max-width: 768px) {
  .login-card {
    width: 95%;
    max-width: none;
  }
  
  .login-form, .register-form {
    padding: 20px;
  }
}
</style>