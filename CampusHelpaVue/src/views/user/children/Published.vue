<template>
  <div class="content">
    <el-alert
      :title="'管理中心 - 您已累计发布 ' + tasks.length + ' 个求助项目'"
      :closable="false"
      type="success"
      style="margin-bottom: 15px"
      show-icon
    ></el-alert>

    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold">我发布的求助</span>
        <el-button
          style="float: right; padding: 3px 0"
          type="text"
          icon="el-icon-refresh"
          @click="retrieveData"
          >刷新</el-button
        >
      </div>

      <div v-if="tasks.length > 0">
        <div
          v-for="(item, index) in tasks"
          :key="item.id"
          class="published-item"
        >
          <div class="item-main" @click="goToDetail(item.id)">
            <div class="status-bar">
              <el-tag
                :type="
                  item.state == 0
                    ? 'success'
                    : item.state == 1
                    ? 'warning'
                    : 'info'
                "
                effect="dark"
                size="small"
              >
                {{
                  item.state == 0
                    ? "待接取"
                    : item.state == 1
                    ? "服务中"
                    : "已完成"
                }}
              </el-tag>
              <span class="post-time"
                ><i class="el-icon-time"></i> 发布于:
                {{ item.createTime | formatDate }}</span
              >
            </div>

            <div class="item-body">
              <div class="text-info">
                <h4 class="title" :class="{ 'text-muted': item.state == 2 }">
                  {{ item.taskTitle }}
                </h4>
                <p class="summary">{{ item.taskContext }}</p>

                <div class="mini-steps">
                  <span :class="{ active: item.state >= 0 }"
                    ><i class="el-icon-circle-check"></i> 已发布</span
                  >
                  <span class="line"></span>
                  <span :class="{ active: item.state >= 1 }">
                    <i
                      :class="
                        item.state >= 1
                          ? 'el-icon-circle-check'
                          : 'el-icon-loading'
                      "
                    ></i>
                    {{ item.state >= 1 ? "已接单" : "等待中" }}
                  </span>
                  <span class="line"></span>
                  <span :class="{ active: item.state == 2 }">
                    <i
                      :class="
                        item.state == 2
                          ? 'el-icon-circle-check'
                          : 'el-icon-time'
                      "
                    ></i>
                    结束
                  </span>
                </div>
              </div>

              <div
                class="image-box"
                v-if="item.imgList && item.imgList.length > 0"
              >
                <el-image
                  :src="getResUrl(item.imgList[0])"
                  fit="cover"
                  class="side-img"
                >
                  <div slot="error" class="image-slot">
                    <i class="el-icon-picture-outline"></i>
                  </div>
                </el-image>
                <div class="img-tag" v-if="item.imgList.length > 1">
                  {{ item.imgList.length }}张
                </div>
              </div>
            </div>
          </div>

          <div class="item-footer">
            <div class="left-actions">
              <span
                v-if="item.state == 1"
                class="helper-info"
                @click="receiver(item)"
              >
                <i class="el-icon-user"></i> 帮助者:
                {{ item.accept ? item.accept.username : "查看详情" }}
              </span>
            </div>

            <div class="right-buttons">
              <el-popconfirm
                v-if="item.state == 0"
                title="确定取消并下架这条求助吗？"
                @confirm="cancel(item.id)"
              >
                <el-button
                  slot="reference"
                  type="danger"
                  size="mini"
                  plain
                  icon="el-icon-delete"
                  >取消求助</el-button
                >
              </el-popconfirm>

              <el-button
                v-if="item.state == 1"
                type="primary"
                size="mini"
                icon="el-icon-success"
                @click="completeTask(item.id)"
                >确认解决</el-button
              >

              <el-button
                v-if="item.state == 2"
                type="warning"
                size="mini"
                plain
                icon="el-icon-star-off"
                @click="remark(item)"
                >评价服务</el-button
              >

              <el-button
                size="mini"
                icon="el-icon-arrow-right"
                @click="goToDetail(item.id)"
                >详情</el-button
              >
            </div>
          </div>

          <el-divider></el-divider>
        </div>
      </div>
      <el-empty v-else description="您还没有发布过任何求助信息"></el-empty>
    </el-card>

    <el-drawer
      title="帮助者详细信息"
      :visible.sync="drawer"
      direction="rtl"
      size="320px"
    >
      <div class="drawer-content" v-if="recipientInformation">
        <div class="user-profile-header">
          <el-avatar :size="60" icon="el-icon-user"></el-avatar>
          <h3>{{ recipientInformation.username }}</h3>
        </div>
        <div class="info-list">
          <div class="info-item">
            <label>手机号</label
            ><span>{{ recipientInformation.phone || "未绑定" }}</span>
          </div>
          <div class="info-item">
            <label>所属学校</label
            ><span>{{
              recipientInformation.school
                ? recipientInformation.school.name
                : "-"
            }}</span>
          </div>
          <div class="info-item">
            <label>院系</label
            ><span>{{
              recipientInformation.dept ? recipientInformation.dept.name : "-"
            }}</span>
          </div>
          <div class="info-item">
            <label>班级</label
            ><span>{{
              recipientInformation.aclass
                ? recipientInformation.aclass.name
                : "-"
            }}</span>
          </div>
        </div>
        <div class="drawer-tip">注：请先通过电话与对方取得联系确认细节。</div>
      </div>
    </el-drawer>

    <el-dialog
      :title="title"
      :visible.sync="open"
      width="400px"
      append-to-body
      border-radius="8px"
    >
      <el-form ref="form" :model="form" :rules="rules" label-position="top">
        <el-form-item label="服务评分">
          <el-rate v-model="form.star" show-text></el-rate>
        </el-form-item>
        <el-form-item label="心得评价">
          <el-input
            type="textarea"
            :rows="4"
            v-model="form.remark"
            placeholder="对方帮到您了吗？说点感谢的话吧..."
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="exit">取 消</el-button>
        <el-button type="primary" @click="submitForm">提交评价</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
