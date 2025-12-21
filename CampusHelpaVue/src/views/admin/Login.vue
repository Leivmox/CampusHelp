<template>
  <div class="login-container">
  <h1 class="system-title">校园IT互助系统</h1>
    <el-card class="login-card">
      <div class="login-content">
        <div class="login-header">
          <h2 class="login-title">管理员登录</h2>
          <p class="login-subtitle">安全高效的管理平台</p>
        </div>

        <el-form
          ref="ruleForm"
          :model="ruleForm"
          :rules="rules"
          status-icon
          label-position="top"
          @submit.native.prevent
        >
          <div class="input-group">
            <el-input
              placeholder="请输入管理员账号"
              v-model="ruleForm.account"
              prefix-icon="el-icon-user"
              class="login-input"
            ></el-input>
          </div>

          <div class="input-group">
            <el-input
              placeholder="请输入管理员密码"
              v-model="ruleForm.password"
              prefix-icon="el-icon-lock"
              show-password
              @keyup.enter.native="submitForm('ruleForm')"
              class="login-input"
            ></el-input>
          </div>

          <div class="login-submit">
            <el-button
              type="primary"
              class="login-btn"
              @click="submitForm('ruleForm')"
              :loading="loading"
              >登录</el-button
            >
          </div>

          <div class="other-actions">
            <router-link to="/" class="action-link">用户登录入口</router-link>
          </div>
        </el-form>
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "Login",
  data() {
    var validateaccount = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("请输入帐号"));
      } else {
        callback();
      }
    };
    var validatepassword = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("请输入密码"));
      } else {
        callback();
      }
    };
    return {
      checked: false,
      loading: false,
      ruleForm: {
        account: "",
        password: "",
      },
      rules: {
        account: [{ validator: validateaccount, trigger: "blur" }],
        password: [{ validator: validatepassword, trigger: "blur" }],
      },
    };
  },
  methods: {
    submitForm(formName) {
      this.loading = true;
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$get("/admin", this.ruleForm)
            .then((res) => {
              this.loading = false;
              if (res.data.status) {
                if (this.checked) {
                  localStorage.setItem(
                    "remember",
                    JSON.stringify(this.ruleForm)
                  );
                }
                this.$msg(`${res.data.admin.username} ，登陆成功`, "success");
                sessionStorage.setItem("admin", JSON.stringify(res.data.admin));
                this.$router.push("/admin/home");
              } else {
                this.$msg(res.data.msg, "error");
              }
            })
            .catch(() => {
              this.loading = false;
            });
        } else {
          this.loading = false;
          return false;
        }
      });
    },
  },
  created() {
    if (localStorage.getItem("remember")) {
      let remember = JSON.parse(localStorage.getItem("remember"));
      this.ruleForm.account = remember.account;
      this.ruleForm.password = remember.password;
      this.checked = true;
    }
  },
};
</script>

<style scoped>
/* h2 {
  text-align: center;
  margin-bottom: 25px;
  color: #005EEB;
  font-size: 28px;
} */

.login-container {
  /* 修改：改为相对定位，作为坐标参考系 */
  position: relative;
  width: 100%;
  height: 100vh;

  /* 背景图改为 bg3 */
  background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
  background-size: cover;
  background-image: url("../../assets/img/bg3.jpg");
  overflow: hidden;
}

.login-card {
  /* 修改：使用绝对定位，位置锁定在 2/3 处 */
  position: absolute;
  top: 55%;
  left: 66.66%;
  transform: translate(-50%, -50%);

  width: 90%;
  max-width: 420px;
  border-radius: 16px;
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);

  /* 修改：背景透明度 + 磨砂效果 */
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3);

  animation: fadeIn 0.8s ease-out forwards;
}

/* 修改：动画配合 translate */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translate(-50%, -40%);
  }
  to {
    opacity: 1;
    transform: translate(-50%, -50%);
  }
}

.login-content {
  padding: 40px 35px;
}

.login-header {
  text-align: center;
  margin-bottom: 35px;
}

.login-title {
  font-size: 28px;
  /* 修改：标题颜色与用户端一致 */
  color: #005eeb;
  margin-bottom: 8px;
  /* font-weight: normal; 去掉粗体，或者保留看你喜好，这里默认保持跟普通h2类似 */
}

.login-subtitle {
  font-size: 14px;
  color: #5c6b7f; /* 稍微加深一点灰色以适配透明背景 */
}

.input-group {
  margin-bottom: 22px;
}

.login-input {
  border-radius: 10px;
}

/* 修改：按钮样式与用户端一致 */
.login-btn {
  width: 100%;
  height: 48px; /* 高度微调匹配 */
  font-size: 18px;
  font-weight: 500;
  border-radius: 30px; /* 圆角改为30px */
  background: linear-gradient(
    to right,
    #8da7e3,
    #6192f5
  ); /* 颜色改为淡蓝渐变 */
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

.other-actions {
  margin-top: 25px;
  text-align: center;
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

/* 响应式适配 */
@media (max-width: 768px) {
  .login-card {
    /* 手机端强制回正 */
    left: 50%;
    width: 95%;
    max-width: none;
    background: rgba(255, 255, 255, 0.85);
  }

  .login-content {
    padding: 30px 20px;
  }

  .login-title {
    font-size: 24px;
  }
}
/* 1. 标题样式：放在左侧 1/3，但位置偏上 */
.system-title {
  position: absolute;
  top: 20%;         /* 关键：距离顶部 15%，使其处于上方 */
  left: 36%;     /* 锚定在左侧 1/3 */
  transform: translateX(-50%); /* 仅水平偏移，保持 top 定位有效 */
  
  color: #005EEB;   /* 蓝色字体 */
  font-size: 2.8rem; /* 根据需要调整 H1 大小 */
  font-weight: bold;
  white-space: nowrap;
  letter-spacing: 2px;
  
  animation: fadeInDown 1s ease-out forwards;
  z-index: 10;
}


/* 3. 标题专用的从上往下掉的动画 */
@keyframes fadeInDown {
  from { 
    opacity: 0; 
    transform: translate(-50%, -20px); 
  }
  to { 
    opacity: 1; 
    transform: translate(-50%, 0); 
  }
}

/* 4. 响应式适配 */
@media (max-width: 768px) {
  .system-title {
    top: 8%;         /* 手机端再往上提一点 */
    left: 50%;
    font-size: 1.8rem;
  }
  
}
</style>
