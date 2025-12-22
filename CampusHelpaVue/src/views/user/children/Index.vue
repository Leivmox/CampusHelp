<template>
  <div class="dashboard-container">
    <el-row class="welcome-row">
      <el-col :span="24">
        <el-alert
          :title="'欢迎回来，' + (user.nickname || user.username)"
          type="success"
          :closable="false"
          show-icon
        >
        </el-alert>
      </el-col>
    </el-row>

    <el-row :gutter="10">
      <el-col :xs="24" :sm="24" :md="16" :lg="16" :xl="16">
        <div class="white-block mb-10 banner-block">
          <img :src="bannerImg" class="banner-image" alt="校园互助" />
        </div>
        <div class="white-block list-block">
          <div class="welcome-header">
            <h2 class="welcome-title">
              欢迎来到 {{ user.school ? user.school.name : "校园" }} IT互助空间
            </h2>
            <p class="welcome-desc">
              技术难题不用慌，校园大神来帮忙。这里汇聚了最实用的技术干货与最热心的技术伙伴。
              遇到问题请点击左侧
              <el-tag size="mini" effect="dark">求助中心</el-tag>
              -
              <el-tag size="mini" effect="dark">发布求助</el-tag>，
              或者浏览下方的精选文章。
            </p>
          </div>
          <div class="divider"></div>
          <div class="article-list">
            <div class="list-header">
              <i class="el-icon-collection-tag" style="color: #f56c6c"></i>
              <span style="font-weight: bold; margin-left: 5px">精选</span>
            </div>
            <div
              v-for="(item, index) in topArticles"
              :key="index"
              class="article-item"
            >
              <span class="tag-top">置顶</span>
              <span class="article-title">{{ item }}</span>
              <span class="article-date">2023-12-{{ 20 - index }}</span>
            </div>
          </div>
        </div>
      </el-col>

      <el-col :xs="24" :sm="24" :md="8" :lg="8" :xl="8">
        <div class="white-block mb-10 profile-card" @click="goToProfile">
          <div
            class="profile-bg"
            :style="{ backgroundImage: `url(${userBgImg})` }"
          ></div>

          <div class="profile-content">
            <div class="avatar-wrap">
              <el-avatar :size="70" :src="fullAvatarUrl" class="user-avatar">
                {{
                  user.username
                    ? user.username.slice(0, 1).toUpperCase()
                    : "User"
                }}
              </el-avatar>
            </div>
            <div class="user-name">{{ user.nickname || user.username }}</div>
            <div class="user-role">
              {{ user.school ? user.school.name : "未设置学校" }} · 学生
            </div>
            <div class="user-bio" :title="user.signature">
              {{ user.signature || "这个人很懒，什么都没有留下..." }}
            </div>
          </div>

          <div class="profile-stats">
            <div class="p-stat-item">
              <div class="num" style="color: #ff9900">
                {{ user.balance || 0 }}
              </div>
              <div class="label">积分</div>
            </div>
            <div class="p-divider"></div>
            <div class="p-stat-item">
              <div class="num">{{ myPublishCount }}</div>
              <div class="label">求助</div>
            </div>
            <div class="p-divider"></div>
            <div class="p-stat-item">
              <div class="num">{{ mySolveCount }}</div>
              <div class="label">解决</div>
            </div>
          </div>
        </div>

        <div class="white-block mb-10">
          <div class="chart-title">平台数据概览</div>
          <el-row :gutter="0" class="stats-row">
            <el-col :span="12" class="stat-col">
              <div class="stat-item">
                <div class="stat-title">网站用户</div>
                <div class="stat-num">{{ userCount }}</div>
              </div>
            </el-col>
            <el-col :span="12" class="stat-col">
              <div class="stat-item no-border-right">
                <div class="stat-title">校园帖子</div>
                <div class="stat-num">{{ postCount }}</div>
              </div>
            </el-col>
            <el-col :span="24" class="h-line"></el-col>
            <el-col :span="12" class="stat-col">
              <div class="stat-item">
                <div class="stat-title">总求助</div>
                <div class="stat-num">{{ totalTasks }}</div>
              </div>
            </el-col>
            <el-col :span="12" class="stat-col">
              <div class="stat-item no-border-right">
                <div class="stat-title">待解决</div>
                <div class="stat-num warning-text">{{ pendingTasks }}</div>
              </div>
            </el-col>
          </el-row>
        </div>

        <div class="white-block">
          <div class="chart-title">状态 - 近7天求助发布趋势</div>
          <div id="mainChart" style="width: 100%; height: 260px"></div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { mapState } from "vuex";
import * as echarts from "echarts";
import { listPublished, listAccepted } from "@/api/task/task";

