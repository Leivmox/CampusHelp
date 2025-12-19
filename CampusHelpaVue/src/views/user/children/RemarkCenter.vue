<template>
  <div class="remark-center">
    <div class="sub-nav">
      <el-button-group>
        <el-button 
          :type="isActive('myremark') ? 'primary' : 'default'" 
          icon="el-icon-chat-dot-round"
          @click="goTo('/home/remark/myremark')"
        >
          我的评价
        </el-button>
        <el-button 
          :type="isActive('userremark') ? 'primary' : 'default'" 
          icon="el-icon-user"
          @click="goTo('/home/remark/userremark')"
        >
          评价我的
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
  name: "RemarkCenter",
  methods: {
    // 路由跳转方法
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
.remark-center {
  padding: 10px 0;
}
.sub-nav {
  background-color: #fff;
  padding: 15px 20px;
  margin-bottom: 20px;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}
.sub-content {
  min-height: 500px;
}
</style>