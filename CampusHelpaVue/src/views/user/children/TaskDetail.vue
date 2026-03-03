<template>
  <el-row :gutter="20" class="main-layout-row">
    <el-col :xs="24" :sm="24" :md="16" :lg="17">
      <el-card shadow="never" class="detail-card">
        <div slot="header" class="clearfix">
          <el-page-header @back="$router.back()" content="求助详情"></el-page-header>
        </div>

        <div v-if="loading" class="loading-box">
          <i class="el-icon-loading"></i> 数据加载中...
        </div>

        <div v-else-if="task" class="task-content">
          <div class="status-banner" :class="'status-' + task.state">
            <i :class="statusIcon"></i>
            <span>{{ statusText }}</span>
            <span class="reward-tag">
              <i class="el-icon-coin"></i> 悬赏 {{ task.reward || 10 }} 积分
            </span>
          </div>

          <div class="task-header">
            <div class="task-title">{{ task.taskTitle }}</div>
            <div class="task-meta">
              <i class="el-icon-time"></i> {{ task.createTime | formatDate }}
            </div>
          </div>

          <div class="task-body">
            <div class="task-context">{{ task.taskContext }}</div>
            
            <div class="task-images" v-if="task.imgList && task.imgList.length > 0">
              <div class="images-label">图片附件 ({{ task.imgList.length }}张)</div>
              <div class="images-grid">
                <el-image
                  v-for="(img, idx) in task.imgList"
                  :key="idx"
                  :src="getResUrl(img)"
                  :preview-src-list="task.imgList.map((url) => getResUrl(url))"
                  fit="cover"
                  class="task-img"
                ></el-image>
              </div>
            </div>
          </div>

          <div class="task-timeline">
            <div class="timeline-title">任务进度</div>
            <el-timeline>
              <el-timeline-item :timestamp="task.createTime | formatDate" placement="top" color="#409eff">
                发布了求助
              </el-timeline-item>
              <el-timeline-item v-if="task.orderTime" :timestamp="task.orderTime | formatDate" placement="top" color="#e6a23c">
                {{ task.accept ? task.accept.username : "有同学" }} 接受了任务
              </el-timeline-item>
              <el-timeline-item v-if="task.endTime" :timestamp="task.endTime | formatDate" placement="top" color="#67c23a">
                任务圆满完成
              </el-timeline-item>
            </el-timeline>
          </div>

          <div class="accepter-section" v-if="task.accept && task.state >= 1">
            <div class="section-title">接单者信息</div>
            <div class="accepter-info">
              <el-avatar :size="40" :src="getSafeAvatar(task.accept)" style="background-color: #67c23a; color: #fff;">
                {{ getAvatarText(task.accept) }}
              </el-avatar>
              <div class="accepter-text">
                <div class="accepter-name">{{ task.accept.username }}</div>
                <div class="accepter-meta" v-if="task.accept.school">
                  <i class="el-icon-school"></i> {{ task.accept.school.name }}
                </div>
              </div>
            </div>
          </div>

          <div class="task-operations">
            <div v-if="isGuest && task.state === 0" class="op-box">
              <el-alert title="您可以帮助这位同学解决问题" type="info" :closable="false" show-icon></el-alert>
              <div class="op-btn-group">
                <el-button type="primary" size="large" icon="el-icon-check" @click="handleAccept">
                  接受求助
                </el-button>
              </div>
            </div>

            <div v-else-if="isTaker && task.state === 1" class="op-box">
              <el-alert title="互助进行中：请联系发布者提供帮助" type="warning" :closable="false" show-icon></el-alert>
              <div class="op-btn-group">
                <el-button type="primary" icon="el-icon-chat-dot-round" @click="toChat(task.publish.id)">
                  联系发布者
                </el-button>
                <el-button type="danger" plain @click="handleTakerCancel">取消接单</el-button>
              </div>
            </div>

            <div v-else-if="isOwner && task.state === 1" class="op-box">
              <el-alert title="帮助者已就绪：如果问题已解决，请务必确认完成" type="info" :closable="false" show-icon></el-alert>
              <div class="op-btn-group">
                <el-button type="primary" icon="el-icon-chat-dot-round" @click="toChat(task.accept ? task.accept.id : task.acceptId)">
                  联系接单人
                </el-button>
                <el-button type="success" icon="el-icon-circle-check" @click="handleComplete">
                  确认解决
                </el-button>
              </div>
            </div>

            <div v-else-if="task.state === 2" class="op-box completed">
              <el-result icon="success" title="任务已完成" subTitle="感谢校友间的互帮互助"></el-result>
            </div>

            <div v-if="isOwner && task.state === 0" class="owner-actions">
              <el-button type="primary" plain icon="el-icon-edit" @click="handleEdit">
                修改求助
              </el-button>
              <el-button type="danger" plain icon="el-icon-delete" @click="handleDelete">
                取消并下架
              </el-button>
            </div>
          </div>
        </div>

        <el-empty v-else description="抱歉，该求助信息不存在或已被删除"></el-empty>
      </el-card>
    </el-col>

    <el-col :xs="24" :sm="24" :md="8" :lg="7">
      <el-card shadow="never" class="publisher-card">
        <div slot="header">
          <span>发布者信息</span>
        </div>
        <div v-if="task && task.publish" class="publisher-info">
          <div class="publisher-avatar">
            <el-avatar :size="60" :src="getSafeAvatar(task.publish)" style="background-color: #409eff; color: #fff;">
              {{ getAvatarText(task.publish) }}
            </el-avatar>
          </div>
          <div class="publisher-name">{{ task.publish.username }}</div>
          <div class="publisher-school" v-if="task.publish.school">
            <i class="el-icon-school"></i> {{ task.publish.school.name }}
          </div>
          <div class="publisher-signature" v-if="task.publish.signature">
            {{ task.publish.signature }}
          </div>
          <el-divider></el-divider>
          <div class="publisher-stats">
            <div class="stat-item">
              <div class="stat-num" style="color: #ff9900;">{{ task.publish.balance || 0 }}</div>
              <div class="stat-label">积分</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <div class="stat-num">{{ pubStats.publishCount }}</div>
              <div class="stat-label">发布</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <div class="stat-num">{{ pubStats.solveCount }}</div>
              <div class="stat-label">解决</div>
            </div>
          </div>
          <div class="publisher-actions" v-if="!isOwner">
            <el-button type="primary" size="small" icon="el-icon-chat-dot-round" @click="toChat(task.publish.id)" block>
              私信联系
            </el-button>
          </div>
        </div>
        <el-empty v-else description="暂无发布者信息" :image-size="60"></el-empty>
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
      task: null,
      loading: true,
      baseUrl: "http://localhost:8080",
      pubStats: { publishCount: 0, solveCount: 0 },
    };
  },
  computed: {
    ...mapState("user", ["user"]),

    isOwner() {
      if (!this.task || !this.user) return false;
      const pubId = this.task.publishId || (this.task.publish ? this.task.publish.id : null);
      if (!pubId) return false;
      return String(pubId) === String(this.user.id);
    },

    isTaker() {
      if (!this.task || !this.user) return false;
      const takerId = (this.task.accept ? this.task.accept.id : null) || this.task.acceptId || this.task.acceptUserId;
      if (!takerId) return false;
      return String(takerId) === String(this.user.id);
    },

    isGuest() {
      return this.task && this.user && !this.isOwner && !this.isTaker;
    },

    statusText() {
      if (!this.task) return "";
      const dict = { 0: "正在寻找帮助...", 1: "互助进行中", 2: "互助已圆满结束" };
      return dict[this.task.state];
    },
    
    statusIcon() {
      if (!this.task) return "";
      const dict = { 0: "el-icon-search", 1: "el-icon-loading", 2: "el-icon-trophy" };
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
    toChat(targetUserId) {
      if (!targetUserId) {
        this.$msg("无法获取对方信息", "error");
        return;
      }
      if (targetUserId === this.user.id) {
        this.$msg("不能和自己聊天哦", "warning");
        return;
      }
      this.$router.push({ path: "/home/chat/detail", query: { toUser: targetUserId } });
    },

    fetchTaskDetail() {
      this.loading = true;
      this.$get("/task/" + this.taskId)
        .then((res) => {
          this.loading = false;
          if (res.data && res.data.status) {
            this.task = res.data.task;
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

    handleAccept() {
      if (this.isOwner) {
        this.$msg("不能接取自己发布的任务", "warning");
        return;
      }
      this.$confirm("确定接受此求助吗？请确保您有充足的时间。", "接单提示", { type: "info" })
        .then(() => {
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
      this.$confirm("确定取消接单吗？", "警告", { type: "warning" }).then(() => {
        this.$put("/task/takerCancel/" + this.task.id).then((res) => {
          if (res.data.status) {
            this.$msg("已取消接单", "info");
            this.fetchTaskDetail();
          }
        });
      });
    },

    handleComplete() {
      this.$confirm("确认该互助已圆满完成吗？确认后不可撤销。", "确认完成", { type: "success" }).then(() => {
        this.$put("/task/" + this.task.id).then((res) => {
          if (res.data.status) {
            this.$msg("任务已结算，感谢您的互助！", "success");
            this.fetchTaskDetail();
          }
        });
      });
    },

    handleDelete() {
      const reward = this.task.reward || 10;
      this.$confirm(`确定要下架并删除此求助吗？系统将退还 ${reward} 积分。`, "提示", { type: "warning" }).then(() => {
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

    handleEdit() {
      this.$router.push({ path: "/home/help/task", query: { edit: this.task.id } });
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
.main-layout-row {
  padding: 20px 0;
  margin: 0 auto;
}

.detail-card {
  border-radius: 8px;
  border: 1px solid #ebeef5;
}

.loading-box {
  text-align: center;
  padding: 50px;
  color: #909399;
}

.status-banner {
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  font-weight: bold;
  font-size: 15px;

  .reward-tag {
    margin-left: auto;
    background: rgba(255, 255, 255, 0.3);
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 13px;
    
    i {
      margin-right: 4px;
    }
  }
}

.status-0 {
  background: linear-gradient(135deg, #f0f9eb 0%, #e1f3d8 100%);
  color: #67c23a;
}

.status-1 {
  background: linear-gradient(135deg, #fdf6ec 0%, #faecd8 100%);
  color: #e6a23c;
}

.status-2 {
  background: linear-gradient(135deg, #f4f4f5 0%, #e9e9eb 100%);
  color: #909399;
}

.task-content {
  padding: 0;
}

.task-header {
  margin-bottom: 20px;
  
  .task-title {
    font-size: 22px;
    font-weight: 600;
    color: #303133;
    margin-bottom: 10px;
    line-height: 1.4;
  }

  .task-meta {
    font-size: 13px;
    color: #909399;
    
    i {
      margin-right: 4px;
    }
  }
}

.task-body {
  margin-bottom: 20px;
  
  .task-context {
    font-size: 16px;
    color: #4e5969;
    line-height: 1.8;
    white-space: pre-wrap;
    margin-bottom: 20px;
  }

  .task-images {
    .images-label {
      font-size: 14px;
      font-weight: 500;
      color: #1d2129;
      margin-bottom: 12px;
    }

    .images-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;

      .task-img {
        width: 140px;
        height: 140px;
        border-radius: 4px;
        cursor: zoom-in;
      }
    }
  }
}

.task-timeline {
  margin-bottom: 20px;
  
  .timeline-title {
    font-weight: bold;
    border-left: 4px solid #409eff;
    padding-left: 10px;
    margin-bottom: 15px;
  }
}

.accepter-section {
  margin-bottom: 20px;
  
  .section-title {
    font-weight: bold;
    border-left: 4px solid #67c23a;
    padding-left: 10px;
    margin-bottom: 15px;
  }

  .accepter-info {
    display: flex;
    align-items: center;
    gap: 12px;

    .accepter-text {
      .accepter-name {
        font-size: 16px;
        font-weight: 500;
        color: #303133;
      }

      .accepter-meta {
        font-size: 13px;
        color: #909399;
        margin-top: 3px;

        i {
          margin-right: 4px;
        }
      }
    }
  }
}

.task-operations {
  margin-top: 20px;
  
  .op-box {
    padding: 20px;
    background: #f7f8fa;
    border-radius: 8px;
    text-align: center;

    .op-btn-group {
      margin-top: 15px;
      display: flex;
      justify-content: center;
      gap: 12px;
    }
  }

  .owner-actions {
    margin-top: 20px;
    text-align: center;
  }
}

.publisher-card {
  border-radius: 8px;
  border: 1px solid #ebeef5;
  position: sticky;
  top: 70px;

  .publisher-info {
    text-align: center;

    .publisher-avatar {
      margin-bottom: 12px;
    }

    .publisher-name {
      font-size: 18px;
      font-weight: 600;
      color: #303133;
      margin-bottom: 8px;
    }

    .publisher-school {
      font-size: 13px;
      color: #909399;
      margin-bottom: 8px;
      
      i {
        margin-right: 4px;
      }
    }

    .publisher-signature {
      font-size: 13px;
      color: #606266;
      background: #f7f8fa;
      padding: 10px;
      border-radius: 6px;
      margin-bottom: 10px;
      line-height: 1.5;
    }

    .publisher-stats {
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 15px;

      .stat-item {
        text-align: center;
        min-width: 50px;

        .stat-num {
          font-size: 18px;
          font-weight: 600;
          color: #303133;
        }

        .stat-label {
          font-size: 12px;
          color: #909399;
          margin-top: 2px;
        }
      }

      .stat-divider {
        width: 1px;
        height: 25px;
        background: #dcdfe6;
        margin: 0 10px;
      }
    }

    .publisher-actions {
      .el-button {
        width: 100%;
      }
    }
  }
}

@media (max-width: 992px) {
  .main-layout-row {
    .el-col {
      margin-bottom: 20px;
    }
  }

  .publisher-card {
    position: static;
  }
}
</style>
