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
      taskTitle: "",
      taskContext: "",
      createTime: "",
      drawer: false,
      activeNames: ["1", "2", "3", "4"],
      // 🟢 关键修改：初始化图片相关数据
      imgList: [],
      fileList: [],
      baseUrl: "http://localhost:8080",
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  methods: {
    ...mapMutations("user", ["setUser"]),

    // 🟢 获取完整资源路径
    getResUrl(url) {
      if (!url) return "";
      if (url.startsWith("http")) return url;
      return this.baseUrl + url;
    },

    // 🟢 图片上传成功回调
    handleUploadSuccess(res, file, fileList) {
      if (res.url) {
        this.imgList.push(res.url);
      } else {
        this.$msg("图片上传返回值异常", "error");
      }
    },

    // 🟢 图片移除回调
    handleRemove(file, fileList) {
      // 这里的处理逻辑需要兼容上传时返回的 response
      const urlToRemove = file.response ? file.response.url : file.url;
      this.imgList = this.imgList.filter((url) => url !== urlToRemove);
    },

    // 🟢 超出限制提示
    handleExceed() {
      this.$msg("最多只能上传 9 张图片", "warning");
    },

    submitTask() {
      if (this.taskTitle && this.taskContext) {
        if (this.user.balance < 10) {
          this.$msg("积分不足，发布求助需要 10 积分", "error");
          return;
        }

        // 发送请求，🟢 加入了 imgList
        this.$post("/task", {
          publishId: this.user.id,
          schoolId: this.user.school.id,
          taskTitle: this.taskTitle,
          taskContext: this.taskContext,
          imgList: this.imgList, // 这里传的是 ['/upload/1.jpg', '/upload/2.jpg']
        })
          .then((res) => {
            if (res.data.status) {
              this.createTime = new Date().getTime();
              this.drawer = true;
              this.renew();
              this.$msg(res.data.msg, "success");

              // 🟢 重置表单
              this.taskTitle = "";
              this.taskContext = "";
              this.imgList = [];
              this.fileList = [];
            } else {
              this.$msg(res.data.msg, "error");
            }
          })
          .catch((err) => {
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

    /* 🟢 关键修改：图片上传区域样式 */
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
    }

    .preview-images {
      margin-top: 10px;
    }
  }
}
</style>