export default {
  name: "Index",
  data() {
    return {
      userCount: 0,
      totalTasks: 0,
      pendingTasks: 0,
      postCount: 0,
      chartInstance: null,
      bannerImg: require("@/assets/img/index_bg.png"),

      // 🟢 新增：引入用户背景图 (假设在 assets/img/ 下)
      userBgImg: require("@/assets/img/user_bg.jpg"),

      myPublishCount: 0,
      mySolveCount: 0,

      topArticles: [
        "最全的微软msdn原版Windows系统镜像和Office Visio Project下载地址集锦",
        "图文详解彻底关闭win10、win11系统自带的windows defender杀毒功能",
        "全面剖析固态硬盘M.2接口与PCI-E SSD固态硬盘的关系",
        "系统安装教程大汇总：win系统版本下载 + 系统安装/重装/升级/封装教程",
        "实战绝招分享：半个月变身计算机大神就是这样练成的",
      ],
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
  mounted() {
    this.getAllData();
    this.getMyStats();
    window.addEventListener("resize", this.resizeChart);
  },
  beforeDestroy() {
    window.removeEventListener("resize", this.resizeChart);
    if (this.chartInstance) {
      this.chartInstance.dispose();
    }
  },
  methods: {
    goToProfile() {
      this.$router.push("/home/MyProfile");
    },
    getMyStats() {
      if (!this.user.id) return;
      listPublished(this.user.id)
        .then((res) => {
          const list = res.task || (res.data && res.data.task) || [];
          this.myPublishCount = list.length || 0;
        })
        .catch((e) => console.error(e));

      listAccepted(this.user.id)
        .then((res) => {
          const list = res.task || (res.data && res.data.task) || [];
          this.mySolveCount = list.length || 0;
        })
        .catch((e) => console.error(e));
    },
    resizeChart() {
      if (this.chartInstance) {
        this.chartInstance.resize();
      }
    },
    formatDateToDay(timeStr) {
      if (!timeStr) return "";
      try {
        const date = new Date(timeStr);
        const y = date.getFullYear();
        const m = (date.getMonth() + 1).toString().padStart(2, "0");
        const d = date.getDate().toString().padStart(2, "0");
        return `${y}-${m}-${d}`;
      } catch (e) {
        return "";
      }
    },
    getAllData() {
      this.$get("/user")
        .then((res) => {
          const list = res.data?.user || res.data || [];
          this.userCount = Array.isArray(list) ? list.length : 0;
        })
        .catch((e) => console.error(e));

      if (this.user.school && this.user.school.id) {
        this.$get("/post", { schoolId: this.user.school.id }).then((res) => {
          const list = res.data?.posts || res.data || [];
          this.postCount = Array.isArray(list) ? list.length : 0;
        });
      }

      this.$get("/task", { id: this.user.id })
        .then((res) => {
          let tasks = [];
          if (res.data && Array.isArray(res.data.task)) {
            tasks = res.data.task;
          } else if (Array.isArray(res.data)) {
            tasks = res.data;
          }

          this.totalTasks = tasks.length;
          this.pendingTasks = tasks.filter((t) => t.state !== 2).length;

          this.$nextTick(() => {
            this.initChart(tasks);
          });
        })
        .catch((e) => console.error(e));
    },
    initChart(tasks) {
      const dateList = [];
      const countList = [];
      for (let i = 6; i >= 0; i--) {
        const date = new Date();
        date.setDate(date.getDate() - i);
        const y = date.getFullYear();
        const m = (date.getMonth() + 1).toString().padStart(2, "0");
        const d = date.getDate().toString().padStart(2, "0");
        const dateStr = `${y}-${m}-${d}`;
        dateList.push(`${m}-${d}`);
        const count = tasks.filter((task) => {
          const rawTime = task.createTime || task.publishTime;
          const taskDateStr = this.formatDateToDay(rawTime);
          return taskDateStr === dateStr;
        }).length;
        countList.push(count);
      }

      const chartDom = document.getElementById("mainChart");
      if (!chartDom) return;
      if (this.chartInstance) this.chartInstance.dispose();
      this.chartInstance = echarts.init(chartDom);

      const option = {
        tooltip: { trigger: "axis" },
        grid: {
          left: "10px",
          right: "15px",
          bottom: "10px",
          top: "30px",
          containLabel: true,
        },
        xAxis: [
          {
            type: "category",
            boundaryGap: false,
            data: dateList,
            axisLine: { lineStyle: { color: "#999" } },
          },
        ],
        yAxis: [
          {
            type: "value",
            minInterval: 1,
            splitLine: { lineStyle: { type: "dashed", color: "#eee" } },
          },
        ],
        series: [
          {
            name: "求助数量",
            type: "line",
            smooth: true,
            showSymbol: true,
            symbolSize: 6,
            lineStyle: { width: 3, color: "#409EFF" },
            areaStyle: {
              opacity: 0.6,
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: "rgba(64, 158, 255, 0.6)" },
                { offset: 1, color: "rgba(64, 158, 255, 0.05)" },
              ]),
            },
            data: countList,
          },
        ],
      };
      this.chartInstance.setOption(option);
    },
  },
};
</script>

