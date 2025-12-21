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

        <div class="user-area">
          <div class="points-wrapper" @click="getPointsByAd">
            <el-tooltip content="点击看广告获取10积分" placement="bottom">
              <div class="points-content">
                <i class="el-icon-coin"></i>
                <span class="points-value">{{ user.balance || 0 }}</span>
              </div>
            </el-tooltip>
          </div>

          <el-dropdown trigger="click" @command="handleCommand">
            <div class="user-info-trigger">
              <span :style="{ color: themeColor.color }" class="username-text">
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
            :props="{ children: 'classes', label: 'name', value: 'id' }"
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
  data() {
    return {
      firstName: "",
      ruleForm: {
        id: null,
        username: "",
        phone: "",
        email: "",
        signature: "",
      },
      rules: {
        username: [{ required: true, message: "请输入姓名", trigger: "blur" }],
        phone: [{ required: true, message: "请输入手机号", trigger: "blur" }],
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
      isCollapse: false,
      school: [],
      value: "",
      dialogVisible: false,
    };
  },
  methods: {
    ...mapMutations("user", ["setUser"]),
    getBreadcrumb() {
      let matched = this.$route.matched;
      if (matched.length && matched[0].name != "home") {
        matched = [{ path: "/home/", meta: { title: "首页" } }].concat(matched);
      }
      this.breadList = matched;
    },
    handleClose(done) {
      this.$msg("请完善资料", "error");
    },
    getPointsByAd() {
      this.$confirm(
        "观看一段模拟广告即可获得 10 积分，是否开始？",
        "赚取积分",
        {
          confirmButtonText: "开始",
          cancelButtonText: "取消",
          type: "info",
        }
      )
        .then(() => {
          const loading = this.$loading({
            lock: true,
            text: "广告正在加载并播放...",
            spinner: "el-icon-video-camera",
            background: "rgba(0, 0, 0, 0.7)",
          });
          setTimeout(() => {
            const newBalance = (this.user.balance || 0) + 10;
            this.$put("/user", { id: this.user.id, balance: newBalance })
              .then((res) => {
                loading.close();
                this.$message.success("恭喜获得10积分！");
                this.newList(this.user.id);
              })
              .catch(() => {
                loading.close();
                this.$message.error("积分领取失败");
              });
          }, 2000);
        })
        .catch(() => {});
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid && this.value) {
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
        } else if (!this.value) {
          this.$notifyMsg("错误", "请选择班级", "error");
        }
      });
    },
    handleCommand(command) {
      if (command === "exit") this.exit();
      else if (command === "password") this.updPassword(this.user.id);
      else if (command === "info") this.personalInformation();
    },
    updPassword(id) {
      this.$prompt("请输入密码", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        inputType: "password",
        inputPattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$/,
        inputErrorMessage: "密码需6-16位字母和数字",
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
      this.ruleForm.id = this.user.id;
      this.ruleForm.username = this.user.username;
      this.ruleForm.phone = this.user.phone;
      this.ruleForm.email = this.user.email;
      this.ruleForm.signature = this.user.signature;
    },
    submitChanges() {
      this.$refs["ruleForm"].validate((valid) => {
        if (valid) {
          const updateData = { ...this.ruleForm, id: this.user.id };
          this.$put("/user", updateData).then((res) => {
            const result = res.data || res;
            if (result.status === true || result.code === 200) {
              this.$notifyMsg("成功", "资料更新成功", "success", 1000);
              this.dialogVisible = false;
              this.newList(this.user.id);
            }
          });
        }
      });
    },
    newList(id) {
      this.$get("/user/" + id).then((rs) => {
        const userData = rs.data.user;
        sessionStorage.setItem("user", JSON.stringify(userData));
        localStorage.setItem("user", JSON.stringify(userData));
        this.setUser(userData);
        this.firstName = "";
        this.textAvatar(userData.username);
      });
    },
    exit() {
      if (this.user?.id)
        localStorage.removeItem("ai_chat_history_" + this.user.id);
      sessionStorage.removeItem("user");
      localStorage.removeItem("user");
      this.$router.push("/");
    },
    textAvatar(username) {
      if (!username) return;
      let arr = username.split(" ");
      let temp = "";
      for (let i in arr) temp += arr[i].substr(0, 1);
      this.firstName = temp.toUpperCase();
    },
  },
  computed: {
    ...mapState("user", ["user"]),
    fullAvatarUrl() {
      if (!this.user?.avatar) return "";
      return this.user.avatar.startsWith("http")
        ? this.user.avatar
        : `http://localhost:8080${this.user.avatar}`;
    },
    activeMenu() {
      const path = this.$route.path;
      if (path.startsWith("/home/forum")) return "/home/forum";
      if (path.startsWith("/home/help")) return "/home/help";
      if (path.startsWith("/home/remark")) return "/home/remark";
      return path === "/home" || path === "/home/" ? "/home/" : path;
    },
  },
  watch: {
    $route() {
      this.getBreadcrumb();
    },
    user: {
      handler(val) {
        if (val?.username) this.textAvatar(val.username);
      },
      deep: true,
    },
  },
  created() {
    let theme = JSON.parse(sessionStorage.getItem("themeColor"));
    if (theme) this.themeColor = { bg: theme.value, color: theme.color };

    let storedUserStr =
      sessionStorage.getItem("user") || localStorage.getItem("user");
    if (storedUserStr) {
      this.getBreadcrumb();
      const userObj = JSON.parse(storedUserStr);
      this.setUser(userObj);
      if (!this.user.dept) {
        this.$get("/school/" + this.user.school.id).then((res) => {
          this.school = res.data.school;
          this.drawer = true;
        });
      }
    } else {
      this.$router.push("/");
    }
  },
  mounted() {
    window.onresize = () => {
      this.windowWidth = document.documentElement.clientWidth;
    };
    if (this.user?.username) this.textAvatar(this.user.username);
  },
};
</script>

