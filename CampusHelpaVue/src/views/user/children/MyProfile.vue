<template>
  <div class="profile-container">
    <el-card class="top-card" shadow="hover" :body-style="{ padding: '0px' }">
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

      <div class="user-profile-row">
        <div class="avatar-section">
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
            <div class="avatar-hover-mask"><i class="el-icon-camera"></i></div>
            <el-avatar
              :size="90"
              :class="['user-avatar', !user.avatar ? 'default-avatar' : '']"
              :src="fullAvatarUrl"
            >
              {{
                user.username ? user.username.slice(0, 1).toUpperCase() : "U"
              }}
            </el-avatar>
          </el-upload>
        </div>

        <div class="info-section">
          <div class="name-row">
            <span class="username">{{ user.username }}</span>
            <el-tag size="mini" type="primary" effect="dark" class="role-tag"
              >学生</el-tag
            >
          </div>
          <div class="bio-row" :title="user.signature">
            {{ user.signature || "这个人很懒，什么都没有留下..." }}
          </div>
        </div>

        <div class="stats-section">
          <div class="stat-item">
            <div class="num highlight">{{ user.balance || "0" }}</div>
            <div class="label">积分余额</div>
          </div>
          <el-divider direction="vertical" class="stat-divider"></el-divider>
          <div class="stat-item">
            <div class="num">{{ publishCount }}</div>
            <div class="label">发布求助</div>
          </div>
          <el-divider direction="vertical" class="stat-divider"></el-divider>
          <div class="stat-item">
            <div class="num">{{ solveCount }}</div>
            <div class="label">解决求助</div>
          </div>
        </div>
      </div>
    </el-card>

    <el-row :gutter="20" class="bottom-section">
      <el-col :span="8">
        <el-card shadow="hover" class="detail-card">
          <div slot="header" class="clearfix">
            <span class="card-title">详细资料</span>
          </div>
          <el-descriptions :column="1" border size="medium">
            <el-descriptions-item>
              <template slot="label"
                ><i class="el-icon-user"></i> 学号</template
              >
              {{ user.studentId }}
            </el-descriptions-item>
            <el-descriptions-item>
              <template slot="label"
                ><i class="el-icon-message"></i> 邮箱</template
              >
              {{ user.email || "未公开" }}
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
                ><i class="el-icon-date"></i> 注册</template
              >
              {{ user.createTime || "2023-09-01" }}
            </el-descriptions-item>
          </el-descriptions>
        </el-card>
      </el-col>

      <el-col :span="16">
        <el-card shadow="hover" class="history-card">
          <div slot="header" class="clearfix">
            <span class="card-title"
              >我的历史动态 ({{ historyList.length }})</span
            >
          </div>

          <div class="history-content">
            <div v-if="historyList.length > 0">
              <div
                v-for="(item, index) in historyList"
                :key="index"
                class="history-item"
                @click="goToDetail(item.id)"
              >
                <div class="item-thumb" v-if="hasImage(item)">
                  <el-image
                    :src="getFirstImage(item)"
                    fit="cover"
                    class="thumb-img"
                  >
                  </el-image>
                </div>

                <div class="item-main">
                  <div class="item-title">{{ item.title }}</div>
                  <div class="item-desc">{{ item.content }}</div>
                </div>

                <div class="item-meta">
                  <span class="time"
                    ><i class="el-icon-time"></i>
                    {{ item.createTime | formatDate }}</span
                  >
                  <span class="likes"
                    ><i class="el-icon-thumb"></i>
                    {{ item.likeCount || 0 }}</span
                  >
                </div>
              </div>
            </div>

            <el-empty
              v-else
              description="暂无历史动态，快去发布吧！"
            ></el-empty>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { listPublished, listAccepted } from "@/api/task/task";
import { updateUserAvatar } from "@/api/system/user";
import { formatDate } from "@/util/date";

