<template>
  <div class="dashboard-container">
    
    <el-row class="welcome-row">
      <el-col :span="24">
        <el-alert
          :title="'欢迎登录 ' + (user.school ? user.school.name : '') + ' IT互助系统'"
          type="success"
          :closable="false"
          show-icon>
        </el-alert>
      </el-col>
    </el-row>

    <div class="white-block">
      <el-row :gutter="0" class="stats-row">
        <el-col :xs="12" :sm="12" :lg="6" class="stat-col">
          <div class="stat-item">
            <div class="stat-title">网站用户</div>
            <div class="stat-num">{{ userCount }}</div>
          </div>
        </el-col>
        
        <el-col :xs="12" :sm="12" :lg="6" class="stat-col">
          <div class="stat-item">
            <div class="stat-title">总求助</div>
            <div class="stat-num">{{ totalTasks }}</div>
          </div>
        </el-col>
        
        <el-col :xs="12" :sm="12" :lg="6" class="stat-col">
          <div class="stat-item">
            <div class="stat-title">待解决求助</div>
            <div class="stat-num">{{ pendingTasks }}</div>
          </div>
        </el-col>
        
        <el-col :xs="12" :sm="12" :lg="6" class="stat-col">
          <div class="stat-item no-border">
            <div class="stat-title">校园帖子</div>
            <div class="stat-num">{{ postCount }}</div>
          </div>
        </el-col>
      </el-row>
    </div>

    <div class="white-block chart-block">
      <div class="chart-title">状态 - 近7天求助发布趋势</div>
      <div id="mainChart" style="width: 100%; height: 350px;"></div>
    </div>

  </div>
</template>

<script>
import { mapState } from "vuex";
import * as echarts from 'echarts';

export default {
  name: "Index",
  data() {
    return {
      userCount: 0,
      totalTasks: 0,
      pendingTasks: 0,
      postCount: 0,
      chartInstance: null,
    };
  },
  computed: {
    ...mapState('user', ['user'])
  },
  mounted() {
    this.getAllData();
    window.addEventListener('resize', this.resizeChart);
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.resizeChart);
    if (this.chartInstance) {
      this.chartInstance.dispose();
    }
  },
  methods: {
    resizeChart() {
      if (this.chartInstance) {
        this.chartInstance.resize();
      }
    },
    getAllData() {
      // 获取用户数
      this.$get("/user").then((res) => {
        if(res.data.user) this.userCount = res.data.user.length;
      });

      // 获取帖子数
      if (this.user.school && this.user.school.id) {
        this.$get("/post", { schoolId: this.user.school.id }).then((res) => {
          if(res.data.posts) this.postCount = res.data.posts.length;
        });
      }

      // 获取任务数据
      this.$get("/task", { id: this.user.id }).then((res) => {
        if(res.data.task) {
          const tasks = res.data.task;
          this.totalTasks = tasks.length;
          this.pendingTasks = tasks.filter(t => t.state !== 2).length;
          this.initChart(tasks);
        }
      });
    },
    initChart(tasks) {
      const dateList = [];
      const countList = [];
      
      for (let i = 6; i >= 0; i--) {
        const date = new Date();
        date.setDate(date.getDate() - i);
        const dateStr = date.toISOString().split('T')[0];
        dateList.push(dateStr);
        
        const count = tasks.filter(task => {
          if (!task.createTime && !task.publishTime) return false;
          const taskTime = task.createTime || task.publishTime; 
          return taskTime.startsWith(dateStr);
        }).length;
        countList.push(count);
      }

      const chartDom = document.getElementById('mainChart');
      this.chartInstance = echarts.init(chartDom);
      
      const option = {
        tooltip: { trigger: 'axis' },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: [{ type: 'category', boundaryGap: false, data: dateList }],
        yAxis: [{ type: 'value', minInterval: 1 }],
        series: [{
          name: '求助数量',
          type: 'line',
          smooth: true,
          areaStyle: {
            opacity: 0.8,
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgb(128, 255, 165)' },
              { offset: 1, color: 'rgb(1, 191, 236)' }
            ])
          },
          data: countList
        }]
      };
      this.chartInstance.setOption(option);
    }
  }
}
</script>

<style scoped lang="less">
/* 全局灰色背景容器 */
.dashboard-container {
  /* 关键修改：从 20px 改为 10px，让四周的留白变小 */
  padding: 10px; 
  background-color: #f0f2f5; 
  min-height: calc(100vh - 84px);
}

.welcome-row {
  /* 关键修改：从 20px 改为 10px，减小欢迎语和下面统计图的间距 */
  margin-bottom: 10px;
}

/* 核心通用样式：白色大块 */
.white-block {
  background: #fff;
  /* 关键修改：内部 padding 从 20px 改为 15px，让卡片看起来不那么散 */
  padding: 15px; 
  border-radius: 8px; 
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05); 
  /* 关键修改：卡片之间的垂直间距从 20px 改为 10px */
  margin-bottom: 10px;
}

/* 统计区域样式 */
.stats-row {
  display: flex;
  align-items: center;
}

.stat-col {
  text-align: center;
  position: relative;
}

.stat-item {
  padding: 10px 0;
  border-right: 1px solid #eee; 
}

.no-border {
  border-right: none;
}

@media (max-width: 768px) {
  .stat-item {
    border-right: none;
    border-bottom: 1px solid #eee;
    margin-bottom: 10px;
  }
}

.stat-title {
  font-size: 14px;
  color: rgba(0, 0, 0, 0.45);
  margin-bottom: 8px; /* 微调 */
}

.stat-num {
  font-size: 24px;
  font-weight: bold;
  color: #005EEB;
}

/* 图表区域样式 */
.chart-title {
  font-size: 16px; /* 字体改小一点点显得精致 */
  color: #333;
  font-weight: bold;
  padding-left: 10px;
  border-left: 4px solid #005EEB;
  margin-bottom: 15px; /* 标题和图表的距离也拉近一点 */
}
</style>