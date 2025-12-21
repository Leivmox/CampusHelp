<template>
  <div class="content">
    <el-alert
      title="发布新求助 - 请详细描述你的问题"
      :closable="false"
      type="success"
      style="margin-bottom: 10px"
    >
    </el-alert>

    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold">发布求助</span>
        <el-button
          style="float: right; padding: 3px 0; font-size: 16px"
          icon="el-icon-s-promotion"
          type="text"
          @click="submitTask"
        >
          发布
        </el-button>
      </div>

      <div class="form-wrapper">
        <div class="form-item">
          <el-input placeholder="请输入简短的求助标题" v-model="taskTitle">
            <template slot="prepend">求助标题</template>
          </el-input>
        </div>

        <div class="form-item">
          <div class="label-text">详细描述</div>
          <el-input
            type="textarea"
            :autosize="{ minRows: 8, maxRows: 12 }"
            placeholder="请详细描述你的问题背景、环境以及报错信息..."
            v-model="taskContext"
            resize="none"
          >
          </el-input>
        </div>
      </div>
    </el-card>

    <el-drawer
      title="求助发布详情"
      :visible.sync="drawer"
      direction="rtl"
      size="40%"
    >
      <div class="content_drawer">
        <el-card class="drawer-card" shadow="never">
          <div slot="header" class="clearfix">
            <span>发布内容概览</span>
          </div>
          <el-collapse v-model="activeNames">
            <el-collapse-item title="求助标题" name="1">
              <div class="preview-text">{{ taskTitle }}</div>
            </el-collapse-item>
            <el-collapse-item title="求助内容" name="2">
              <div class="preview-text">{{ taskContext }}</div>
            </el-collapse-item>
            <el-collapse-item title="发布时间" name="4">
              <div>{{ createTime | formatDate }}</div>
            </el-collapse-item>
          </el-collapse>
        </el-card>

        <div style="margin-top: 20px; text-align: center">
          <el-button type="primary" @click="drawer = false" style="width: 100%"
            >关闭</el-button
          >
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import { mapMutations, mapState } from "vuex";
import { formatDate } from "@/util/date";

export default {
  name: "Task",
  data() {
    return {
      taskTitle: "",
      taskContext: "",
      createTime: "",
      drawer: false,
      activeNames: ["1", "2", "4"],
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  methods: {
    ...mapMutations("user", ["setUser"]),

submitTask() {
  if (this.taskTitle && this.taskContext) {
    // 再次确认积分（前端拦截）
    if (this.user.balance < 10) {
      this.$msg("积分不足，发布求助需要 10 积分", "error");
      return;
    }

    // 发送请求
    this.$post("/task", {
      publishId: this.user.id,
      schoolId: this.user.school.id,
      taskTitle: this.taskTitle,
      taskContext: this.taskContext,
    }).then((res) => {
      // 只有 res.data.status 为 true 时才算成功
      if (res.data.status) {
        this.createTime = new Date().getTime();
        this.drawer = true;
        this.renew(); // 刷新 Vuex 中的用户信息（同步积分）
        this.$msg(res.data.msg, "success");
        this.taskTitle = "";
        this.taskContext = "";
      } else {
        // 后端返回的积分不足提示会走这里
        this.$msg(res.data.msg, "error");
      }
    }).catch(err => {
      // 只有网络不通、404、500 才会走 catch
      console.error(err);
      this.$msg("服务器连接异常", "error");
    });
  } else {
    this.$msg("请完整填写标题和详细描述", "warning");
  }
},
    renew() {
      this.$get("user/" + this.user.id)
        .then((response) => {
          if (response.data.status) {
            const newUserInfo = response.data.user;
            // 更新 sessionStorage 防止刷新页面丢失
            sessionStorage.setItem("user", JSON.stringify(newUserInfo));
            // 更新 Vuex 状态
            this.setUser(newUserInfo);
          }
        })
        .catch((err) => {
          console.error("更新用户信息失败", err);
        });
    },
  },
  created() {
    this.renew();
  },
  filters: {
    formatDate(time) {
      let date = new Date(time);
      return formatDate(date, "yyyy-MM-dd hh:mm");
    },
  },
};
</script>

<style scoped lang="less">
/* 1. 容器样式重置：透明 + 上下10px */
.content {
  background: transparent;
  margin: 0;
  padding: 10px 0;

  /* 2. 主卡片样式：圆角 + 无边框 */
  .box-card {
    border-radius: 8px;
    border: none;

    .form-wrapper {
      padding: 10px 0;
    }

    /* 表单项间距 */
    .form-item {
      margin-bottom: 20px;
    }

    /* 标签文字样式 */
    .label-text {
      font-size: 14px;
      color: #606266;
      background-color: #f5f7fa;
      border: 1px solid #dcdfe6;
      border-bottom: none;
      padding: 0 20px;
      line-height: 38px;
      width: fit-content; /* 宽度自适应内容 */
      border-radius: 4px 4px 0 0; /* 上方圆角 */
      margin-top: 10px;
      display: inline-block; /* 让它像个标签页一样 */
    }

    /* 文本域特殊处理，让它看起来和上面的标签连在一起 */
    /deep/ .el-textarea__inner {
      font-family: "Microsoft YaHei", sans-serif !important;
      border-radius: 0 4px 4px 4px; /* 左上角直角，其他圆角 */
    }
  }

  /* 抽屉内部样式 */
  .content_drawer {
    padding: 0 20px;

    .drawer-card {
      border-radius: 8px;
      border: 1px solid #ebeef5;
    }

    .preview-text {
      white-space: pre-wrap; /* 保留换行符 */
      color: #333;
    }
  }
}
</style>