<style scoped lang="less">
@deep-blue: #165dff;
@item-bg-normal: #e8eefa;

.main {
  display: flex;
  height: 100%;

  .left {
    position: fixed;
    height: 100%;
    background-color: #e0e8fb !important;
    box-shadow: 2px 0 6px rgba(0, 21, 41, 0.05);
    z-index: 10;
    .logo {
      width: 100%;
      padding: 10px 0;
      display: flex;
      justify-content: center;
      align-items: center;
      .logo-full {
        width: 90%;
        height: 40px;
        object-fit: contain;
      }
      .logo-icon {
        width: 32px;
        height: 32px;
        object-fit: contain;
      }
    }
    /deep/ .el-menu {
      border-right: none;
      background-color: transparent !important;
    }
    /deep/ .el-menu-item {
      display: flex;
      align-items: center;
      margin: 8px 10px;
      height: 50px;
      border-radius: 6px;
      background-color: @item-bg-normal !important;
      color: #333 !important;
      &:hover,
      &.is-active {
        background-color: #fff !important;
        color: @deep-blue !important;
        border: 1px solid @deep-blue;
        i {
          color: @deep-blue !important;
        }
      }
    }
  }

  .right {
    transition: all 0.3s;
    position: relative;
    background-color: #f2f3f5;
    .top {
      position: fixed;
      display: flex;
      align-items: center;
      justify-content: space-between;
      height: 60px;
      z-index: 9;
      box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
      background-color: #fff !important;
      padding: 0 20px;

      .user-area {
        display: flex;
        align-items: center;
        margin-left: auto; /* 核心：整体靠右 */

        .points-wrapper {
          margin-right: 15px;
          cursor: pointer;
          transition: all 0.3s;
          &:hover {
            transform: scale(1.05);
          }
          .points-content {
            display: flex;
            align-items: center;
            background-color: #fff9db;
            padding: 4px 12px;
            border-radius: 20px;
            border: 1px solid #ffe066;
            color: #e67e22;
            font-weight: bold;
            i {
              font-size: 16px;
              margin-right: 4px;
            }
            .points-value {
              font-size: 14px;
            }
          }
        }

        .user-info-trigger {
          display: flex;
          align-items: center;
          cursor: pointer;
          height: 60px;
          .username-text {
            margin-right: 8px;
            font-size: 14px;
          }
        }
      }

      .icon {
        font-size: 20px;
        cursor: pointer;
        margin-right: 20px;
      }
    }
    .bottom {
      margin-top: 65px;
      padding: 0 10px;
      box-sizing: border-box;
      .content-box {
        min-height: 80vh;
      }
    }
  }
}

/deep/ .el-cascader {
  width: 100% !important;
}
.ruleform /deep/ .el-input {
  width: 80% !important;
}
</style>
