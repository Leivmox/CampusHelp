<template>
  <div class="profile-container">
    <el-card class="box-card" shadow="hover">
      <div class="user-header-bg">
        <el-button
          class="edit-btn"
          type="primary"
          icon="el-icon-edit"
          circle
          size="small"
          title="修改信息"
          @click="$emit('personalInformation')"
        ></el-button>
      </div>

      <div class="user-profile-core">
        <div class="avatar-wrapper">
          <el-upload
            class="avatar-uploader"
            action="http://localhost:8080/common/upload"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :before-upload="beforeAvatarUpload"
            :data="{ type: 'avatar' }"
            name="file"
            :headers="headers"
          >
            <div class="avatar-hover-mask">
              <i class="el-icon-camera"></i>
            </div>
            
            <el-avatar :size="80" class="user-avatar" :src="fullAvatarUrl">
              {{ user.username ? user.username.slice(-1) : "User" }}
            </el-avatar>
          </el-upload>
           </div>

        <div class="user-names">
          <span class="name">{{ user.username }}</span>
          <el-tag size="mini" type="success" effect="dark" class="role-tag">学生</el-tag>
        </div>
        <div class="user-bio">
          {{ user.signature || "这个人很懒，什么都没有留下..." }}
        </div>
      </div>

<div class="user-stats">
        <div class="stat-item">
          <div class="num" style="color: #ff9900">
            {{ user.balance || "0" }}
          </div>
          <div class="label">积分余额</div>
        </div>

        <el-divider direction="vertical"></el-divider>

        <div class="stat-item">
          <div class="num">{{ publishCount }}</div>
          <div class="label">发布求助</div>
        </div>

        <el-divider direction="vertical"></el-divider>

        <div class="stat-item">
          <div class="num">{{ solveCount }}</div>
          <div class="label">解决求助</div>
        </div>
      </div>
      
      <el-divider content-position="center">详细资料</el-divider>

