<template>
  <el-row :gutter="20" class="main-layout-row">
    <el-col :xs="24" :sm="24" :md="16" :lg="17">
      <el-card shadow="never" class="detail-card">
        <div slot="header" class="clearfix">
          <el-page-header
            @back="$router.back()"
            content="求助详情"
          ></el-page-header>
        </div>

        <div
          v-if="loading"
          class="loading-box"
          style="text-align: center; padding: 50px"
        >
          <i class="el-icon-loading"></i> 数据加载中...
        </div>

        <div v-else-if="task">
          <div class="status-banner" :class="'status-' + task.state">
            <i :class="statusIcon"></i>
            <span>{{ statusText }}</span>
          </div>

          <div class="author-info">
            <el-avatar
              :size="40"
              :src="getSafeAvatar(task.publish)"
              style="background-color: #409eff; color: #fff; margin-right: 10px"
            >
              {{ getAvatarText(task.publish) }}
            </el-avatar>
            <div class="author-text">
              <div class="name">
                {{ task.publish ? task.publish.username : "匿名用户" }}
              </div>
              <div class="time">发布于 {{ task.createTime | formatDate }}</div>
            </div>
          </div>

          <div class="post-main">
            <div class="reward-badge">
              <i class="el-icon-coin"></i> 悬赏积分：10
            </div>
            <div class="title-row">
              <h1 class="main-title">{{ task.taskTitle }}</h1>

              <div class="owner-actions" v-if="isOwner && task.state === 0">
                <el-button
                  type="text"
                  icon="el-icon-delete"
                  class="delete-btn"
                  @click="handleDelete"
                  >取消并下架求助</el-button
                >
              </div>
            </div>

            <div class="main-content">{{ task.taskContext }}</div>

            <div
              class="img-grid"
              v-if="task.imgList && task.imgList.length > 0"
            >
              <el-image
                v-for="(img, idx) in task.imgList"
                :key="idx"
                :src="getResUrl(img)"
                :preview-src-list="task.imgList.map((url) => getResUrl(url))"
                fit="cover"
                class="detail-img"
              ></el-image>
            </div>
          </div>

          <el-divider></el-divider>

          <div class="task-operations">
            <div v-if="isGuest && task.state === 0" class="op-box">
              <p class="op-tip">
                如果您能提供帮助，请确认您的空余时间并点击下方按钮接单
              </p>
              <el-button
                type="primary"
                size="large"
                icon="el-icon-check"
                @click="handleAccept"
                >接受求助</el-button
              >
            </div>

            <div v-else-if="isOwner && task.state === 0" class="op-box">
              <el-alert
                title="您的求助正在等待校友接单..."
                type="info"
                :closable="false"
                center
                show-icon
              ></el-alert>
            </div>

            <div v-else-if="isTaker && task.state === 1" class="op-box">
              <el-alert
                title="互助进行中：请联系发布者提供帮助"
                type="warning"
                show-icon
                :closable="false"
              ></el-alert>
              <div class="btn-group">
                <el-button type="danger" plain @click="handleTakerCancel"
                  >取消接单</el-button
                >
              </div>
            </div>

            <div v-else-if="isOwner && task.state === 1" class="op-box">
              <el-alert
                title="帮助者已就绪：如果问题已解决，请务必确认完成"
                type="info"
                show-icon
                :closable="false"
              ></el-alert>
              <div class="btn-group">
                <el-button
                  type="success"
                  icon="el-icon-circle-check"
                  @click="handleComplete"
                  >确认解决</el-button
                >
              </div>
            </div>

            <div v-else-if="task.state === 2" class="op-box completed">
              <el-result
                icon="success"
                title="任务已完成"
                subTitle="感谢校友间的互帮互助"
              ></el-result>
            </div>
          </div>
        </div>

        <el-empty
          v-else
          description="抱歉，该求助信息不存在或已被删除"
        ></el-empty>
      </el-card>
    </el-col>

    <el-col :xs="24" :sm="24" :md="8" :lg="7">
      <div v-if="task && task.publish" class="white-block profile-card">
        <div
          class="profile-bg"
          :style="{ backgroundImage: `url(${userBgImg})` }"
        ></div>
        <div class="profile-content">
          <div class="avatar-wrap">
            <el-avatar
              :size="70"
              :src="getSafeAvatar(task.publish)"
              class="user-avatar"
            >
              {{ getAvatarText(task.publish) }}
            </el-avatar>
          </div>
          <div class="user-name">{{ task.publish.username }}</div>
          <div class="user-role">
            {{ task.publish.school ? task.publish.school.name : "认证校友" }} ·
            发布者
          </div>
          <div class="user-bio">
            {{ task.publish.signature || "这个同学很低调，暂无签名" }}
          </div>
        </div>
        <div class="profile-stats">
          <div class="p-stat-item">
            <div class="num" style="color: #ff9900">
              {{ task.publish.balance || 0 }}
            </div>
            <div class="label">积分</div>
          </div>
          <div class="p-divider"></div>
          <div class="p-stat-item">
            <div class="num">{{ pubStats.publishCount }}</div>
            <div class="label">求助</div>
          </div>
          <div class="p-divider"></div>
          <div class="p-stat-item">
            <div class="num">{{ pubStats.solveCount }}</div>
            <div class="label">解决</div>
          </div>
        </div>
      </div>

      <el-card
        v-if="task"
        shadow="never"
        class="detail-info-card"
        style="margin-top: 20px"
      >
        <div slot="header" class="clearfix">
          <span class="card-title">任务记录</span>
        </div>
        <el-timeline>
          <el-timeline-item
            :timestamp="task.createTime | formatDate"
            placement="top"
            color="#409eff"
            >发布了求助</el-timeline-item
          >
          <el-timeline-item
            v-if="task.orderTime"
            :timestamp="task.orderTime | formatDate"
            placement="top"
            color="#e6a23c"
          >
            {{ task.accept ? task.accept.username : "有同学" }} 接受了任务
          </el-timeline-item>
          <el-timeline-item
            v-if="task.endTime"
            :timestamp="task.endTime | formatDate"
            placement="top"
            color="#67c23a"
            >任务圆满完成</el-timeline-item
          >
        </el-timeline>
      </el-card>
    </el-col>
  </el-row>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";
