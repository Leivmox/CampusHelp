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
          <div class="task-main-wrapper">
            <div class="task-info-side">
              <div class="task-header">
                <div class="title-wrapper">
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

                  <span
                    class="task-title"
                    :class="{ solved: item.state == 2 }"
                    >{{ item.taskTitle }}</span
                  >
                </div>
              </div>

              <div class="task-content">{{ item.taskContext }}</div>

              <div class="task-footer">
                <span class="user-info"
                  ><i class="el-icon-user-solid"></i>
                  {{ item.publish.username }}</span
                >
                <span class="time-info">{{
                  item.createTime | formatDate
                }}</span>
              </div>
            </div>

            <div
              class="task-cover"
              v-if="item.imgList && item.imgList.length > 0"
            >
              <el-image
                :src="getResUrl(item.imgList[0])"
                fit="cover"
                style="width: 120px; height: 90px; border-radius: 6px"
              ></el-image>
              <div class="img-count" v-if="item.imgList.length > 1">
                <i class="el-icon-picture"></i> {{ item.imgList.length }}
              </div>
            </div>
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
      // 1. 如果状态是 0 (待接取)，所有人都可以进入
      if (item.state == 0) {
        this.$router.push({ name: "TaskDetail", params: { id: item.id } });
        return;
      }

      // 2. 如果状态是 1 (互助中) 或 2 (已完成)
      // 判断当前登录用户 ID 是否等于发布者 ID 或 接取者 ID
      const currentUserId = String(this.user.id);
      const publishId = String(item.publish ? item.publish.id : "");
      const acceptUserId = String(item.accept ? item.accept.id : "");

      if (currentUserId === publishId || currentUserId === acceptUserId) {
        // 是相关人员，允许进入
        this.$router.push({ name: "TaskDetail", params: { id: item.id } });
      } else {
        // 非相关人员，弹出提示
        this.$message({
          message: "该求助已在处理中或已完成，仅相关参与人员可查看详情",
          type: "warning",
        });
      }
    },
    loadTasks() {
      this.$get("/task", { id: this.user.id }).then((res) => {
        let list = res.data.task;
        list.forEach((item) => {
          if (item.imgUrl) item.imgList = item.imgUrl.split(",");
        });
        // 排序逻辑：待解决(0) > 互助中(1) > 已完成(2)，且同状态按时间倒序
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
/* 保持一致的列表样式 */
.task-item {
  padding: 10px 0;
  cursor: pointer;
  transition: all 0.2s;
  &:hover {
    background-color: #fafafa;
  }
  .task-main-wrapper {
    display: flex;
    justify-content: space-between;
    .task-info-side {
      flex: 1;
      padding-right: 15px;
    }
    .task-cover {
      position: relative;
      flex-shrink: 0;
      .img-count {
        position: absolute;
        right: 5px;
        bottom: 5px;
        background: rgba(0, 0, 0, 0.5);
        color: #fff;
        padding: 2px 6px;
        border-radius: 4px;
        font-size: 11px;
      }
    }
  }
  .task-header {
    margin-bottom: 8px;
    .task-title {
      font-size: 16px;
      font-weight: bold;
      &.solved {
        color: #909399;
        text-decoration: line-through;
      }
    }
  }
  .task-content {
    font-size: 14px;
    color: #606266;
    line-height: 1.5;
    margin-bottom: 12px;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    overflow: hidden;
  }
  .task-footer {
    display: flex;
    gap: 15px;
    font-size: 13px;
    color: #909399;
  }
}
</style>