<div class="info-content">
        <el-descriptions :column="2" border>
          <el-descriptions-item>
            <template slot="label"><i class="el-icon-user"></i> 学号</template>
            {{ user.studentId }}
          </el-descriptions-item>

          <el-descriptions-item>
            <template slot="label"><i class="el-icon-mobile-phone"></i> 手机</template>
            {{ user.phone }}
          </el-descriptions-item>

          <el-descriptions-item>
            <template slot="label"><i class="el-icon-school"></i> 学校</template>
            {{ user.school ? user.school.name : "未设置" }}
          </el-descriptions-item>

          <el-descriptions-item>
            <template slot="label"><i class="el-icon-office-building"></i> 系别</template>
            {{ user.dept ? user.dept.name : "未设置" }}
          </el-descriptions-item>

          <el-descriptions-item>
            <template slot="label"><i class="el-icon-collection-tag"></i> 班级</template>
            {{ user.aclass ? user.aclass.name : "未设置" }}
          </el-descriptions-item>

          <el-descriptions-item>
            <template slot="label"><i class="el-icon-date"></i> 注册时间</template>
            {{ user.createTime || '2023-09-01' }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </el-card>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import { listPublished, listAccepted } from "@/api/task/task";
// 引入刚刚新建的更新头像接口
import { updateUserAvatar } from "@/api/system/user";

export default {
  name: "MyProfile",
  data() {
    return {
      publishCount: 0,
      solveCount: 0,
      // 【重点修改】在这里直接定义上传图片的请求头
      headers: {
        // 这里的 'token' 是你登录时存进 localStorage 的 key 名字
        // 如果你存的名字叫 'USER_TOKEN' 或者 'SATOKEN'，请把 'token' 改成对应的名字
        // 如果你的后端不需要 Bearer 前缀，也可以去掉 "Bearer "
        Authorization: localStorage.getItem("token") 
      }
    }
  },
  computed: {
    ...mapState('user', ['user']),
    
    // 计算完整的头像 URL
    fullAvatarUrl() {
      if (!this.user.avatar) return '';
      if (this.user.avatar.startsWith("http")) return this.user.avatar;
      // 注意：这里的端口(8080)要和你后端对应
      return `http://localhost:8080${this.user.avatar}`;
    }
  },
  created() {
    this.getUserStats();
  },
  methods: {
    getUserStats() {
      const userId = this.user.id;
      
      // 获取发布数
      listPublished(userId).then(res => {
         // 你的 request.js 如果没有解包 data，这里可能需要调整为 res.data.task
         // 根据你之前的代码，这里做个兼容处理
         const list = res.task || (res.data && res.data.task) || [];
         this.publishCount = list.length || 0;
      }).catch(err => { 
          console.error(err);
          this.publishCount = 0; 
      });

      // 获取解决数
      listAccepted(userId).then(res => {
         const list = res.task || (res.data && res.data.task) || [];
         this.solveCount = list.length || 0;
      }).catch(err => { 
          console.error(err);
          this.solveCount = 0; 
      });
    },

    // 上传之前的校验
    beforeAvatarUpload(file) {
      const isJPGOrPNG = file.type === 'image/jpeg' || file.type === 'image/png';
      const isLt2M = file.size / 1024 / 1024 < 5;

      if (!isJPGOrPNG) {
        this.$message.error('上传头像图片只能是 JPG/PNG 格式!');
      }
      if (!isLt2M) {
        this.$message.error('上传头像图片大小不能超过 5MB!');
      }
      return isJPGOrPNG && isLt2M;
    },

// 上传成功后的回调
    handleAvatarSuccess(res, file) {
      // 判断后端返回的状态码
      if (res.code === 200 || res.status === 200) {
        const uploadedUrl = res.url || res.data.url;

        const userToUpdate = {
          id: this.user.id,
          // 这里的 studentId 传不传都行，反正后端现在只认 ID
          studentId: this.user.studentId, 
          avatar: uploadedUrl
        };

        console.log("正在请求更新头像，参数：", userToUpdate);

        // 调用后端接口保存路径
        updateUserAvatar(userToUpdate).then(response => {
          this.$message.success("头像修改成功");

          // ===============================================
          // 1. 更新当前页面视图 (立刻看到效果)
          // ===============================================
          this.$set(this.user, 'avatar', uploadedUrl);

          // ===============================================
          // 🛑 2. 核心修复：同步更新浏览器缓存 (解决刷新复原问题) 🛑
          // ===============================================
          
          // 我们尝试更新 localStorage 里的 "user"
          // 注意：请确认你登录时存的名字是不是 "user"
          // 如果你存的是 "userInfo"，请把下面的 "user" 改成 "userInfo"
          let localUserStr = localStorage.getItem("user");
          
          if (localUserStr) {
            try {
              let localUser = JSON.parse(localUserStr);
              // 修改缓存里的头像路径
              localUser.avatar = uploadedUrl;
              // 重新塞回 localStorage
              localStorage.setItem("user", JSON.stringify(localUser));
              console.log("LocalStorage 更新成功！刷新页面也不会丢了。");
            } catch (e) {
              console.error("解析缓存失败", e);
            }
          }

          // 如果你的项目也使用了 sessionStorage，顺手也更新一下
          let sessionUserStr = sessionStorage.getItem("user");
          if (sessionUserStr) {
             let sessionUser = JSON.parse(sessionUserStr);
             sessionUser.avatar = uploadedUrl;
             sessionStorage.setItem("user", JSON.stringify(sessionUser));
          }

          // ===============================================
          // 3. 如果用了 Vuex，更新 Store (保持数据一致性)
          // ===============================================
          // 这里的 'user/SET_AVATAR' 需要你去 store/modules/user.js 里确认有没有这个 mutation
          // 如果没有，可以先注释掉下面这行，光靠上面的 localStorage 就够了
          // this.$store.commit('user/SET_AVATAR', uploadedUrl); 
        });

      } else {
        this.$message.error(res.msg || '头像上传失败');
      }
    }
  }
}
</script>

<style scoped lang="less">
// ... 原有的 .profile-container, .box-card 等样式保持不变 ...
.profile-container {
  padding: 20px;
  display: flex;
  justify-content: center;
}
.box-card {
  width: 100%;
  max-width: 800px;
  border-radius: 12px;
  overflow: hidden;
  /deep/ .el-card__body { padding: 0; }
}
.user-header-bg {
  height: 120px;
  background: linear-gradient(135deg, #409eff 0%, #a0cfff 100%);
  position: relative;
  .edit-btn {
    position: absolute; top: 15px; right: 15px;
    background: rgba(255, 255, 255, 0.3); border: none; color: #fff;
    &:hover { background: rgba(255, 255, 255, 0.5); }
  }
}

// 核心改动样式在这里
.user-profile-core {
  text-align: center;
  position: relative;
  padding-bottom: 20px;

  .avatar-wrapper {
    margin-top: -40px;
    margin-bottom: 10px;
    display: inline-block; // 必须加上，为了让 uploader 居中
    position: relative;    // 为了定位 hover 遮罩

    // 调整上传组件的样式
    .avatar-uploader {
      display: inline-block;
      position: relative;
      border-radius: 50%;
      cursor: pointer;
    }

    // 头像样式
    .user-avatar {
      border: 4px solid #fff;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
      background-color: #409eff;
      font-size: 30px;
      transition: all 0.3s; // 增加过渡动画
    }

    // 悬停遮罩层样式
    .avatar-hover-mask {
      position: absolute;
      top: 4px;     // 匹配 border 的宽度
      left: 4px;
      right: 4px;
      bottom: 4px;
      border-radius: 50%;
      background: rgba(0, 0, 0, 0.5);
      color: #fff;
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 24px;
      opacity: 0;   // 默认隐藏
      transition: opacity 0.3s;
      z-index: 10;
    }

    // 鼠标悬停时显示遮罩
    &:hover .avatar-hover-mask {
      opacity: 1;
    }
  }

  .user-names {
     display: flex; justify-content: center; align-items: center; gap: 10px; margin-bottom: 8px;
    .name { font-size: 22px; font-weight: bold; color: #303133; }
  }
  .user-bio { font-size: 13px; color: #909399; padding: 0 20px; }
}

// ... 原有的 .user-stats, .info-content 样式 ...
.user-stats {
  display: flex; justify-content: center; align-items: center; padding: 10px 0 25px 0;
  .stat-item {
    text-align: center; padding: 0 30px;
    .num { font-size: 20px; font-weight: 600; color: #303133; font-family: sans-serif; }
    .label { font-size: 12px; color: #909399; margin-top: 4px; }
  }
}

.info-content {
  padding: 0 20px 30px 20px;
  /deep/ .el-descriptions__title { font-size: 15px; font-weight: bold; }
  /deep/ .el-descriptions-item__label { width: 100px; text-align: right; background-color: #f8f9fa; }
}
</style>