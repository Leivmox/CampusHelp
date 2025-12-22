<template>
  <div class="help-center">
    <div class="sub-nav">
      <el-button-group>
        <el-button 
          :type="isActive('/home/help/task') ? 'primary' : 'default'" 
          icon="el-icon-edit"
          @click="goTo('/home/help/task')"
        >
          发布求助
        </el-button>

        <el-button 
          :type="isActive('/home/help/accept') ? 'primary' : 'default'" 
          icon="el-icon-search"
          @click="goTo('/home/help/accept')"
        >
          求助广场
        </el-button>

        <el-button 
          :type="isActive('/home/help/published') ? 'primary' : 'default'" 
          icon="el-icon-document"
          @click="goTo('/home/help/published')"
        >
          我发布的
        </el-button>

        <el-button 
          :type="isActive('/home/help/accepted') ? 'primary' : 'default'" 
          icon="el-icon-s-check"
          @click="goTo('/home/help/accepted')"
        >
          我接受的
        </el-button>
      </el-button-group>
    </div>

    <div class="sub-content">
      <transition name="el-fade-in-linear" mode="out-in">
        <router-view></router-view>
      </transition>
    </div>
  </div>
</template>

<script>
export default {
  name: "HelpCenter",
  methods: {
    // 路由跳转
    goTo(path) {
      // 避免重复点击报错
      if (this.$route.path !== path) {
        this.$router.push(path);
      }
    },
    // 【核心修复】：使用 === 进行全等判断
    // 只有当路由完全等于 '/home/help/accept' 时才亮，'/home/help/accepted' 不会亮
    isActive(path) {
      return this.$route.path === path;
    }
  }
};
</script>

<style scoped>
.help-center {
  padding: 10px 0;
}
.sub-nav {
  background-color: #fff;
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 20px; /* 建议加个下边距，让内容和按钮分开一点 */
}
.sub-content {
  min-height: 500px;
  background-color: #fff; /* 给内容区也加个背景，防止透明 */
  padding: 20px;         /* 给内容区加点内边距 */
  border-radius: 8px;
}
</style>