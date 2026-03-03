<template>
  <div class="main">
    <div
      class="left"
      :style="{
        width: isCollapse ? '64px' : '200px',
        background: themeColor.bg,
        color: themeColor.color,
      }"
      style="transition: 0.3s"
    >
      <div class="logo" @click="$router.push('/home/')" style="cursor: pointer">
        <img
          :src="
            isCollapse
              ? require('@/assets/img/ItHelp2.png')
              : require('@/assets/img/ItHelp.png')
          "
          :class="isCollapse ? 'logo-icon' : 'logo-full'"
          alt="logo"
        />
      </div>
      <el-menu
        :collapse-transition="false"
        :collapse="isCollapse"
        :router="true"
        :default-active="activeMenu"
        :background-color="themeColor.bg"
        :text-color="themeColor.color"
        :unique-opened="true"
      >
        <el-menu-item index="/home/">
          <i class="el-icon-s-home"></i>
          <span style="font-size: 20px">首页</span>
        </el-menu-item>

        <el-menu-item index="/home/forum">
          <i class="el-icon-s-comment"></i>
          <span style="font-size: 20px">校园圈子</span>
        </el-menu-item>

        <el-menu-item index="/home/help">
          <i class="el-icon-s-cooperation"></i>
          <span style="font-size: 20px">求助中心</span>
        </el-menu-item>

        <el-menu-item index="/home/ai">
          <i class="el-icon-magic-stick"></i>
          <span style="font-size: 20px">智能助手</span>
        </el-menu-item>

        <el-menu-item index="/home/remark">
          <i class="el-icon-s-custom"></i>
          <span style="font-size: 20px">评价中心</span>
        </el-menu-item>

        <el-menu-item index="/home/chat">
          <i class="el-icon-chat-dot-round"></i>
          <span style="font-size: 20px">消息列表</span>
        </el-menu-item>

        <el-menu-item index="/home/noticeu">
          <i class="el-icon-paperclip"></i>
          <span style="font-size: 20px">查看公告</span>
        </el-menu-item>

        <el-menu-item index="/home/MyProfile">
          <i class="el-icon-user"></i>
          <span style="font-size: 20px">个人信息</span>
        </el-menu-item>

        <el-menu-item index="logout" @click="exit">
          <i class="el-icon-switch-button"></i>
          <span style="font-size: 20px">退出登录</span>
        </el-menu-item>
      </el-menu>
    </div>

    <div
      class="right"
      :style="{
        width: isCollapse ? windowWidth - 64 + 'px' : windowWidth - 200 + 'px',
        left: isCollapse ? '64px' : '200px',
      }"
    >
      <div
        class="top"
        :style="{
          width: isCollapse
            ? windowWidth - 64 + 'px'
            : windowWidth - 200 + 'px',
          left: isCollapse ? '64px' : '200px',
          background: themeColor.bg,
        }"
      >
        <div style="display: flex; align-items: center">
          <div class="icon" @click="isCollapse = !isCollapse">
            <i
              :class="isCollapse ? 'el-icon-s-unfold' : 'el-icon-s-fold'"
              :style="{ color: themeColor.color }"
            ></i>
          </div>

          <el-breadcrumb
            separator-class="el-icon-arrow-right"
            style="margin-left: 20px"
          >
            <el-breadcrumb-item
              v-for="(item, index) in breadList"
              :key="index"
              :to="item.path"
              v-if="item.meta.title"
            >
              {{ item.meta.title }}
            </el-breadcrumb-item>
          </el-breadcrumb>
        </div>

        <div class="user-area" style="display: flex; align-items: center">
          <div class="points-wrapper" @click="getPointsByAd">
            <el-tooltip content="点击看广告获取10积分" placement="bottom">
              <div class="points-content">
                <i class="el-icon-coin"></i>
                <span class="points-value">{{ user.balance || 0 }}</span>
              </div>
            </el-tooltip>
          </div>

          <el-dropdown trigger="click" @command="handleCommand">
            <div
              style="
                display: flex;
                align-items: center;
                cursor: pointer;
                height: 60px;
              "
            >
              <span
                :style="{
                  color: themeColor.color,
                  marginRight: '8px',
                  fontSize: '14px',
                }"
              >
                {{ user.username }}
              </span>

              <el-avatar
                style="background: #65c4a6; user-select: none"
                :size="35"
                :src="fullAvatarUrl"
              >
                {{ firstName }}
              </el-avatar>

              <i
                class="el-icon-arrow-down el-icon--right"
                :style="{ color: themeColor.color }"
              ></i>
            </div>

            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="exit">退出登录</el-dropdown-item>
              <el-dropdown-item command="password">修改密码</el-dropdown-item>
              <el-dropdown-item command="info">修改个人信息</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </div>

      <div class="bottom">
        <div class="content-box">
          <transition name="el-fade-in" mode="out-in">
            <router-view
              @personalInformation="personalInformation"
            ></router-view>
          </transition>
        </div>
      </div>
    </div>

    <el-drawer
      title="完善信息"
      :visible.sync="drawer"
      direction="rtl"
      :show-close="false"
      :before-close="handleClose"
    >
      <el-form
        :model="ruleForm"
        status-icon
        :rules="rules"
        ref="ruleForm"
        label-width="100px"
        class="demo-ruleForm ruleform"
      >
        <el-form-item label="班级">
          <el-cascader
            v-model="value"
            :options="school.depts"
            :props="{
              children: 'classes',
              label: 'name',
              value: 'id',
            }"
          ></el-cascader>
        </el-form-item>
        <el-form-item label="姓名" prop="username">
          <el-input v-model="ruleForm.username"></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model.number="ruleForm.phone"></el-input>
        </el-form-item>

        <el-form-item label="性别">
          <el-radio-group v-model="sex">
            <el-radio label="0">男</el-radio>
            <el-radio label="1">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="submitForm('ruleForm')"
            >提交</el-button
          >
        </el-form-item>
      </el-form>
    </el-drawer>

    <el-dialog
      title="修改个人资料"
      :visible.sync="dialogVisible"
      :close-on-click-modal="false"
      width="450px"
    >
      <el-form
        :model="ruleForm"
        :rules="rules"
        ref="ruleForm"
        label-width="80px"
      >
        <el-form-item label="姓名" prop="username">
          <el-input
            v-model="ruleForm.username"
            placeholder="请输入姓名"
          ></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input
            v-model.number="ruleForm.phone"
            oninput="if(value.length>11)value=value.slice(0,11)"
            placeholder="请输入手机号"
          ></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input
            v-model="ruleForm.email"
            placeholder="请输入电子邮箱"
          ></el-input>
        </el-form-item>
        <el-form-item label="简介" prop="signature">
          <el-input
            type="textarea"
            :rows="3"
            v-model="ruleForm.signature"
            placeholder="写点什么介绍一下自己吧..."
            maxlength="100"
            show-word-limit
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitChanges">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";

