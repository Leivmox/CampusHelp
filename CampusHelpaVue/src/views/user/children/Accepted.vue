<template>
  <div class="content">
    <el-alert
      title="我接受的求助 - 请秉持诚信、友好的态度协助同学解决问题"
      :closable="false"
      type="warning"
      style="margin-bottom: 10px"
    ></el-alert>

    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold">我的服务进度</span>
        <el-button
          style="float: right; padding: 3px 0"
          type="text"
          icon="el-icon-refresh"
          @click="loadAcceptedTasks"
          >刷新</el-button
        >
      </div>

      <div v-if="acceptedTasks.length > 0">
        <div v-for="item in acceptedTasks" :key="item.id" class="accepted-item">
          <div class="item-wrapper" @click="goToDetail(item.id)">
            <div class="item-header">
              <div class="status-tags">
                <el-tag
                  v-if="item.state == 1"
                  type="warning"
                  effect="dark"
                  size="small"
                  >互助中</el-tag
                >
                <el-tag v-else type="info" effect="dark" size="small"
                  >已完成</el-tag
                >
              </div>

              <h4 class="title" :class="{ 'text-muted': item.state == 2 }">
                {{ item.taskTitle }}
              </h4>
              <span class="order-time"
                >{{ item.orderTime | formatDate }} 接单</span
              >
            </div>

            <div class="item-body">
              <div
                class="image-box"
                v-if="item.imgList && item.imgList.length > 0"
              >
                <el-image
                  :src="getResUrl(item.imgList[0])"
                  fit="cover"
                  class="side-img"
                ></el-image>
                <div class="img-badge" v-if="item.imgList.length > 1">
                  {{ item.imgList.length }}图
                </div>
              </div>
              <div class="text-content">
                <p class="summary">{{ item.taskContext }}</p>
              </div>
            </div>

            <div class="item-footer-info">
              <div class="publisher">
                <span class="user-info">
                  <i class="el-icon-user"></i>
                  求助者:
                  {{ item.publish ? item.publish.username : "未知用户" }}
                </span>
              </div>
            </div>
          </div>

          <div class="action-bar" v-if="item.state == 1">
            <span class="tip"
              ><i class="el-icon-info"></i> 无法解决请及时沟通并取消</span
            >
            <el-button
              type="danger"
              size="mini"
              plain
              icon="el-icon-circle-close"
              @click.stop="cancelAccept(item.id)"
              >取消接单</el-button
            >
          </div>

          <el-divider></el-divider>
        </div>
      </div>
      <el-empty v-else description="您目前还没有接受任何求助"></el-empty>
    </el-card>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";

export default {
  name: "AcceptedTasks",
  data() {
    return {
      acceptedTasks: [],
      baseUrl: "http://localhost:8080",
    };
  },
  computed: { ...mapState("user", ["user"]) },
  methods: {
    getResUrl(url) {
      if (!url) return "";
      return url.startsWith("http") ? url : this.baseUrl + url;
    },
    goToDetail(id) {
      this.$router.push({ name: "TaskDetail", params: { id: id } });
    },
    loadAcceptedTasks() {
      this.$get("/task/accepted", { id: this.user.id }).then((res) => {
        if (res.data.status) {
          let list = res.data.task;
          list.forEach((item) => {
            if (item.imgUrl) item.imgList = item.imgUrl.split(",");
          });

          // 排序逻辑：
          this.acceptedTasks = list.sort((a, b) => {
            // 1. 状态排序 (state=1 是互助中，state=2 是已完成)
            // 升序排列：1 会排在 2 之前
            if (a.state !== b.state) {
              return a.state - b.state;
            }

            // 2. 时间排序 (状态相同时，按接单时间倒序)
            // 使用 orderTime 或 createTime，取决于你想按哪个时间排
            const timeA = new Date(a.orderTime).getTime();
            const timeB = new Date(b.orderTime).getTime();
            return timeB - timeA; // 晚的时间戳更大，排在前面
          });
        }
      });
    },
    cancelAccept(taskId) {
      this.$confirm("确定要取消此项求助的接单吗？", "提示", {
        type: "warning",
      })
        .then(() => {
          this.$put("task/takerCancel/" + taskId).then((res) => {
            if (res.data.status) {
              this.$msg("已成功取消接单", "success");
              this.loadAcceptedTasks();
            }
          });
        })
        .catch(() => {});
    },
  },
  created() {
    this.loadAcceptedTasks();
  },
  filters: {
    formatDate(time) {
      return formatDate(new Date(time), "yyyy-MM-dd hh:mm");
    },
  },
};
</script>

<style scoped lang="less">
.content {
  padding: 10px 0;
}

.accepted-item {
  .item-wrapper {
    cursor: pointer;
    padding: 12px;
    transition: background 0.2s;
    border-radius: 8px;
    &:hover {
      background: #f8f9fa;
    }
  }

  // 第一部分：标题行
  .item-header {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
    gap: 10px;

    .title {
      margin: 0;
      font-size: 16px;
      color: #333;
      flex: 1;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .text-muted {
      color: #999;
      text-decoration: line-through;
    }
    .order-time {
      font-size: 12px;
      color: #999;
      flex-shrink: 0;
    }
  }

  // 第二部分：图左文右
  .item-body {
    display: flex;
    align-items: flex-start;
    margin-bottom: 12px;

    .image-box {
      position: relative;
      margin-right: 15px;
      flex-shrink: 0;

      .side-img {
        width: 100px;
        height: 75px;
        border-radius: 6px;
        border: 1px solid #f0f0f0;
      }
      .img-badge {
        position: absolute;
        bottom: 4px;
        right: 4px;
        background: rgba(0, 0, 0, 0.6);
        color: white;
        font-size: 10px;
        padding: 1px 4px;
        border-radius: 3px;
      }
    }

    .text-content {
      flex: 1;
      .summary {
        font-size: 14px;
        color: #666;
        line-height: 1.5;
        margin: 0;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 3; // 最多显示3行
        overflow: hidden;
      }
    }
  }

  // 第三部分：求助者信息
.item-footer-info {
  margin-bottom: 10px;
  
  .publisher {
    display: flex;
    align-items: center;

    .user-info {
      font-size: 13px;
      color: #606266;
      display: flex;
      align-items: center;

      i {
        margin-right: 4px;
        font-size: 14px; // 图标稍微大一点点更清晰
        color: #409eff; // 保留你之前的蓝色调
      }
    }
  }
}

  // 操作提示栏
  .action-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 12px;
    background: #fffcf5;
    border-radius: 6px;
    border: 1px solid #fdf6ec;

    .tip {
      font-size: 12px;
      color: #e6a23c;
    }
  }

  .el-divider--horizontal {
    margin: 15px 0 5px 0;
  }
}
</style>
