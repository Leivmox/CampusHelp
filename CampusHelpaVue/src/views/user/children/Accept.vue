<template>
  <div class="content">
    <el-alert
      :title="user.school.name + ' - 互助平台共 ' + tasks.length + ' 个求助'"
      :closable="false"
      type="info"
      style="margin-bottom: 10px"
    >
    </el-alert>

    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold">求助广场</span>
        <el-button
          style="float: right; padding: 3px 0; font-size: 14px"
          type="text"
          icon="el-icon-refresh"
          @click="loadTasks"
          >刷新</el-button
        >
      </div>

      <div v-if="tasks.length > 0">
        <div
          v-for="item in tasks"
          :key="item.id"
          class="task-item"
          @click="goToDetail(item)"
        >
          <div class="task-header">
            <el-tag
              v-if="item.state == 0"
              type="success"
              size="small"
              effect="dark"
              style="margin-right: 8px"
              >待接取</el-tag
            >
            <el-tag
              v-else-if="item.state == 1"
              type="warning"
              size="small"
              effect="dark"
              style="margin-right: 8px"
              >互助中</el-tag
            >
            <el-tag
              v-else
              type="info"
              size="small"
              effect="dark"
              style="margin-right: 8px"
              >已完成</el-tag
            >
            <span class="task-title" :class="{ solved: item.state == 2 }">
              {{ item.taskTitle }}
            </span>
          </div>

          <div class="task-body">
            <div
              class="task-cover"
              v-if="item.imgList && item.imgList.length > 0"
            >
              <el-image
                :src="getResUrl(item.imgList[0])"
                fit="cover"
                style="width: 110px; height: 80px; border-radius: 6px"
              ></el-image>
              <div class="img-count" v-if="item.imgList.length > 1">
                <i class="el-icon-picture"></i> {{ item.imgList.length }}
              </div>
            </div>
            <div class="task-content">
              {{ item.taskContext }}
            </div>
          </div>

          <div class="task-footer">
            <span class="user-info">
              <i class="el-icon-user-solid"></i>
              {{ item.publish ? item.publish.username : "未知用户" }}
            </span>
            <span class="time-info">
              <i class="el-icon-time"></i>
              {{ item.createTime | formatDate }}
            </span>
          </div>

          <el-divider></el-divider>
        </div>
      </div>
      <el-empty v-else description="暂时没有求助任务，休息一下吧~"></el-empty>
    </el-card>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";

export default {
  name: "TaskIndex",
  data() {
    return {
      tasks: [],
      baseUrl: "http://localhost:8080",
    };
  },
  computed: { ...mapState("user", ["user"]) },
  methods: {
    getResUrl(url) {
      if (!url) return "";
      return url.startsWith("http") ? url : this.baseUrl + url;
    },
    goToDetail(item) {
      if (item.state == 0) {
        this.$router.push({ name: "TaskDetail", params: { id: item.id } });
        return;
      }
      const currentUserId = String(this.user.id);
      const publishId = String(item.publish ? item.publish.id : "");
      const acceptUserId = String(item.accept ? item.accept.id : "");

      if (currentUserId === publishId || currentUserId === acceptUserId) {
        this.$router.push({ name: "TaskDetail", params: { id: item.id } });
      } else {
        this.$message.warning("该求助已在处理中或已完成，仅相关参与人员可查看详情");
      }
    },
    loadTasks() {
      this.$get("/task", { id: this.user.id }).then((res) => {
        let list = res.data.task || [];
        list.forEach((item) => {
          if (item.imgUrl) item.imgList = item.imgUrl.split(",");
        });
        this.tasks = list.sort((a, b) => {
          if (a.state === b.state)
            return new Date(b.createTime) - new Date(a.createTime);
          return a.state - b.state;
        });
      });
    },
  },
  created() {
    this.loadTasks();
  },
  filters: {
    formatDate(time) {
      return formatDate(new Date(time), "yyyy-MM-dd hh:mm");
    },
  },
};
</script>

<style scoped lang="less">
.task-item {
  padding: 15px 10px 5px 10px;
  cursor: pointer;
  transition: all 0.2s;
  
  &:hover {
    background-color: #f9f9f9;
  }

  // 标题样式
  .task-header {
    margin-bottom: 12px;
    display: flex;
    align-items: center;

    .task-title {
      font-size: 17px;
      font-weight: bold;
      color: #303133;
      // 标题太长时显示省略号
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;

      &.solved {
        color: #909399;
        text-decoration: line-through;
      }
    }
  }

  // 中间主体：图片左，文字右
  .task-body {
    display: flex;
    align-items: flex-start;
    margin-bottom: 12px;

    .task-cover {
      position: relative;
      flex-shrink: 0;
      margin-right: 15px; // 图片与文字的间距

      .img-count {
        position: absolute;
        right: 4px;
        bottom: 4px;
        background: rgba(0, 0, 0, 0.6);
        color: #fff;
        padding: 1px 5px;
        border-radius: 3px;
        font-size: 10px;
      }
    }

    .task-content {
      flex: 1;
      font-size: 14px;
      color: #606266;
      line-height: 1.6;
      // 限制内容高度，最多显示3行
      display: -webkit-box;
      -webkit-box-orient: vertical;
      -webkit-line-clamp: 3;
      overflow: hidden;
    }
  }

  // 底部样式
  .task-footer {
    display: flex;
    justify-content: flex-start;
    gap: 20px;
    font-size: 12px;
    color: #999;

    .user-info i, .time-info i {
      margin-right: 4px;
    }
  }

  .el-divider--horizontal {
    margin: 15px 0 0 0;
  }
}
</style>