export default {
  name: "MyProfile",
  data() {
    return {
      publishCount: 0,
      solveCount: 0,
      historyList: [],
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
  filters: {
    formatDate(time) {
      if (!time) return "";
      let date = new Date(time);
      return formatDate(date, "yyyy-MM-dd hh:mm");
    },
  },
  created() {
    this.getUserStats();
    this.getMyPosts();
  },
  methods: {
    hasImage(item) {
      if (item.imgList && item.imgList.length > 0) return true;
      if (item.imgUrl && item.imgUrl !== "") return true;
      return false;
    },
    getFirstImage(item) {
      let url = "";
      if (item.imgList && item.imgList.length > 0) {
        url = item.imgList[0];
      } else if (item.imgUrl) {
        url = item.imgUrl.split(",")[0];
      }

      if (!url) return "";
      if (url.startsWith("http")) return url;
      return `http://localhost:8080${url}`;
    },
    getMyPosts() {
      if (!this.user || !this.user.id) return;
      this.$get("/post", {
        schoolId: this.user.school ? this.user.school.id : null,
        userId: this.user.id,
      })
        .then((res) => {
          if (res.data.status) {
            this.historyList = res.data.posts;
          }
        })
        .catch((err) => {
          console.error("获取帖子失败", err);
        });
    },
    goToDetail(id) {
      this.$router.push({ name: "PostDetail", params: { id: id } });
    },
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
            } catch (e) {}
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
/* ... 原有样式保持不变 ... */
.profile-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}
.top-card {
  border-radius: 8px;
  margin-bottom: 20px;
  overflow: visible;
}
.user-header-bg {
  height: 280px;
  background-size: cover;
  background-position: center;
  position: relative;
  background-color: #a0cfff;
  .edit-btn {
    position: absolute;
    top: 15px;
    right: 15px;
    background: rgba(255, 255, 255, 0.4);
    border: none;
    color: #333;
    &:hover {
      background: #fff;
    }
  }
}
.user-profile-row {
  display: flex;
  align-items: flex-end;
  padding: 0 30px 20px 30px;
  margin-top: -25px;
  position: relative;
  z-index: 2;
  .avatar-section {
    position: relative;
    margin-right: 20px;
    .user-avatar {
      border: 4px solid #fff;
      background-color: #fff;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    }
    .avatar-uploader {
      position: relative;
      border-radius: 50%;
      overflow: hidden;
      display: block;
    }
    .avatar-hover-mask {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.5);
      color: #fff;
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 24px;
      opacity: 0;
      transition: opacity 0.3s;
      border-radius: 50%;
    }
    &:hover .avatar-hover-mask {
      opacity: 1;
    }
  }
  .info-section {
    flex: 1;
    padding-bottom: 5px;
    .name-row {
      display: flex;
      align-items: center;
      margin-bottom: 8px;
      .username {
        font-size: 24px;
        font-weight: bold;
        color: #303133;
        margin-right: 10px;
        text-shadow: 0 1px 2px rgba(255, 255, 255, 0.8);
      }
    }
    .bio-row {
      font-size: 14px;
      color: #606266;
      max-width: 500px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  }
  .stats-section {
    display: flex;
    align-items: center;
    padding-bottom: 5px;
    .stat-item {
      text-align: center;
      padding: 0 20px;
      .num {
        font-size: 24px;
        font-weight: bold;
        color: #303133;
        &.highlight {
          color: #ff9900;
        }
      }
      .label {
        font-size: 12px;
        color: #909399;
        margin-top: 2px;
      }
    }
    .stat-divider {
      height: 40px;
    }
  }
}
.bottom-section {
  .detail-card,
  .history-card {
    border-radius: 8px;
    height: 100%;
    min-height: 400px;
  }
  .card-title {
    font-weight: bold;
    font-size: 16px;
  }
}
.history-content {
  max-height: 450px;
  overflow-y: auto;
  padding: 0 10px;
  .history-item {
    padding: 15px 0;
    border-bottom: 1px solid #ebeef5;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    transition: background-color 0.2s;
    &:hover {
      background-color: #f9f9f9;
      padding-left: 5px;
    }
    .item-thumb {
      width: 100px;
      height: 70px;
      margin-right: 15px;
      flex-shrink: 0;
      border-radius: 4px;
      overflow: hidden;
      border: 1px solid #eee;
      .thumb-img {
        width: 100%;
        height: 100%;
      }
    }
    .item-main {
      flex: 1;
      min-width: 0;
      padding-right: 15px;
      .item-title {
        font-size: 15px;
        font-weight: bold;
        color: #303133;
        margin-bottom: 6px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      .item-desc {
        font-size: 13px;
        color: #909399;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 2;
        overflow: hidden;
        line-height: 1.5;
      }
    }
    .item-meta {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      min-width: 90px;
      font-size: 12px;
      color: #c0c4cc;
      .time {
        margin-bottom: 5px;
      }
      .likes i {
        margin-right: 3px;
        color: #f56c6c;
      }
    }
  }
}
/deep/ .el-descriptions-item__label {
  width: 80px;
  text-align-last: justify;
}
.avatar-section {
  position: relative;
  margin-right: 20px;

  .user-avatar {
    border: 4px solid #fff;
    box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
    font-size: 32px; /* 调大首字的字号 */
    font-weight: bold;
    color: #fff;     /* 文字颜色为白色 */
    display: flex;
    justify-content: center;
    align-items: center;
  }

  /* 重点：没有头像时的背景色 */
  .default-avatar {
    background-color: #67C23A !important; /* Element UI 标准成功绿 */
    /* 或者使用更有质感的绿色：background: linear-gradient(135deg, #67C23A 0%, #3ca510 100%); */
  }
}
</style>
