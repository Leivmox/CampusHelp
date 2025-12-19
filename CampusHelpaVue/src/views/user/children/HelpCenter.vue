<template>
  <div class="help-center">
    <div class="sub-nav">
      <el-button-group>
        <el-button 
          :type="isActive('task') ? 'primary' : 'default'" 
          icon="el-icon-edit"
          @click="goTo('/home/help/task')"
        >
          发布求助
        </el-button>
        <el-button 
          :type="isActive('accept') ? 'primary' : 'default'" 
          icon="el-icon-search"
          @click="goTo('/home/help/accept')"
        >
          接受求助
        </el-button>
        <el-button 
          :type="isActive('published') ? 'primary' : 'default'" 
          icon="el-icon-document"
          @click="goTo('/home/help/published')"
        >
          我发布的
        </el-button>
        <el-button 
          :type="isActive('accepted') ? 'primary' : 'default'" 
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
      if (this.$route.path !== path) {
        this.$router.push(path);
      }
    },
    // 判断按钮是否高亮
    isActive(keyword) {
      return this.$route.path.includes(keyword);
    }
  }
};
</script>

<style scoped>
.help-center {
  padding: 0;
}
.sub-nav {
  background-color: #fff;
  padding: 15px 20px;
  margin-bottom: 20px;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}
.sub-content {
  /* 可以根据需要添加背景色或内边距 */
  min-height: 500px;
}
</style>