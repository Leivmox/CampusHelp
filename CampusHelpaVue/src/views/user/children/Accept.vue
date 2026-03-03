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
        <div style="float: right; display: flex; align-items: center; gap: 10px;">
          <el-select v-model="sortType" size="small" style="width: 110px" @change="sortTasks">
            <el-option label="时间排序" value="time"></el-option>
            <el-option label="积分排序" value="reward"></el-option>
          </el-select>
          <el-button
            :type="sortOrder === 'desc' ? 'primary' : 'default'"
            size="small"
            :icon="sortOrder === 'desc' ? 'el-icon-sort-down' : 'el-icon-sort-up'"
            @click="toggleSortOrder"
          >
            {{ sortOrder === 'desc' ? '降序' : '升序' }}
          </el-button>
          <el-button
            type="text"
            icon="el-icon-refresh"
            @click="loadTasks"
          >刷新</el-button>
        </div>
      </div>

      <div v-if="sortedTasks.length > 0">
        <div
          v-for="item in sortedTasks"
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
            <span class="task-reward">
              <i class="el-icon-coin"></i>
              {{ item.reward || 10 }}积分
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
      sortType: "time",
      sortOrder: "desc"
    };
  },
  computed: {
    ...mapState("user", ["user"]),
    sortedTasks() {
      return this.sortTasks();
    }
  },
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
          if (!item.reward) item.reward = 10;
        });
        this.tasks = list;
      });
    },
    toggleSortOrder() {
      this.sortOrder = this.sortOrder === 'desc' ? 'asc' : 'desc';
    },
    sortTasks() {
      let list = [...this.tasks];
      
      if (this.sortType === 'time') {
        list.sort((a, b) => {
          if (a.state === b.state) {
            const timeA = new Date(a.createTime).getTime();
            const timeB = new Date(b.createTime).getTime();
            return this.sortOrder === 'desc' ? timeB - timeA : timeA - timeB;
          }
          return a.state - b.state;
        });
      } else if (this.sortType === 'reward') {
        list.sort((a, b) => {
          if (a.state === b.state) {
            const rewardA = a.reward || 10;
            const rewardB = b.reward || 10;
            return this.sortOrder === 'desc' ? rewardB - rewardA : rewardA - rewardB;
          }
          return a.state - b.state;
        });
      }
      
      return list;
    }
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

  .task-header {
    margin-bottom: 12px;
    display: flex;
    align-items: center;

    .task-title {
      font-size: 17px;
      font-weight: bold;
      color: #303133;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      flex: 1;

      &.solved {
        color: #909399;
        text-decoration: line-through;
      }
    }

    .task-reward {
      font-size: 14px;
      color: #ff7d00;
      font-weight: 600;
      margin-left: 12px;
      flex-shrink: 0;
      
      i {
        margin-right: 4px;
      }
    }
  }

  .task-body {
    display: flex;
    align-items: flex-start;
    margin-bottom: 12px;

    .task-cover {
      position: relative;
      flex-shrink: 0;
      margin-right: 15px;

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
      display: -webkit-box;
      -webkit-box-orient: vertical;
      -webkit-line-clamp: 3;
      overflow: hidden;
    }
  }

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
