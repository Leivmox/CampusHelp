<template>
  <div class="content">
    <el-alert
      title="我接受的求助 - 请秉持诚信、友好的态度协助同学解决问题"
      :closable="false"
      type="warning"
      style="margin-bottom: 10px;"
    ></el-alert>

    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold;">我的服务进度</span>
        <el-button style="float: right; padding: 3px 0;" type="text" icon="el-icon-refresh" @click="loadAcceptedTasks">刷新</el-button>
      </div>

      <div v-if="acceptedTasks.length > 0">
        <div v-for="item in acceptedTasks" :key="item.id" class="accepted-item">
          
          <div class="item-main" @click="goToDetail(item.id)">
            <div class="status-bar">
              <el-tag v-if="item.state == 1" type="warning" effect="dark" size="small">互助中</el-tag>
              <el-tag v-else type="info" effect="dark" size="small">已完成</el-tag>
              <span class="order-time">接单时间: {{ item.orderTime | formatDate }}</span>
            </div>

            <div class="item-body">
              <div class="text-info">
                <h4 class="title" :class="{ 'text-muted': item.state == 2 }">{{ item.taskTitle }}</h4>
                <p class="summary">{{ item.taskContext }}</p>
                <div class="publisher">
                  <el-avatar :size="20" icon="el-icon-user" style="margin-right: 5px"></el-avatar>
                  <span>求助者: {{ item.publish.username }}</span>
                </div>
              </div>
              
              <div class="image-box" v-if="item.imgList && item.imgList.length > 0">
                <el-image :src="getResUrl(item.imgList[0])" fit="cover" class="side-img"></el-image>
              </div>
            </div>
          </div>

          <div class="item-footer" v-if="item.state == 1">
            <span class="tip"><i class="el-icon-info"></i> 如果无法解决，请及时沟通并取消接单</span>
            <el-button 
              type="danger" 
              size="mini" 
              plain 
              icon="el-icon-circle-close" 
              @click.stop="cancelAccept(item.id)"
            >取消接单</el-button>
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
      baseUrl: "http://localhost:8080"
    };
  },
  computed: { ...mapState("user", ["user"]) },
  methods: {
    getResUrl(url) {
      if (!url) return "";
      return url.startsWith("http") ? url : this.baseUrl + url;
    },
    goToDetail(id) {
      this.$router.push({ name: 'TaskDetail', params: { id: id } });
    },
    loadAcceptedTasks() {
      // 假设后端接口为 /task/accepted?id=xxx
      this.$get("/task/accepted", { id: this.user.id }).then((res) => {
        if (res.data.status) {
          let list = res.data.task;
          list.forEach(item => {
            if (item.imgUrl) item.imgList = item.imgUrl.split(",");
          });
          // 互助中的排在最上面
          this.acceptedTasks = list.sort((a, b) => a.state - b.state);
        }
      });
    },
    cancelAccept(taskId) {
      this.$confirm("确定要取消此项求助的接单吗？这可能会影响您的信誉。", "提示", {
        confirmButtonText: "确定取消",
        cancelButtonText: "点错了",
        type: 'warning'
      }).then(() => {
        // 调用后端取消接单接口
        this.$put("task/takerCancel/" + taskId).then((res) => {
          if (res.data.status) {
            this.$msg("已成功取消接单", "success");
            this.loadAcceptedTasks(); // 重新加载列表
          }
        });
      }).catch(() => {});
    }
  },
  created() { this.loadAcceptedTasks(); },
  filters: {
    formatDate(time) { return formatDate(new Date(time), "yyyy-MM-dd hh:mm"); }
  }
};
</script>

<style scoped lang="less">
.content { padding: 10px 0; }
.accepted-item {
  margin-bottom: 5px;
  .item-main {
    cursor: pointer; padding: 10px; border-radius: 6px; transition: background 0.2s;
    &:hover { background: #fcfcfc; }
    .status-bar {
      display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;
      .order-time { font-size: 12px; color: #999; }
    }
    .item-body {
      display: flex; justify-content: space-between;
      .text-info {
        flex: 1; padding-right: 20px;
        .title { margin: 0 0 8px 0; font-size: 17px; color: #333; }
        .text-muted { color: #999; text-decoration: line-through; }
        .summary { font-size: 14px; color: #666; line-height: 1.4; display: -webkit-box; -webkit-box-orient: vertical; -webkit-line-clamp: 2; overflow: hidden; margin-bottom: 10px; }
        .publisher { display: flex; align-items: center; font-size: 13px; color: #409eff; }
      }
      .image-box { .side-img { width: 100px; height: 75px; border-radius: 4px; border: 1px solid #eee; } }
    }
  }
  .item-footer {
    display: flex; justify-content: space-between; align-items: center;
    margin-top: 10px; padding: 8px 12px; background: #fffcf5; border-radius: 4px;
    .tip { font-size: 12px; color: #e6a23c; }
  }
}
</style>