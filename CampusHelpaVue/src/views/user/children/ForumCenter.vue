<template>
  <div class="forum-center">
    <div class="sub-nav">
      <el-button-group>
        <el-button 
          :type="isActive('list') ? 'primary' : 'default'" 
          icon="el-icon-s-comment"
          @click="goTo('/home/forum/list')"
        >
          校园论坛
        </el-button>
        <el-button 
          :type="isActive('mycomment') ? 'primary' : 'default'" 
          icon="el-icon-chat-dot-square"
          @click="goTo('/home/forum/mycomment')"
        >
          我的评论
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
  name: "ForumCenter",
  methods: {
    goTo(path) {
      if (this.$route.path !== path) {
        this.$router.push(path);
      }
    },
    isActive(keyword) {
      // 简单的判断逻辑：如果当前路径包含该关键字，则按钮高亮
      return this.$route.path.includes(keyword);
    }
  }
};
</script>

<style scoped>
.forum-center {
  padding: 10px 0;
}
.sub-nav {
  background-color: #fff;
  padding: 15px 20px;
  /* margin-bottom: 20px; */
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05); 
}
.sub-content {
  min-height: 500px;
}
</style>