export default {
  name: "Home",
  methods: {
    ...mapMutations("user", ["setUser"]),
    changeColor(val) {
      sessionStorage.setItem("themeColor", JSON.stringify(val));
      this.themeColor = { bg: val.value, color: val.color };
    },
    // 面包屑
    getBreadcrumb() {
      let matched = this.$route.matched;
      if (matched[0].name != "home") {
        matched = [{ path: "/home/", meta: { title: "首页" } }].concat(matched);
      }
      this.breadList = matched;
    },
    // 关闭抽屉触发的事件
    handleClose(done) {
      this.$msg("请完善资料", "error");
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          if (this.value) {
            this.$put("/user", {
              id: this.user.id,
              deptId: this.value[0],
              classId: this.value[1],
              username: this.ruleForm.username,
              phone: this.ruleForm.phone,
              sex: this.sex,
            }).then((res) => {
              this.drawer = false;
              this.$notifyMsg("成功", res.data.msg, "success");
              this.newList(this.user.id);
            });
          } else {
            this.$notifyMsg("错误", "请选择班级", "error");
          }
        } else {
          return false;
        }
      });
    },
    // 处理下拉菜单点击
    handleCommand(command) {
      if (command === "exit") {
        this.exit();
      } else if (command === "password") {
        this.updPassword(this.user.id);
      } else if (command === "info") {
        this.personalInformation();
      }
    },
    // 修改密码
    updPassword(id) {
      this.$prompt("请输入密码", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        inputType: "password",
        closeOnClickModal: false,
        inputPattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$/,
        inputErrorMessage: "格式不对,密码只能输入6-16位英文和数字",
      })
        .then((res) => {
          this.$put("/user", { id: id, password: res.value }).then((res) => {
            this.$notifyMsg("成功", res.data.msg, "success");
          });
        })
        .catch(() => {});
    },
    personalInformation() {
      this.dialogVisible = true;
      // 🟢 关键：把当前登录用户的 ID 存入表单对象中
      this.ruleForm.id = this.user.id;
      this.ruleForm.username = this.user.username;
      this.ruleForm.phone = this.user.phone;
      this.ruleForm.email = this.user.email;
      this.ruleForm.signature = this.user.signature;
    },
    submitChanges() {
      this.$refs["ruleForm"].validate((valid) => {
        if (valid) {
          // 1. 确保能拿到 ID
          const userId =
            this.user.id ||
            (localStorage.getItem("user")
              ? JSON.parse(localStorage.getItem("user")).id
              : null);

          if (!userId) {
            this.$message.error("用户信息失效，请重新登录");
            return;
          }

          // 2. 构造普通的 JS 对象（$put 会自动把它转为后端需要的 JSON 字符串）
          const updateData = {
            id: userId,
            username: this.ruleForm.username,
            phone: this.ruleForm.phone,
            email: this.ruleForm.email,
            signature: this.ruleForm.signature,
          };

          console.log("正在提交 JSON 数据:", updateData);

          // 3. 注意：这里直接传 updateData 对象
          this.$put("/user", updateData)
            .then((res) => {
              // 这里的 res 判断取决于你 myPlugin.js 或 axios 的封装
              // 通常是 res.data，如果你的插件剥离了 data 层，就直接用 res
              const result = res.data || res;

              if (result.status === true || result.code === 200) {
                this.$notifyMsg("成功", "资料更新成功", "success", 1000);
                this.dialogVisible = false;
                this.newList(userId); // 刷新 Vuex 状态
              } else {
                this.$message.error(result.msg || "更新失败");
              }
            })
            .catch((err) => {
              console.error("请求失败详情:", err);
              this.$message.error("网络请求失败，请检查网络或后端");
            });
        }
      });
    },
    // 🟢 新增：模拟看广告获取积分
    getPointsByAd() {
      this.$confirm(
        "观看一段 60 秒的广告即可获得 10 积分，是否开始？",
        "赚取积分",
        {
          confirmButtonText: "立即开始",
          cancelButtonText: "取消",
          type: "info",
        }
      )
        .then(() => {
          // 模拟广告播放的 loading
          const loading = this.$loading({
            lock: true,
            text: "广告播放中，请勿关闭...",
            spinner: "el-icon-video-camera",
            background: "rgba(0, 0, 0, 0.7)",
          });

          // 模拟 2秒后增加积分（实际项目中这里应该调用后端接口）
          setTimeout(() => {
            const newBalance = (this.user.balance || 0) + 10;

            // 发送请求给后端更新数据库
            this.$put("/user", {
              id: this.user.id,
              balance: newBalance,
            })
              .then((res) => {
                loading.close();
                this.$message.success("广告播放完毕，10积分已到账！");
                // 刷新本地用户信息
                this.newList(this.user.id);
              })
              .catch(() => {
                loading.close();
                this.$message.error("积分同步失败");
              });
          }, 2000);
        })
        .catch(() => {});
    },
    // 根据当前用户查询id
    newList(id) {
      this.$get("/user/" + id).then((rs) => {
        // 同步更新 session 和 local，确保下次刷新不出错
        sessionStorage.setItem("user", JSON.stringify(rs.data.user));
        localStorage.setItem("user", JSON.stringify(rs.data.user));

        this.setUser(rs.data.user);

        // 修改完名字, 清空当前firstName; 避免出现叠加
        this.firstName = "";
        this.textAvatar(rs.data.user.username);
      });
    },
    exit() {
      // ============================================================
      // 🟢 新增逻辑：退出时清除当前用户的 AI 聊天记录
      // 注意：key 必须和 AiHelp.vue 里的 cacheKey 生成规则保持一致
      // ============================================================
      if (this.user && this.user.id) {
        localStorage.removeItem("ai_chat_history_" + this.user.id);
      } else {
        //以此防万一：如果 this.user 为空，尝试从缓存里读一下 ID 再删
        try {
          const cachedUser = JSON.parse(
            sessionStorage.getItem("user") || localStorage.getItem("user")
          );
          if (cachedUser && cachedUser.id) {
            localStorage.removeItem("ai_chat_history_" + cachedUser.id);
          }
        } catch (e) {}
      }

      // ============================================================
      // 原有逻辑
      // ============================================================
      sessionStorage.removeItem("user");
      localStorage.removeItem("user"); // 登出也顺便清一下local
      this.$router.push("/");
    },
    // 文字头像
    textAvatar(username) {
      if (!username) return;
      let arr = username.split(" ");
      this.firstName = ""; // 确保先清空
      for (var i in arr) {
        this.firstName += arr[i].substr(0, 1);
      }
      this.firstName = this.firstName.toLocaleUpperCase();
      console.log("firstName->" + this.firstName);
    },
  },
  computed: {
    ...mapState("user", ["user"]),

    // ==========================================
    // 🟢 新增：处理头像的完整路径
    // ==========================================
    fullAvatarUrl() {
      if (!this.user || !this.user.avatar) return "";
      // 如果已经是 http 开头，直接用
      if (this.user.avatar.startsWith("http")) return this.user.avatar;
      // 否则拼接后端地址 (假设你的后端端口是 8080)
      return `http://localhost:8080${this.user.avatar}`;
    },

    theme() {
      return this.$store.state.theme.theme;
    },
    activeMenu() {
      const path = this.$route.path;
      if (path.startsWith("/home/forum")) {
        return "/home/forum";
      }
      if (path.startsWith("/home/help")) {
        return "/home/help";
      }
      if (path.startsWith("/home/remark")) {
        return "/home/remark";
      }
      if (path === "/home" || path === "/home/") {
        return "/home/";
      }
      return path;
    },
  },
  data() {
    var validateUsername = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("请输入姓名"));
      } else {
        callback();
      }
    };
    var validatePhone = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("请输入手机号"));
      } else {
        callback();
      }
    };

    return {
      firstName: "",
      ruleForm: {
        id: null, // 🟢 必须添加这个，用来存储当前用户的ID
        username: "",
        phone: "",
        email: "",
        signature: "",
      },
      rules: {
        username: [{ required: true, message: "请输入姓名", trigger: "blur" }],
        phone: [{ required: true, message: "请输入手机号", trigger: "blur" }],
        // 🟢 新增：邮箱简单校验
        email: [
          {
            type: "email",
            message: "请输入正确的邮箱地址",
            trigger: ["blur", "change"],
          },
        ],
        signature: [
          { max: 100, message: "简介不能超过100个字符", trigger: "blur" },
        ],
      },
      themeColor: { bg: "#E0E8FB", color: "#000" },
      sex: "0",
      drawer: false,
      breadList: [],
      windowWidth: document.documentElement.clientWidth,
      // isCollapse: false,
      isCollapse: false,
      school: [],
      value: "",
      dialogVisible: false,
    };
  },
  watch: {
    $route(to, from) {
      // 1. 原有的面包屑逻辑保留
      this.getBreadcrumb();

      // =======================================================
      // 🟢 新增：切换路由时，强制滚动到顶部
      // =======================================================

      // 情况A：如果你是整个浏览器窗口滚动
      window.scrollTo(0, 0);
      document.body.scrollTop = 0;
      document.documentElement.scrollTop = 0;

      // 情况B：如果你的滚动条是在 .right 这个区域内部生成的（局部滚动）
      // 很多后台管理系统是固定侧边栏，只有右侧区域滚动
      this.$nextTick(() => {
        const rightPanel = document.querySelector(".right");
        if (rightPanel) {
          rightPanel.scrollTop = 0;
        }

        // 或者是 .bottom 区域
        const bottomPanel = document.querySelector(".bottom");
        if (bottomPanel) {
          bottomPanel.scrollTop = 0;
        }
      });
    },
    // 监听 user 变化，重新计算文字头像 (防止只显示图不显示字)
    user: {
      handler(val) {
        if (val && val.username) {
          this.textAvatar(val.username);
        }
      },
      deep: true,
    },
  },
  created() {
    let theme = JSON.parse(sessionStorage.getItem("themeColor"));
    if (theme) {
      this.themeColor = { bg: theme.value, color: theme.color };
    }

    // ===============================================
    // 🟢 修改：优先读取 LocalStorage (之前修复缓存的地方)
    // 防止 session 里是旧的，而 local 里是新的
    // ===============================================
    let storedUserStr = sessionStorage.getItem("user");
    if (!storedUserStr) {
      // 如果 session 没有，尝试找 local
      storedUserStr = localStorage.getItem("user");
    } else {
      // 如果 session 有，为了保险起见，看看 local 是不是更新
      const localUserStr = localStorage.getItem("user");
      if (localUserStr) {
        // 这里简单粗暴一点，如果 local 存在，我们信任 local 是最新的
        // (因为你在 MyProfile 里修改头像时是更新的 local)
        storedUserStr = localUserStr;
      }
    }

    if (storedUserStr) {
      this.getBreadcrumb();
      const userObj = JSON.parse(storedUserStr);
      this.setUser(userObj);

      // 如果发现 session 里没存，顺便存一下
      if (!sessionStorage.getItem("user")) {
        sessionStorage.setItem("user", storedUserStr);
      }

      if (!this.user.dept) {
        this.$get("/school/" + this.user.school.id).then((res) => {
          this.school = res.data.school;
          this.drawer = true;
          this.$msg("请完善信息", "warning");
        });
      }
    } else {
      this.$msg("您尚未登陆,没有权限", "error");
      this.$router.push("/");
    }
  },
  mounted() {
    window.onresize = () => {
      this.windowWidth = document.documentElement.clientWidth;
    };
    if (this.user && this.user.username) {
      this.textAvatar(this.user.username);
    }
  },
};
</script>

