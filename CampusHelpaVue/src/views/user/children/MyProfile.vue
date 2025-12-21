<template>
  <div class="profile-container">
    <el-card class="box-card" shadow="hover">
      <div
        class="user-header-bg"
        :style="{ backgroundImage: `url(${userBgImg})` }"
      >
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
              {{
                user.username ? user.username.slice(0, 1).toUpperCase() : "User"
              }}
            </el-avatar>
          </el-upload>
        </div>

        <div class="user-names">
          <span class="name">{{ user.username }}</span>
          <el-tag size="mini" type="success" effect="dark" class="role-tag"
            >学生</el-tag
          >
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
            <template slot="label"
              ><i class="el-icon-mobile-phone"></i> 手机</template
            >
            {{ user.phone }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"
              ><i class="el-icon-school"></i> 学校</template
            >
            {{ user.school ? user.school.name : "未设置" }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"
              ><i class="el-icon-office-building"></i> 系别</template
            >
            {{ user.dept ? user.dept.name : "未设置" }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"
              ><i class="el-icon-collection-tag"></i> 班级</template
            >
            {{ user.aclass ? user.aclass.name : "未设置" }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"
              ><i class="el-icon-date"></i> 注册时间</template
            >
            {{ user.createTime || "2023-09-01" }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </el-card>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { listPublished, listAccepted } from "@/api/task/task";
import { updateUserAvatar } from "@/api/system/user";

export default {
  name: "MyProfile",
  data() {
    return {
      publishCount: 0,
      solveCount: 0,
      // 🟢 新增：引入用户背景图
      userBgImg: require("@/assets/img/user_bg.jpg"),
      headers: {
        Authorization: localStorage.getItem("token"),
      },
    };
  },
  computed: {
    ...mapState("user", ["user"]),
    fullAvatarUrl() {
      if (!this.user.avatar) return "";
      if (this.user.avatar.startsWith("http")) return this.user.avatar;
      return `http://localhost:8080${this.user.avatar}`;
    },
  },
  created() {
    this.getUserStats();
  },
  methods: {
    getUserStats() {
      if (!this.user.id) return;
      listPublished(this.user.id)
        .then((res) => {
          const list = res.task || (res.data && res.data.task) || [];
          this.publishCount = list.length || 0;
        })
        .catch((err) => {
          console.error(err);
          this.publishCount = 0;
        });

      listAccepted(this.user.id)
        .then((res) => {
          const list = res.task || (res.data && res.data.task) || [];
          this.solveCount = list.length || 0;
        })
        .catch((err) => {
          console.error(err);
          this.solveCount = 0;
        });
    },
    beforeAvatarUpload(file) {
      const isJPGOrPNG =
        file.type === "image/jpeg" || file.type === "image/png";
      const isLt2M = file.size / 1024 / 1024 < 5;
      if (!isJPGOrPNG) {
        this.$message.error("上传头像图片只能是 JPG/PNG 格式!");
      }
      if (!isLt2M) {
        this.$message.error("上传头像图片大小不能超过 5MB!");
      }
      return isJPGOrPNG && isLt2M;
    },
    handleAvatarSuccess(res, file) {
      if (res.code === 200 || res.status === 200) {
        const uploadedUrl = res.url || res.data.url;
        const userToUpdate = {
          id: this.user.id,
          studentId: this.user.studentId,
          avatar: uploadedUrl,
        };
        updateUserAvatar(userToUpdate).then((response) => {
          this.$message.success("头像修改成功");
          this.$set(this.user, "avatar", uploadedUrl);
          let localUserStr = localStorage.getItem("user");
          if (localUserStr) {
            try {
              let localUser = JSON.parse(localUserStr);
              localUser.avatar = uploadedUrl;
              localStorage.setItem("user", JSON.stringify(localUser));
            } catch (e) {
              console.error(e);
            }
          }
          let sessionUserStr = sessionStorage.getItem("user");
          if (sessionUserStr) {
            let sessionUser = JSON.parse(sessionUserStr);
            sessionUser.avatar = uploadedUrl;
            sessionStorage.setItem("user", JSON.stringify(sessionUser));
          }
        });
      } else {
        this.$message.error(res.msg || "头像上传失败");
      }
    },
  },
};
</script>

<style scoped lang="less">
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
  /deep/ .el-card__body {
    padding: 0;
  }
}

/* 🟢 核心修改：背景图样式调整 */
.user-header-bg {
  height: 220px;
  /* background: linear-gradient(135deg, #409eff 0%, #a0cfff 100%); 删除旧渐变 */
  background-size: cover; /* 让图片填满 */
  background-position: center; /* 图片居中显示 */
  position: relative;
  .edit-btn {
    position: absolute;
    top: 15px;
    right: 15px;
    background: rgba(255, 255, 255, 0.3);
    border: none;
    color: #fff;
    &:hover {
      background: rgba(255, 255, 255, 0.5);
    }
  }
}

// ... 其他样式保持不变 ...
.user-profile-core {
  text-align: center;
  position: relative;
  padding-bottom: 20px;
  .avatar-wrapper {
    margin-top: -40px;
    margin-bottom: 10px;
    display: inline-block;
    position: relative;
    .avatar-uploader {
      display: inline-block;
      position: relative;
      border-radius: 50%;
      cursor: pointer;
    }
    .user-avatar {
      border: 4px solid #fff;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
      background-color: #409eff;
      font-size: 30px;
      transition: all 0.3s;
    }
    .avatar-hover-mask {
      position: absolute;
      top: 4px;
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
      opacity: 0;
      transition: opacity 0.3s;
      z-index: 10;
    }
    &:hover .avatar-hover-mask {
      opacity: 1;
    }
  }
  .user-names {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    margin-bottom: 8px;
    .name {
      font-size: 22px;
      font-weight: bold;
      color: #303133;
    }
  }
  .user-bio {
    font-size: 13px;
    color: #909399;
    padding: 0 20px;
  }
}
.user-stats {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px 0 25px 0;
  .stat-item {
    text-align: center;
    padding: 0 30px;
    .num {
      font-size: 20px;
      font-weight: 600;
      color: #303133;
      font-family: sans-serif;
    }
    .label {
      font-size: 12px;
      color: #909399;
      margin-top: 4px;
    }
  }
}
.info-content {
  padding: 0 20px 30px 20px;
  /deep/ .el-descriptions__title {
    font-size: 15px;
    font-weight: bold;
  }
  /deep/ .el-descriptions-item__label {
    width: 100px;
    text-align: right;
    background-color: #f8f9fa;
  }
}
</style>