// 此处保留你原有的 script 逻辑，仅在 load 处增加图片分割处理
import { mapState, mapMutations } from "vuex";
import { formatDate } from "@/util/date";
import { addRemark } from "@/api/remark/remark";

export default {
  name: "Published",
  data() {
    return {
      open: false,
      tasks: [],
      drawer: false,
      recipientInformation: {},
      currentTask: null,
      form: { star: 5, remark: "" },
      rules: {},
      title: "",
      baseUrl: "http://localhost:8080",
    };
  },
  computed: { ...mapState("user", ["user"]) },
  created() {
    this.retrieveData();
  },
  methods: {
    ...mapMutations("user", ["setUser"]),

    getResUrl(url) {
      if (!url) return "";
      return url.startsWith("http") ? url : this.baseUrl + url;
    },
    goToDetail(id) {
      this.$router.push({ name: "TaskDetail", params: { id: id } });
    },
    renew() {
      this.$get("user/" + this.user.id).then((response) => {
        if (response.data.status) {
          sessionStorage.setItem("user", JSON.stringify(response.data.user));
          this.setUser(response.data.user);
        }
      });
    },
    retrieveData() {
      this.$get("/task/published", { id: this.user.id }).then((res) => {
        let list = res.data.task || [];
        list.forEach((item) => {
          if (item.imgUrl) item.imgList = item.imgUrl.split(",");
        });
        this.tasks = list;
      });
    },
    receiver(val) {
      if (val.accept) {
        this.recipientInformation = val.accept;
        this.drawer = true;
      } else {
        this.$msg("该任务暂无帮助者信息", "warning");
      }
    },
    cancel(id) {
      this.$del("/task/" + id).then((res) => {
        if (res.data.status) {
          this.$msg(res.data.msg, "success");
          this.retrieveData();
          this.renew();
        } else {
          this.$msg(res.data.msg || "取消失败", "error");
        }
      });
    },
    completeTask(id) {
      this.$confirm(
        "确认该同学已帮您解决了问题？确认后积分将转给对方。",
        "确认结算",
        {
          type: "success",
        }
      )
        .then(() => {
          this.$put("task/" + id).then((res) => {
            this.$msg(res.data.msg, "success");
            this.retrieveData();
          });
        })
        .catch(() => {});
    },
    remark(item) {
      this.currentTask = item;
      this.form = { star: 5, remark: "" };
      this.open = true;
      this.title = "评价校友服务";
    },
    submitForm() {
      if (!this.form.remark) return this.$message.warning("请写下您的评价");
      const val = this.currentTask;
      addRemark({
        star: this.form.star,
        remark: this.form.remark,
        acceptId: val.accept.id,
        publishId: val.publish.id,
        taskId: val.id,
      }).then(() => {
        this.$message.success("感谢您的评价！");
        this.open = false;
        this.retrieveData();
      });
    },
    exit() {
      this.open = false;
    },
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
.published-item {
  margin-bottom: 10px;

  .item-main {
    cursor: pointer;
    padding: 12px;
    border-radius: 8px;
    transition: all 0.2s;
    &:hover {
      background: #f9f9f9;
    }

    .status-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
      .post-time {
        font-size: 12px;
        color: #999;
      }
    }

    .item-body {
      display: flex;
      justify-content: space-between;
      .text-info {
        flex: 1;
        padding-right: 15px;
        .title {
          margin: 0 0 8px 0;
          font-size: 17px;
          color: #333;
        }
        .text-muted {
          color: #999;
          text-decoration: line-through;
        }
        .summary {
          font-size: 14px;
          color: #666;
          line-height: 1.5;
          margin-bottom: 15px;
          display: -webkit-box;
          -webkit-box-orient: vertical;
          -webkit-line-clamp: 2;
          overflow: hidden;
        }

        /* 进度条样式 */
        .mini-steps {
          display: flex;
          align-items: center;
          gap: 8px;
          font-size: 12px;
          color: #c0c4cc;
          .active {
            color: #67c23a;
            font-weight: bold;
          }
          .line {
            width: 20px;
            height: 1px;
            background: #ebeef5;
          }
        }
      }
      .image-box {
        position: relative;
        .side-img {
          width: 110px;
          height: 85px;
          border-radius: 6px;
          border: 1px solid #f0f0f0;
        }
        .img-tag {
          position: absolute;
          right: 5px;
          bottom: 5px;
          background: rgba(0, 0, 0, 0.6);
          color: #fff;
          font-size: 10px;
          padding: 2px 5px;
          border-radius: 3px;
        }
      }
    }
  }

  .item-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 12px;
    margin-top: 5px;

    .left-actions {
      .helper-info {
        font-size: 13px;
        color: #409eff;
        cursor: pointer;
        &:hover {
          text-decoration: underline;
        }
      }
    }
    .right-buttons {
      display: flex;
      gap: 8px;
    }
  }
}

/* 抽屉样式优化 */
.drawer-content {
  padding: 20px;
  .user-profile-header {
    text-align: center;
    margin-bottom: 30px;
    h3 {
      margin-top: 10px;
      color: #303133;
    }
  }
  .info-list {
    .info-item {
      display: flex;
      justify-content: space-between;
      margin-bottom: 18px;
      font-size: 14px;
      label {
        color: #909399;
      }
      span {
        color: #303133;
        font-weight: 500;
      }
    }
  }
  .drawer-tip {
    margin-top: 40px;
    font-size: 12px;
    color: #e6a23c;
    background: #fff7e6;
    padding: 10px;
    border-radius: 4px;
  }
}
</style>