import { listPublished, listAccepted } from "@/api/task/task";

export default {
  name: "TaskDetail",
  data() {
    return {
      taskId: null,
      task: null, // 初始必须为 null，配合 v-if 使用
      loading: true,
      baseUrl: "http://localhost:8080",
      userBgImg: require("@/assets/img/user_bg.jpg"),
      pubStats: { publishCount: 0, solveCount: 0 },
    };
  },
  computed: {
    ...mapState("user", ["user"]),

    // 是否是发布者本人
    isOwner() {
      if (!this.task || !this.user) return false;

      // 尝试从多个可能的路径获取发布者 ID
      // 1. 直接取 publishId
      // 2. 如果没有，尝试从 publish 对象里取 id
      const pubId =
        this.task.publishId ||
        (this.task.publish ? this.task.publish.id : null);

      if (!pubId) {
        console.error("错误：无法在 task 中找到发布者 ID，请检查后端字段");
        return false;
      }

      return String(pubId) === String(this.user.id);
    },

    // 是否是接单人本人
    isTaker() {
      if (!this.task || !this.user) return false;
      return (
        this.task.acceptUserId &&
        String(this.task.acceptUserId) === String(this.user.id)
      );
    },

    // 是否是普通访客
    isGuest() {
      // 只有当 [不是本人] 且 [不是接单人] 时才是路人
      return this.task && this.user && !this.isOwner && !this.isTaker;
    },

    statusText() {
      if (!this.task) return "";
      const dict = {
        0: "正在寻找帮助...",
        1: "互助进行中",
        2: "互助已圆满结束",
      };
      return dict[this.task.state];
    },
    statusIcon() {
      if (!this.task) return "";
      const dict = {
        0: "el-icon-search",
        1: "el-icon-loading",
        2: "el-icon-trophy",
      };
      return dict[this.task.state];
    },
  },
  created() {
    this.taskId = this.$route.params.id;
    if (this.taskId) {
      this.fetchTaskDetail();
    } else {
      this.$msg("无效的任务ID", "error");
      this.$router.back();
    }
  },
  methods: {
    // 异步逻辑：核心修复点
    fetchTaskDetail() {
      this.loading = true;
      this.$get("/task/" + this.taskId)
        .then((res) => {
          this.loading = false;
          if (res.data && res.data.status) {
            this.task = res.data.task;

            console.log(
              "当前登录用户ID:",
              this.user.id,
              "类型:",
              typeof this.user.id
            );
            console.log(
              "任务发布者ID:",
              this.task.publishId,
              "类型:",
              typeof this.task.publishId
            );
            console.log("是否判定为本人:", this.isOwner);
            // 数据成功返回后，再执行后续依赖逻辑
            if (this.task && this.task.publishId) {
              this.getPublisherStats(this.task.publishId);
            }
          } else {
            this.$msg(res.data.msg || "获取失败", "error");
          }
        })
        .catch((err) => {
          this.loading = false;
          console.error("Fetch Error:", err);
          this.$msg("服务器通信异常", "error");
        });
    },

    getPublisherStats(pubId) {
      // 这里的 .then 也要进行防御，防止接口返回不规范
      listPublished(pubId).then((res) => {
        const list = res.task || (res.data && res.data.task) || [];
        this.pubStats.publishCount = list.length;
      });
      listAccepted(pubId).then((res) => {
        const list = res.task || (res.data && res.data.task) || [];
        this.pubStats.solveCount = list.length;
      });
    },

    getResUrl(url) {
      if (!url) return "";
      return url.startsWith("http") ? url : this.baseUrl + url;
    },
    getSafeAvatar(u) {
      if (!u || !u.avatar) return null;
      return this.getResUrl(u.avatar);
    },
    getAvatarText(u) {
      if (!u || !u.username) return "校";
      return u.username.charAt(0).toUpperCase();
    },

    // 重点：接单逻辑
    handleAccept() {
      if (this.isOwner) {
        this.$msg("不能接取自己发布的任务", "warning");
        return;
      }
      this.$confirm("确定接受此求助吗？请确保您有充足的时间。", "接单提示", {
        type: "info",
      })
        .then(() => {
          // 使用 FormData 传参，匹配后端非 @RequestBody 接收
          let formData = new FormData();
          formData.append("id", this.taskId);
          formData.append("acceptId", this.user.id);

          this.$put("task/takerAccept", formData).then((res) => {
            if (res.data.status) {
              this.$msg("接单成功！", "success");
              this.$router.push("/home/help/accepted");
            } else {
              this.$msg(res.data.msg || "接单失败", "error");
            }
          });
        })
        .catch(() => {});
    },

    handleTakerCancel() {
      this.$confirm("确定取消接单吗？", "警告", { type: "warning" }).then(
        () => {
          this.$put("/task/takerCancel/" + this.task.id).then((res) => {
            if (res.data.status) {
              this.$msg("已取消接单", "info");
              this.fetchTaskDetail(); // 刷新状态
            }
          });
        }
      );
    },

    handleComplete() {
      this.$confirm("确认该互助已圆满完成吗？确认后不可撤销。", "确认完成", {
        type: "success",
      }).then(() => {
        this.$put("/task/" + this.task.id).then((res) => {
          if (res.data.status) {
            this.$msg("任务已结算，感谢您的互助！", "success");
            this.fetchTaskDetail();
          }
        });
      });
    },

    handleDelete() {
      this.$confirm("确定要下架并删除此求助吗？系统将退还10积分。", "提示", {
        type: "warning",
      }).then(() => {
        this.$del("/task/" + this.task.id).then((res) => {
          if (res.data.status) {
            this.$msg("已成功取消并退款", "success");
            this.$router.back();
          } else {
            this.$msg(res.data.msg, "error");
          }
        });
      });
    },
  },
  filters: {
    formatDate(time) {
      if (!time) return "";
      return formatDate(new Date(time), "yyyy-MM-dd hh:mm");
    },
  },
};
</script>