<style scoped lang="less">
/* 这里样式保持不变，我就不重复贴太长的样式代码了，直接使用你原本的样式即可 */
/* 定义深蓝色变量，方便调整 */
@deep-blue: #165dff;
/* 未选中时的标签底色 */
@item-bg-normal: #e8eefa;

.main {
  display: flex;
  height: 100%;

  .left {
    position: fixed;
    height: 100%;
    /* 强制覆盖内联样式，确保背景色正确 */
    background-color: #e0e8fb !important;
    box-shadow: 2px 0 6px rgba(0, 21, 41, 0.05);

    .logo {
      width: 100%;
      padding: 10px 0;
      display: flex;
      justify-content: center;
      align-items: center;

      /* 展开时：完整Logo样式 */
      .logo-full {
        width: 90%;
        height: 40px;
        object-fit: contain;
        transition: all 0.3s;
        animation: fadeIn 0.5s;
      }

      /* 收起时：小图标样式 */
      .logo-icon {
        width: 32px;
        height: 32px;
        object-fit: contain;
        transition: all 0.3s;
        animation: fadeIn 0.5s;
      }
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
      }
      to {
        opacity: 1;
      }
    }

    /* --- 核心修改：穿透修改 Element UI 菜单样式 --- */
    /deep/ .el-menu {
      border-right: none;
      background-color: transparent !important;
    }

    /deep/ .el-menu-item {
      display: flex;
      align-items: center;
      margin: 8px 10px;
      height: 50px;
      line-height: 50px;
      border-radius: 6px;
      background-color: @item-bg-normal !important;
      color: #333 !important;
      border: 1px solid transparent;
      transition: all 0.3s;

      i {
        color: #606266;
      }

      &:hover {
        background-color: #fff !important;
        color: @deep-blue !important;
        border-color: @deep-blue !important;

        i {
          color: @deep-blue !important;
        }
      }
    }

    /deep/ .el-menu-item.is-active {
      background-color: #fff !important;
      color: @deep-blue !important;
      border: 1px solid @deep-blue !important;
      font-weight: bold;

      i {
        color: @deep-blue !important;
      }
    }

    /* 修复折叠状态下图标不居中的问题 */
    /deep/ .el-menu--collapse .el-menu-item {
      padding: 0 !important;
      justify-content: center;
      margin: 8px 4px;

      i {
        margin: 0 !important;
      }

      span {
        display: none;
        width: 0;
        height: 0;
        overflow: hidden;
      }

      & > div {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
      }
    }
  }

  .right {
    transition: all 0.3s ease 0s;
    position: relative;
    background-color: #f2f3f5;

    .top {
      transition: all 0.3s ease 0s;
      position: fixed;
      display: flex;
      align-items: center;
      justify-content: space-between;
      z-index: 9;
      box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
      background-color: #fff !important;

      /* 这里添加了右内边距，防止头像贴边 */
      padding-right: 20px;

      .icon {
        font-size: 20px;
        cursor: pointer;
        margin-left: 20px;
        color: #333 !important;
      }
    }

    .bottom {
      width: 100%;
      height: calc(100vh - 65px);
      margin-top: 65px;
      padding: 20px;
      box-sizing: border-box;
      overflow-y: auto;

      .content-box {
        background: transparent;
        padding: 0;
        min-height: calc(100% - 40px);
      }
    }
  }

  .ruleform /deep/ .el-input {
    width: 80% !important;
  }

  /deep/ .el-cascader {
    width: 100% !important;
  }
}
.points-wrapper {
  /* 🟢 这里控制距离名字的距离：8px 到 15px 之间比较合适 */
  margin-right: 12px;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: scale(1.05);
    .points-content {
      background-color: #fff2af;
      border-color: #ffb700;
    }
  }

  .points-content {
    display: flex;
    align-items: center;
    background-color: #fff9db;
    /* 缩小内边距让它看起来更精致，不占用太大空间 */
    padding: 2px 10px;
    border-radius: 15px;
    border: 1px solid #ffe066;
    color: #e67e22;
    font-weight: 600;
    white-space: nowrap; // 防止换行

    i {
      font-size: 16px;
      margin-right: 4px;
    }

    .points-value {
      font-size: 13px;
    }
  }
}
.user-area {
  display: flex;
  align-items: center;
  /* 确保整体靠右 */
  margin-left: auto;
}
</style>
