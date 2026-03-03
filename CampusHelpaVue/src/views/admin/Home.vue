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
      <div class="logo" @click="$router.push('/admin/home')" style="cursor: pointer">
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
        <el-menu-item index="/admin/home">
          <i class="el-icon-s-home"></i>
          <span style="font-size: 20px">首页</span>
        </el-menu-item>

        <el-menu-item index="/admin/home/school">
          <i class="el-icon-office-building"></i>
          <span style="font-size: 20px">学校管理</span>
        </el-menu-item>

        <el-menu-item index="/admin/home/student">
          <i class="el-icon-s-custom"></i>
          <span style="font-size: 20px">用户管理</span>
        </el-menu-item>

        <el-menu-item index="/admin/home/post">
          <i class="el-icon-s-order"></i>
          <span style="font-size: 20px">论坛管理</span>
        </el-menu-item>

        <el-menu-item index="/admin/home/task">
          <i class="el-icon-s-claim"></i>
          <span style="font-size: 20px">求助管理</span>
        </el-menu-item>

        <el-menu-item index="/admin/home/remark">
          <i class="el-icon-star-on"></i>
          <span style="font-size: 20px">评价管理</span>
        </el-menu-item>

        <el-menu-item index="/admin/home/notice">
          <i class="el-icon-bell"></i>
          <span style="font-size: 20px">公告管理</span>
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
                {{ admin.username || '管理员' }}
              </span>

              <el-avatar
                style="background: #409eff; user-select: none"
                :size="35"
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
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </div>

      <div class="bottom">
        <div class="content-box">
          <transition name="el-fade-in" mode="out-in">
            <router-view></router-view>
          </transition>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";

export default {
  name: "AdminHome",
  methods: {
    ...mapMutations("admin", ["setAdmin"]),
    
    getBreadcrumb() {
      let matched = this.$route.matched;
      if (matched[0].name != "adminHome") {
        matched = [{ path: "/admin/home", meta: { title: "首页" } }].concat(matched);
      }
      this.breadList = matched;
    },
    
    handleCommand(command) {
      if (command === "exit") {
        this.exit();
      }
    },
    
    exit() {
      sessionStorage.removeItem("admin");
      this.$router.push("/admin");
    },
    
    textAvatar(username) {
      if (!username) return;
      let arr = username.split(" ");
      this.firstName = "";
      for (var i in arr) {
        this.firstName += arr[i].substr(0, 1);
      }
      this.firstName = this.firstName.toLocaleUpperCase();
    },
  },
  
  computed: {
    ...mapState("admin", ["admin"]),
    
    activeMenu() {
      const path = this.$route.path;
      if (path === "/admin/home" || path === "/admin/home/") {
        return "/admin/home";
      }
      return path;
    },
  },
  
  data() {
    return {
      firstName: "",
      themeColor: { bg: "#1d2129", color: "#fff" },
      breadList: [],
      windowWidth: document.documentElement.clientWidth,
      isCollapse: false,
    };
  },
  
  watch: {
    $route(to, from) {
      this.getBreadcrumb();
      window.scrollTo(0, 0);
      document.body.scrollTop = 0;
      document.documentElement.scrollTop = 0;
      
      this.$nextTick(() => {
        const rightPanel = document.querySelector(".right");
        if (rightPanel) {
          rightPanel.scrollTop = 0;
        }
        const bottomPanel = document.querySelector(".bottom");
        if (bottomPanel) {
          bottomPanel.scrollTop = 0;
        }
      });
    },
    
    admin: {
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

    if (sessionStorage.getItem("admin")) {
      this.getBreadcrumb();
      const adminObj = JSON.parse(sessionStorage.getItem("admin"));
      this.setAdmin(adminObj);
      if (adminObj && adminObj.username) {
        this.textAvatar(adminObj.username);
      }
    } else {
      this.$msg("您尚未登陆,没有权限", "error");
      this.$router.push("/admin");
    }
  },
  
  mounted() {
    window.onresize = () => {
      this.windowWidth = document.documentElement.clientWidth;
    };
  },
};
</script>

<style scoped lang="less">
@deep-blue: #409eff;
@item-bg-normal: #2a2f3a;

.main {
  display: flex;
  height: 100%;

  .left {
    position: fixed;
    height: 100%;
    background-color: #1d2129 !important;
    box-shadow: 2px 0 6px rgba(0, 21, 41, 0.35);

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
        transition: all 0.3s;
        animation: fadeIn 0.5s;
      }

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
      color: #c9cdd4 !important;
      border: 1px solid transparent;
      transition: all 0.3s;

      i {
        color: #c9cdd4;
      }

      &:hover {
        background-color: #3a404d !important;
        color: #409eff !important;
        border-color: #409eff !important;

        i {
          color: #409eff !important;
        }
      }
    }

    /deep/ .el-menu-item.is-active {
      background-color: #3a404d !important;
      color: #409eff !important;
      border: 1px solid #409eff !important;
      font-weight: bold;

      i {
        color: #409eff !important;
      }
    }

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
      padding-right: 20px;

      .icon {
        font-size: 20px;
        cursor: pointer;
        margin-left: 20px;
      }
    }

    .bottom {
      width: 100%;
      height: 100%;
      margin-top: 65px;
      padding: 0 20px;
      box-sizing: border-box;

      .content-box {
        background: transparent;
        padding: 0;
        min-height: 80vh;
      }
    }
  }
}

.user-area {
  display: flex;
  align-items: center;
  margin-left: auto;
}
</style>
