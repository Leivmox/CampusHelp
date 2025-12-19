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
      <div class="logo">
        <span style="font-size: 22px">校园IT互助系统</span>
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

        <el-menu
          :unique-opened="true"
          :default-active="activeIndex"
          class="el-menu-demo"
          mode="horizontal"
          :background-color="themeColor.bg"
          :text-color="themeColor.color"
          :active-text-color="themeColor.color"
          menu-trigger="click"
        >
          <el-submenu index="2">
            <template slot="title">
              <span style="margin-right: 8px; font-size: 14px">
                {{ user.username }}
              </span>
              <el-avatar
                style="background: #65c4a6; user-select: none"
                size="small"
              >
                {{ firstName }}
              </el-avatar>
            </template>
            <el-menu-item index="2-1" @click="exit">退出</el-menu-item>
            <el-menu-item index="2-2" @click="updPassword(user.id)"
              >修改密码</el-menu-item
            >
            <el-menu-item index="2-3" @click="personalInformation()"
              >修改个人信息</el-menu-item
            >
          </el-submenu>
        </el-menu>
      </div>

      <div class="bottom">
        <div class="content-box">
          <transition name="el-fade-in" mode="out-in">
            <router-view
              @personalInformation="personalInformation"
            ></router-view>
          </transition>
        </div>
      </div> </div> <el-drawer
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
      title="修改信息"
      :visible.sync="dialogVisible"
      :close-on-click-modal="false"
    >
      <el-form :model="ruleForm" :rules="rules" ref="ruleForm">
        <el-form-item label="姓名" prop="username">
          <el-input v-model.number="ruleForm.username"></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input
            v-model.number="ruleForm.phone"
            oninput="if(value.length>11)value=value.slice(0,11)"
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitChanges">确 定</el-button>
      </div>
    </el-dialog>
  </div> </template>

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
      this.ruleForm.username = this.user.username;
      this.ruleForm.phone = this.user.phone;
    },
    submitChanges() {
      this.$put("/user", {
        id: this.user.id,
        username: this.ruleForm.username,
        phone: this.ruleForm.phone,
      }).then((res) => {
        this.$notifyMsg("成功", res.data.msg, "success", 1000);
        this.dialogVisible = false;
        this.newList(this.user.id);
      });
    },
    // 根据当前用户查询id
    newList(id) {
      this.$get("/user/" + id).then((rs) => {
        sessionStorage.setItem("user", JSON.stringify(rs.data.user));
        this.setUser(JSON.parse(sessionStorage.getItem("user")));
        // 修改完名字, 清空当前firstName; 避免出现叠加
        this.firstName = "";
        this.textAvatar(rs.data.user.username);
      });
    },
    exit() {
      sessionStorage.removeItem("user");
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
    theme() {
      return this.$store.state.theme.theme;
    },
    // 计算属性：处理菜单高亮逻辑
    // 当我们在 /home/help/task, /home/help/accept 等子路径时，让左侧"求助中心"保持高亮
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
      // 文字头像
      firstName: "",
      ruleForm: {
        username: "",
        phone: "",
      },
      rules: {
        username: [{ validator: validateUsername, trigger: "blur" }],
        phone: [{ validator: validatePhone, trigger: "blur" }],
      },
      // 颜色
      // themeColor: { bg: "#fff", color: "#000" },
      themeColor: { bg: "#E0E8FB", color: "#000" },
      // 性别
      sex: "0",
      drawer: false,
      // 当前路由
      breadList: [],
      // 当前屏幕宽度
      windowWidth: document.documentElement.clientWidth,
      activeIndex: "1",
      // 控制菜单是否展开
      isCollapse: false,
      admin: "",
      school: [],
      // 级联选择器的值
      value: "",
      dialogVisible: false,
    };
  },
  watch: {
    $route(to, form) {
      this.getBreadcrumb();
    },
  },
  created() {
    let theme = JSON.parse(sessionStorage.getItem("themeColor"));
    if (theme) {
      this.themeColor = { bg: theme.value, color: theme.color };
    }
    if (sessionStorage.getItem("user")) {
      this.getBreadcrumb();
      this.setUser(JSON.parse(sessionStorage.getItem("user")));
      if (!this.user.dept) {
        this.$get("/school/" + this.user.school.id).then((res) => {
          // console.log(res.data)
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
    // 获取当前屏幕宽度
    window.onresize = () => {
      this.windowWidth = document.documentElement.clientWidth;
    };
    // 文字头像
    if (this.user && this.user.username) {
      this.textAvatar(this.user.username);
    }
  },
};
</script>

<style scoped lang="less">
/* 定义深蓝色变量，方便调整 */
@deep-blue: #165dff;
/* 未选中时的标签底色 */
@item-bg-normal: #e8eefa;

.main {
  display: flex;
  height: 90%;

  .left {
    position: fixed;
    height: 100%;
    /* 强制覆盖内联样式，确保背景色正确 */
    background-color: #e0e8fb !important;
    box-shadow: 2px 0 6px rgba(0, 21, 41, 0.05); /* 加一点点右侧阴影更有立体感 */

    .logo {
      width: 100%;
      font-size: 18px;
      font-weight: bold;
      text-align: center;
      padding: 20px 0;
      color: @deep-blue; /* Logo 也用深蓝色 */
      /* 1Panel风格的Logo背景通常是透明或者也是浅蓝，这里保持简单 */
    }

    /* --- 核心修改：穿透修改 Element UI 菜单样式 --- */
    /deep/ .el-menu {
      border-right: none; /* 去掉右侧那条难看的灰线 */
      background-color: transparent !important; /* 菜单背景透明，透出 .left 的背景 */
    }

    /deep/ .el-menu-item {
      /* 布局：让菜单项像小卡片一样浮在中间 */
      margin: 8px 10px;
      height: 50px;
      line-height: 50px;
      border-radius: 6px; /* 圆角 */

      /* 颜色：未选中状态 */
      background-color: @item-bg-normal !important;
      color: #333 !important; /* 字体黑色 */
      border: 1px solid transparent; /* 预留边框位置，防止抖动 */
      transition: all 0.3s;

      i {
        color: #606266; /* 图标默认灰色 */
      }

      /* 鼠标移入 (Hover) */
      &:hover {
        background-color: #fff !important;
        color: @deep-blue !important;
        border-color: @deep-blue !important;

        i {
          color: @deep-blue !important;
        }
      }
    }

    /* 选中状态 (Active) */
    /deep/ .el-menu-item.is-active {
      background-color: #fff !important; /* 背景白色 */
      color: @deep-blue !important; /* 字体深蓝 */
      border: 1px solid @deep-blue !important; /* 一圈深蓝色边框 */
      font-weight: bold; /* 选中加粗一点 */

      i {
        color: @deep-blue !important; /* 图标也变深蓝 */
      }
    }
  }

  /* 右侧内容区保持原样，微调一点背景配合 */
  .right {
    transition: all 0.3s ease 0s;
    position: relative;
    background-color: #f2f3f5; /* 整个右侧给个淡淡的灰白背景，突出左侧 */

    .top {
      transition: all 0.3s ease 0s;
      position: fixed;
      display: flex;
      align-items: center;
      justify-content: space-between;
      z-index: 9;
      box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08); /* 顶部加阴影 */

      /* 顶部背景强制白色，显得干净 */
      background-color: #fff !important;

      .icon {
        font-size: 20px;
        cursor: pointer;
        margin-left: 20px;
        color: #333 !important;
      }
    }

    .bottom {
      width: 100%;
      height: 100%;
      margin-top: 65px;
      padding: 0 20px;
      box-sizing: border-box;

      // /* 内容盒子 */
      // .content-box {
      //   background: #fff;
      //   padding: 20px;
      //   border-radius: 4px;
      //   min-height: 80vh;
      // }
    /* 内容盒子 */
    .content-box {
      background: transparent; /* 改为透明，背景色由子页面自己决定 */
      padding: 0;              /* 去掉内边距，让子页面撑满 */
      /* border-radius: 4px; */ /* 圆角也可以注释掉，交给子页面控制 */
      min-height: 80vh;
    }
    }
  }

  /* 修复表单样式 */
  .ruleform /deep/ .el-input {
    width: 80% !important;
  }

  /deep/ .el-cascader {
    width: 100% !important;
  }
}
</style>