<style scoped lang="less">
/* ... 其他样式保持不变 ... */
.dashboard-container {
  padding: 10px;
  background-color: #f0f2f5;
  min-height: calc(100vh - 84px);
}
.welcome-row {
  margin-bottom: 10px;
}
.white-block {
  background: #fff;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 1px 4px 0 rgba(0, 0, 0, 0.05);
}
.mb-10 {
  margin-bottom: 10px;
}
.banner-block {
  padding: 0 !important;
  overflow: hidden;
  height: 380px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.banner-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}
.banner-image:hover {
  transform: scale(1.02);
}
.list-block {
  display: flex;
  flex-direction: column;
}
.welcome-header {
  margin-bottom: 10px;
}
.welcome-title {
  margin: 0 0 10px 0;
  font-size: 20px;
  color: #303133;
  font-weight: 600;
}
.welcome-desc {
  font-size: 14px;
  color: #606266;
  line-height: 1.6;
  margin: 0;
}
.divider {
  height: 1px;
  background-color: #f0f2f5;
  margin: 15px 0;
}
.list-header {
  font-size: 15px;
  margin-bottom: 15px;
  color: #303133;
  display: flex;
  align-items: center;
}
.article-item {
  display: flex;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px dashed #eee;
  cursor: pointer;
  transition: all 0.2s;
}
.article-item:last-child {
  border-bottom: none;
}
.article-item:hover {
  background-color: #fafafa;
}
.article-item:hover .article-title {
  color: #409eff;
}
.tag-top {
  background-color: #f56c6c;
  color: #fff;
  font-size: 12px;
  padding: 2px 6px;
  border-radius: 4px;
  margin-right: 10px;
  flex-shrink: 0;
}
.article-title {
  font-size: 14px;
  color: #333;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.article-date {
  font-size: 12px;
  color: #999;
  margin-left: 10px;
  flex-shrink: 0;
}

.profile-card {
  padding: 0 !important;
  overflow: hidden;
  cursor: pointer;
  transition: box-shadow 0.3s, transform 0.2s;

  &:hover {
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    transform: translateY(-2px);
  }
}

/* 🟢 核心修改：背景图样式调整 */
.profile-bg {
  height: 130px;
  /* background: linear-gradient(135deg, #409eff 0%, #a0cfff 100%); 删除旧的渐变 */
  background-size: cover; /* 让图片填满 */
  background-position: center; /* 图片居中显示 */
}

.profile-content {
  text-align: center;
  position: relative;
  margin-top: -45px;
  padding-bottom: 15px;
  border-bottom: 1px solid #f0f0f0;
}
.avatar-wrap {
  display: inline-block;
  padding: 3px;
  background: #fff;
  border-radius: 50%;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
.user-name {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
  margin-top: 5px;
}
.user-role {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}
.user-bio {
  font-size: 13px;
  color: #606266;
  margin-top: 8px;
  padding: 0 20px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.profile-stats {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 15px 0;
  background-color: #fafafa;
}
.p-stat-item {
  text-align: center;
  flex: 1;
}
.p-divider {
  width: 1px;
  height: 20px;
  background-color: #e0e0e0;
}
.p-stat-item .num {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}
.p-stat-item .label {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}
.stats-row {
  display: flex;
  flex-wrap: wrap;
}
.stat-col {
  text-align: center;
  padding: 15px 0;
}
.stat-item {
  border-right: 1px solid #f0f0f0;
}
.no-border-right {
  border-right: none;
}
.h-line {
  height: 1px;
  background: #f0f0f0;
  width: 100%;
}
.stat-title {
  font-size: 13px;
  color: #909399;
  margin-bottom: 5px;
}
.stat-num {
  font-size: 20px;
  font-weight: bold;
  color: #303133;
}
.warning-text {
  color: #e6a23c;
}
.chart-title {
  font-size: 15px;
  color: #303133;
  font-weight: bold;
  padding-left: 10px;
  border-left: 4px solid #409eff;
  margin-bottom: 15px;
}
.coin-symbol {
  margin-right: 4px; /* 图标和数字之间的间距 */
  font-size: 0.8em; /* 可选：调整图标大小 */
  display: inline-block;
}
</style>