<style scoped lang="less">
/* 保持原有样式并微调 */
.main-layout-row {
  padding: 20px;
  max-width: 1300px;
  margin: 0 auto;
}
.detail-card {
  border-radius: 8px;
}
.status-banner {
  padding: 12px 20px;
  border-radius: 4px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  font-weight: bold;
}
.status-0 {
  background: #f0f9eb;
  color: #67c23a;
}
.status-1 {
  background: #fdf6ec;
  color: #e6a23c;
}
.status-2 {
  background: #f4f4f5;
  color: #909399;
}

.author-info {
  display: flex;
  align-items: center;
  margin-bottom: 25px;
  .author-text {
    .name {
      font-weight: bold;
      font-size: 16px;
      color: #303133;
    }
    .time {
      font-size: 12px;
      color: #909399;
      margin-top: 2px;
    }
  }
}

.post-main {
  .main-title {
    font-size: 24px;
    margin-bottom: 10px;
    color: #2c3e50;
  }
  .reward-badge {
    display: inline-block;
    padding: 4px 12px;
    background: #fff7e6;
    color: #fa8c16;
    border: 1px solid #ffd591;
    border-radius: 20px;
    font-size: 13px;
    margin-bottom: 20px;
  }
  .main-content {
    line-height: 1.8;
    font-size: 16px;
    white-space: pre-wrap;
    color: #4a4a4a;
    margin-bottom: 25px;
  }
}

