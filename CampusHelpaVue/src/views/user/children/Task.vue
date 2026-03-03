<template>
  <div class="content">
    <el-alert
      :title="isEditMode ? '修改求助 - 修改你的求助信息' : '发布新求助 - 请详细描述你的问题'"
      :closable="false"
      :type="isEditMode ? 'warning' : 'success'"
      style="margin-bottom: 10px"
    >
    </el-alert>

    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold">{{ isEditMode ? '修改求助' : '发布求助' }}</span>
        <el-button
          style="float: right; padding: 3px 0; font-size: 16px"
          :icon="isEditMode ? 'el-icon-edit' : 'el-icon-s-promotion'"
          type="text"
          @click="submitTask"
        >
          {{ isEditMode ? '保存修改' : '发布' }}
        </el-button>
        <el-button
          v-if="isEditMode"
          style="float: right; padding: 3px 0; font-size: 16px; margin-right: 15px;"
          type="text"
          @click="cancelEdit"
        >
          取消
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

        <div class="form-item">
          <div class="label-text">悬赏积分</div>
          <div class="reward-container">
            <div class="reward-info">
              <span class="current-balance">当前积分: <strong>{{ user.balance || 0 }}</strong></span>
            </div>
            <div class="reward-options">
              <div
                v-for="amount in rewardOptions"
                :key="amount"
                class="reward-option"
                :class="{ active: reward === amount, disabled: user.balance < amount }"
                @click="selectReward(amount)"
              >
                <span class="reward-amount">{{ amount }}</span>
                <span class="reward-label">积分</span>
              </div>
            </div>
            <div class="reward-tip">
              <i class="el-icon-info"></i>
              悬赏积分越高，越容易被接单哦~
            </div>
          </div>
        </div>

        <div class="form-item">
          <div class="label-text">上传图片 (最多9张)</div>
          <div class="upload-container">
            <el-upload
              action="http://localhost:8080/common/upload"
              :data="{ type: 'task' }"
              name="file"
              list-type="picture-card"
              :limit="9"
              :file-list="fileList"
              :on-success="handleUploadSuccess"
              :on-remove="handleRemove"
              :on-exceed="handleExceed"
              multiple
            >
              <i class="el-icon-plus"></i>
            </el-upload>
          </div>
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
            <el-collapse-item title="悬赏积分" name="5">
              <div class="preview-text reward-highlight">{{ reward }} 积分</div>
            </el-collapse-item>
            <el-collapse-item
              title="求助图片"
              name="3"
              v-if="imgList.length > 0"
            >
              <div class="preview-images">
                <el-image
                  v-for="(img, index) in imgList"
                  :key="index"
                  :src="getResUrl(img)"
                  style="
                    width: 80px;
                    height: 80px;
                    margin-right: 5px;
                    border-radius: 4px;
                  "
                  :preview-src-list="imgList.map((url) => getResUrl(url))"
                ></el-image>
              </div>
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
      isEditMode: false,
      editTaskId: null,
      taskTitle: "",
      taskContext: "",
      createTime: "",
      drawer: false,
      activeNames: ["1", "2", "3", "4", "5"],
      imgList: [],
      fileList: [],
      baseUrl: "http://localhost:8080",
      reward: 10,
      rewardOptions: [10, 15, 20, 25, 30]
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  methods: {
    ...mapMutations("user", ["setUser"]),

    getResUrl(url) {
      if (!url) return "";
      if (url.startsWith("http")) return url;
      return this.baseUrl + url;
    },

    selectReward(amount) {
      if (this.user.balance >= amount || this.isEditMode) {
        this.reward = amount;
      }
    },

    handleUploadSuccess(res, file, fileList) {
      if (res.url) {
        this.imgList.push(res.url);
      } else {
        this.$msg("图片上传返回值异常", "error");
      }
    },

    handleRemove(file, fileList) {
      const urlToRemove = file.response ? file.response.url : file.url;
      this.imgList = this.imgList.filter((url) => url !== urlToRemove);
    },

    handleExceed() {
      this.$msg("最多只能上传 9 张图片", "warning");
    },

    loadTaskForEdit(taskId) {
      this.$get("/task/" + taskId).then((res) => {
        if (res.data.status && res.data.task) {
          const task = res.data.task;
          this.editTaskId = task.id;
          this.taskTitle = task.taskTitle;
          this.taskContext = task.taskContext;
          this.reward = task.reward || 10;
          this.imgList = task.imgList || [];
          this.fileList = (task.imgList || []).map(url => ({
            name: url,
            url: this.getResUrl(url)
          }));
          this.isEditMode = true;
        } else {
          this.$msg("获取求助信息失败", "error");
          this.$router.push("/home/help/published");
        }
      }).catch((err) => {
        console.error(err);
        this.$msg("服务器连接异常", "error");
      });
    },

    cancelEdit() {
      this.isEditMode = false;
      this.editTaskId = null;
      this.taskTitle = "";
      this.taskContext = "";
      this.imgList = [];
      this.fileList = [];
      this.reward = 10;
      this.$router.push("/home/help/published");
    },

    submitTask() {
      if (this.taskTitle && this.taskContext) {
        if (this.isEditMode) {
          this.$put("/task/edit", {
            id: this.editTaskId,
            taskTitle: this.taskTitle,
            taskContext: this.taskContext,
            reward: this.reward,
            imgList: this.imgList,
          }).then((res) => {
            if (res.data.status) {
              this.$msg("修改成功", "success");
              this.$router.push("/home/help/published");
            } else {
              this.$msg(res.data.msg || "修改失败", "error");
            }
          }).catch((err) => {
            console.error(err);
            this.$msg("服务器连接异常", "error");
          });
        } else {
          if (this.user.balance < this.reward) {
            this.$msg("积分不足，当前积分: " + this.user.balance + "，需要: " + this.reward, "error");
            return;
          }

          this.$post("/task", {
            publishId: this.user.id,
            schoolId: this.user.school.id,
            taskTitle: this.taskTitle,
            taskContext: this.taskContext,
            reward: this.reward,
            imgList: this.imgList,
          })
            .then((res) => {
              if (res.data.status) {
                this.createTime = new Date().getTime();
                this.drawer = true;
                this.renew();
                this.$msg(res.data.msg, "success");

                this.taskTitle = "";
                this.taskContext = "";
                this.imgList = [];
                this.fileList = [];
                this.reward = 10;
              } else {
                this.$msg(res.data.msg, "error");
              }
            })
            .catch((err) => {
              console.error(err);
              this.$msg("服务器连接异常", "error");
            });
        }
      } else {
        this.$msg("请完整填写标题和详细描述", "warning");
      }
    },

    renew() {
      this.$get("user/" + this.user.id)
        .then((response) => {
          if (response.data.status) {
            const newUserInfo = response.data.user;
            sessionStorage.setItem("user", JSON.stringify(newUserInfo));
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
    
    if (this.$route.query.edit) {
      this.loadTaskForEdit(this.$route.query.edit);
    }
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
.content {
  background: transparent;
  margin: 0;
  padding: 10px 0;

  .box-card {
    border-radius: 8px;
    border: none;

    .form-wrapper {
      padding: 10px 0;
    }

    .form-item {
      margin-bottom: 20px;
    }

    .label-text {
      font-size: 14px;
      color: #606266;
      background-color: #f5f7fa;
      border: 1px solid #dcdfe6;
      border-bottom: none;
      padding: 0 20px;
      line-height: 38px;
      width: fit-content;
      border-radius: 4px 4px 0 0;
      margin-top: 10px;
      display: inline-block;
    }

    .reward-container {
      border: 1px solid #dcdfe6;
      padding: 20px;
      border-radius: 0 4px 4px 4px;
      background: #fafafa;

      .reward-info {
        margin-bottom: 15px;
        
        .current-balance {
          font-size: 14px;
          color: #606266;
          
          strong {
            color: #ff7d00;
            font-size: 18px;
          }
        }
      }

      .reward-options {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;

        .reward-option {
          width: 80px;
          height: 70px;
          border: 2px solid #dcdfe6;
          border-radius: 8px;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          transition: all 0.3s;
          background: white;

          .reward-amount {
            font-size: 22px;
            font-weight: bold;
            color: #303133;
          }

          .reward-label {
            font-size: 12px;
            color: #909399;
            margin-top: 2px;
          }

          &:hover:not(.disabled) {
            border-color: #409eff;
            background: #ecf5ff;
          }

          &.active {
            border-color: #409eff;
            background: #409eff;
            
            .reward-amount, .reward-label {
              color: white;
            }
          }

          &.disabled {
            cursor: not-allowed;
            opacity: 0.5;
            background: #f5f5f5;
          }
        }
      }

      .reward-tip {
        margin-top: 15px;
        font-size: 12px;
        color: #909399;
        
        i {
          margin-right: 4px;
        }
      }
    }

    .upload-container {
      border: 1px solid #dcdfe6;
      padding: 15px;
      border-radius: 0 4px 4px 4px;
    }

    /deep/ .el-textarea__inner {
      font-family: "Microsoft YaHei", sans-serif !important;
      border-radius: 0 4px 4px 4px;
    }
  }

  .content_drawer {
    padding: 0 20px;

    .drawer-card {
      border-radius: 8px;
      border: 1px solid #ebeef5;
    }

    .preview-text {
      white-space: pre-wrap;
      color: #333;
      
      &.reward-highlight {
        font-size: 18px;
        font-weight: bold;
        color: #ff7d00;
      }
    }

    .preview-images {
      margin-top: 10px;
    }
  }
}
</style>
