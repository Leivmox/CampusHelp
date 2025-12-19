<template>
  <div class="profile-container">
    <el-card class="box-card" shadow="hover">
      <div class="user-header-bg">
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

      <div class="user-profile-core">
        <div class="avatar-wrapper">
          <el-avatar :size="80" class="user-avatar" :src="user.avatar">
            {{ user.username ? user.username.slice(-1) : "User" }}
          </el-avatar>
        </div>
        <div class="user-names">
          <span class="name">{{ user.username }}</span>
          <el-tag size="mini" type="success" effect="dark" class="role-tag"
            >学生</el-tag
          >
        </div>
        <div class="user-bio">
          {{ user.signature || "这个人很懒，什么都没有留下..." }}
        </div>
      </div>

      <div class="user-stats">
        <div class="stat-item">
          <div class="num" style="color: #ff9900">
            {{ user.balance || "0" }}
          </div>
          <div class="label">积分余额</div>
        </div>

        <el-divider direction="vertical"></el-divider>

        <div class="stat-item">
          <div class="num">{{ publishCount }}</div>
          <div class="label">发布求助</div>
        </div>

        <el-divider direction="vertical"></el-divider>

        <div class="stat-item">
          <div class="num">{{ solveCount }}</div>
          <div class="label">解决求助</div>
        </div>
      </div>

      <el-divider content-position="center">详细资料</el-divider>

      <div class="info-content">
        <el-descriptions :column="2" border>
          <el-descriptions-item>
            <template slot="label"><i class="el-icon-user"></i> 学号</template>
            {{ user.studentId }}
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
              ><i class="el-icon-date"></i> 注册时间</template
            >
            2023-09-01
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </el-card>
  </div>
</template>

<script>
import { mapState } from 'vuex'
// 引入任务查询接口，用于统计数量
import { listTask } from "@/api/task/task";
import { listPublished, listAccepted } from "@/api/task/task";

export default {
  name: "MyProfile",
  data() {
    return {
      publishCount: 0, // 发布的数量
      solveCount: 0    // 解决的数量 (作为接受者)
    }
  },
  computed: {
    ...mapState('user', ['user'])
  },
  created() {
    this.getUserStats();
  },
methods: {
    getUserStats() {
      const userId = this.user.id;

      // --- 1. 获取发布的求助 ---
      listPublished(userId).then(res => {
        // 【关键】打印出来看看结构！
        console.log("发布任务接口返回:", res);

        // 防御性编程：尝试获取 task，取不到就给个空数组，防止报错
        // 你的后端Controller里写的key是 "task"，所以这里应该是 res.task
        // 如果request.js没有解包，也可能是 res.data.task
        const list = res.task || (res.data && res.data.task) || [];

        this.publishCount = list.length || 0;
      }).catch(err => {
        console.error("获取发布数量失败:", err);
        this.publishCount = 0; // 报错了也显示0
      });

      // --- 2. 获取解决的求助 ---
      listAccepted(userId).then(res => {
        console.log("解决任务接口返回:", res);

        const list = res.task || (res.data && res.data.task) || [];

        this.solveCount = list.length || 0;
      }).catch(err => {
        console.error("获取解决数量失败:", err);
        this.solveCount = 0;
      });
    }
  }
}
</script>

<style scoped lang="less">
.profile-container {
  padding: 20px;
  display: flex;
  justify-content: center;
}

.box-card {
  width: 100%;
  max-width: 800px;
  border-radius: 12px;
  overflow: hidden;

  /deep/ .el-card__body {
    padding: 0;
  }
}

// 顶部彩色背景
.user-header-bg {
  height: 120px;
  background: linear-gradient(135deg, #409eff 0%, #a0cfff 100%);
  position: relative;

  .edit-btn {
    position: absolute;
    top: 15px;
    right: 15px;
    background: rgba(255, 255, 255, 0.3);
    border: none;
    color: #fff;
    &:hover {
      background: rgba(255, 255, 255, 0.5);
    }
  }
}

// 核心个人信息区（头像上浮）
.user-profile-core {
  text-align: center;
  position: relative;
  padding-bottom: 20px;

  .avatar-wrapper {
    margin-top: -40px;
    margin-bottom: 10px;

    .user-avatar {
      border: 4px solid #fff;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
      background-color: #409eff;
      font-size: 30px;
    }
  }

  .user-names {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    margin-bottom: 8px;

    .name {
      font-size: 22px;
      font-weight: bold;
      color: #303133;
    }
  }

  .user-bio {
    font-size: 13px;
    color: #909399;
    padding: 0 20px;
  }
}

// 统计栏
.user-stats {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px 0 25px 0;

  .stat-item {
    text-align: center;
    padding: 0 30px; // 稍微调宽一点间距

    .num {
      font-size: 20px;
      font-weight: 600;
      color: #303133;
      font-family: "Helvetica Neue", Helvetica, "PingFang SC",
        "Hiragino Sans GB", "Microsoft YaHei", Arial, sans-serif;
    }
    .label {
      font-size: 12px;
      color: #909399;
      margin-top: 4px;
    }
  }
}

// 详细信息区
.info-content {
  padding: 0 20px 30px 20px;

  /deep/ .el-descriptions__title {
    font-size: 15px;
    font-weight: bold;
  }

  // 让表格更好看一点
  /deep/ .el-descriptions-item__label {
    width: 100px;
    text-align: right;
    background-color: #f8f9fa;
  }
}
</style>