.img-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  .detail-img {
    width: 160px;
    height: 160px;
    border-radius: 8px;
    cursor: zoom-in;
  }
}

.task-operations {
  padding: 30px 0;
  text-align: center;
  .op-box {
    max-width: 600px;
    margin: 0 auto;
    .op-tip {
      color: #909399;
      margin-bottom: 15px;
      font-size: 14px;
    }
    .btn-group {
      margin-top: 20px;
    }
  }
}

.profile-card {
  overflow: hidden;
  background: #fff;
  border-radius: 8px;
  border: 1px solid #ebeef5;
  .profile-bg {
    height: 80px;
    background-position: center;
    background-size: cover;
  }
  .profile-content {
    text-align: center;
    margin-top: -35px;
    padding-bottom: 15px;
    border-bottom: 1px solid #f0f0f0;
    .avatar-wrap {
      display: inline-block;
      padding: 3px;
      background: #fff;
      border-radius: 50%;
    }
    .user-name {
      font-size: 18px;
      font-weight: bold;
      margin-top: 5px;
    }
    .user-role {
      font-size: 12px;
      color: #909399;
    }
    .user-bio {
      font-size: 13px;
      color: #606266;
      padding: 0 15px;
      margin-top: 8px;
    }
  }
  .profile-stats {
    display: flex;
    padding: 15px 0;
    .p-stat-item {
      flex: 1;
      text-align: center;
    }
    .p-divider {
      width: 1px;
      height: 20px;
      background: #eee;
    }
    .num {
      font-weight: bold;
      font-size: 16px;
    }
    .label {
      font-size: 12px;
      color: #999;
    }
  }
}
.title-row {
  display: flex;
  justify-content: space-between; /* 关键：让子元素分居左右两端 */
  align-items: center;           /* 垂直居中对居 */
  width: 100%;                   /* 确保占满整行 */
  margin-bottom: 20px;           /* 根据你的页面调整间距 */

  .main-title {
    margin: 0;                   /* 去除标题默认的外边距，防止对齐歪掉 */
    flex: 1;                     /* 让标题占据剩余空间 */
    font-size: 24px;
    font-weight: bold;
    color: #303133;
  }

  .owner-actions {
    flex-shrink: 0;              /* 防止按钮被挤压换行 */
    margin-left: 20px;           /* 如果标题太长，留出一点空隙 */
  }
}

.delete-btn {
  color: #f56c6c;
  font-size: 14px;               /* 按钮文字稍微小一点更精致 */
  &:hover {
    color: #ff7875;
  }
}
</style>
