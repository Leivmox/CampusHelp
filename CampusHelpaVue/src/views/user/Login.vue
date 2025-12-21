<template>
  <div class="login-container">
    <h1 class="system-title">校园IT互助系统</h1>
    <el-card class="login-card">
      <div v-show="!isShow" class="login-form">
        <h2>用户登录</h2>
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
          >登录</el-button
        >

        <div class="auth-actions">
          <router-link to="/admin" class="action-link">管理员入口</router-link>
        </div>
      </div>

      <div v-show="isShow" class="register-form">
        <h2>立即注册</h2>
        <label>
          <!-- <span>学号</span> -->
          <el-input
            prefix-icon="el-icon-user"
            v-model="studentId"
            placeholder="请输入学号"
            maxlength="11"
            oninput="value=value.replace(/[^\d]/g,'')"
          ></el-input>
        </label>

        <label>
          <!-- <span>密码</span> -->
          <el-input
            prefix-icon="el-icon-lock"
            v-model="password"
            placeholder="请输入密码"
            show-password
          ></el-input>
        </label>

        <label>
          <!-- <span>选择学校</span> -->
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

        <el-button type="primary" class="login-btn" @click="toLogin('register')"
          >注册</el-button
        >
      </div>

      <div class="switch-btn" @click="isShow = !isShow">
        {{ isShow ? "已有账号？登录" : "还未注册？注册" }}
      </div>
    </el-card>
  </div>
</template>

<script>
import { setCookie, getCookie } from "@/util/util";
import md5 from "js-md5";

export default {
  name: "Login",
  data() {
    return {
      isShow: false,
      loading: false,
      studentId: "",
      password: "",
      school: [],
      schoolId: "",
    };
  },
  created() {
    this.$get("/school").then((res) => {
      this.school = res.data.school;
    });
  },
  methods: {
    toLogin(val) {
      if (this.studentId && this.password && this.schoolId) {
        this.loading = true;

        // 登录
        if (val === "sign") {
          this.$get("/user/login", {
            studentId: this.studentId,
            password: md5(this.password),
            schoolId: this.schoolId,
          })
            .then((res) => {
              this.loading = false;
              if (res.data.status) {
                if (res.data.user.state == 0) {
                  sessionStorage.setItem("user", JSON.stringify(res.data.user));
                  this.$msg(
                    `${
                      res.data.user.username || res.data.user.studentId
                    }，登录成功`,
                    "success"
                  );
                  this.$router.push("/home");
                } else {
                  this.$msg("该用户已被冻结，请联系管理员", "error");
                }
              } else {
                this.$msg(res.data.msg, "error");
              }
            })
            .catch(() => (this.loading = false));
        }
        // 注册
        else {
          this.$post("/user", {
            studentId: this.studentId,
            password: md5(this.password),
            schoolId: this.schoolId,
          })
            .then((res) => {
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
            })
            .catch(() => (this.loading = false));
        }
      } else {
        this.$msg("请填写正确的信息", "error");
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
.login-container {
  /* 修改1：容器改为相对定位，作为坐标参考系 */
  position: relative;
  width: 100%;
  height: 100vh;

  /* 背景保持不变 */
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  background-size: cover;
  background-image: url("../../assets/img/bg3.jpg");
  overflow: hidden; /* 防止某些极端情况出现滚动条 */
}

.login-card {
  /* 修改2：使用绝对定位，精准锚定位置 */
  position: absolute;
  top: 55%; /* 垂直居中 */
  left: 66.66%; /* 水平锚点设在 2/3 处 (约等于66.66%) */

  /* 修改3：利用 translate 将自身的中心点对齐到锚点 
     (-50%, -50%) 代表向左移自身宽的一半，向上移自身高的一半
  */
  transform: translate(-50%, -50%);

  width: 90%;
  max-width: 420px;
  border-radius: 16px;
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);

  /* 磨砂玻璃效果保持不变 */
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3);

  /* 动画应用 */
  animation: fadeIn 0.8s ease-out forwards;
}

/* 修改4：重写动画 
   注意：必须保留 translate(-50%, -50%)，否则动画结束后位置会跑偏
*/
@keyframes fadeIn {
  from {
    opacity: 0;
    /* 从稍微靠下一点的地方浮上来 (Y轴 -40% -> -50%) */
    transform: translate(-50%, -40%);
  }
  to {
    opacity: 1;
    /* 最终状态必须回到精准居中位置 */
    transform: translate(-50%, -50%);
  }
}

.login-form,
.register-form {
  padding: 30px;
}

h2 {
  text-align: center;
  margin-bottom: 25px;
  color: #005eeb;
  font-size: 28px;
}

.el-input,
.el-select {
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
  border-radius: 30px;
  background: linear-gradient(to right, #8da7e3, #6192f5);
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
  border-top: 1px solid rgba(0, 0, 0, 0.05);
}

/* 响应式适配 */
@media (max-width: 768px) {
  .login-card {
    /* 修改5：手机端强制回到正中间 
       将 left 改回 50% 即可
    */
    left: 50%;
    width: 95%;
    max-width: none;
    background: rgba(255, 255, 255, 0.85);
  }

  .login-form,
  .register-form {
    padding: 20px;
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
