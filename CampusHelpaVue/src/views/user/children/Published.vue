<template>
  <div class="published-container">
    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold;">已发布求助</span>
      </div>

      <div v-if="tasks.length > 0">
        <div v-for="(item, index) in tasks" :key="item.id" class="task-item">
          
          <div class="item-header">
            <div class="title-section">
              <el-tag 
                :type="item.state == 0 ? 'danger':(item.state == 1 ? 'warning':'success')"
                effect="dark"
                size="small"
                style="margin-right: 10px"
              >
                {{item.state == 0 ? '待解决':(item.state == 1 ? '服务中':'已完成')}}
              </el-tag>
              <span class="task-title">{{ item.taskTitle }}</span>
            </div>

            <div class="action-section">
              <el-button 
                v-show="item.state == 2"
                type="text" 
                icon="el-icon-star-off"
                @click="remark(item)"
              >
                订单评价
              </el-button>

              <el-button 
                v-show="item.state != 0"
                type="text" 
                icon="el-icon-user"
                @click="receiver(item)"
              >
                查看接受人
              </el-button>

              <el-popconfirm 
                title="确定取消这条求助吗？" 
                @confirm="cancel(item.id)" 
                @onConfirm="cancel(item.id)"
                v-show="item.state == 0"
              >
                <el-button slot="reference" type="text" style="color: #F56C6C">取消求助</el-button>
              </el-popconfirm>
            </div>
          </div>

          <div class="step-wrapper">
            <el-steps :active="item.state + 1" finish-status="success" align-center size="small">
              <el-step title="发布成功" :description="item.createTime | formatDate"></el-step>
              <el-step title="服务中" :description="item.orderTime ? transform(item.orderTime):'等待接单'"></el-step>
              <el-step title="已完成" :description="item.endTime ? transform(item.endTime):''"></el-step>
            </el-steps>
          </div>

          <el-collapse v-model="activeNames" class="custom-collapse">
            <el-collapse-item name="1">
              <template slot="title">
                <i class="el-icon-document"></i> 展开详情内容
              </template>
              <div class="detail-content">
                <p><strong>求助内容：</strong>{{ item.taskContext }}</p>
                </div>
            </el-collapse-item>
          </el-collapse>

          <div class="item-footer" v-show="item.state == 1">
            <el-button 
              type="primary" 
              size="small" 
              plain
              @click="completeTask(item.id)"
              icon="el-icon-check"
            >
              确认完成求助
            </el-button>
          </div>

          <el-divider v-if="index !== tasks.length - 1"></el-divider>
        </div>
      </div>

      <el-empty v-else description="你还没有发布过求助"></el-empty>
    </el-card>

    <el-drawer
      title="接受人信息"
      :visible.sync="drawer"
      direction="rtl"
      size="30%">
      <div class="content_drawer">
        <el-card shadow="never" class="info-card" v-if="recipientInformation">
          <div class="info-row">
            <label>姓名：</label> <span>{{recipientInformation.username}}</span>
          </div>
          <div class="info-row">
            <label>电话：</label> <span>{{recipientInformation.phone}}</span>
          </div>
          <div class="info-row">
            <label>学校：</label> <span>{{recipientInformation.school ? recipientInformation.school.name : '-'}}</span>
          </div>
          <div class="info-row">
            <label>系部：</label> <span>{{recipientInformation.dept ? recipientInformation.dept.name : '-'}}</span>
          </div>
          <div class="info-row">
            <label>班级：</label> <span>{{recipientInformation.aclass ? recipientInformation.aclass.name : '-'}}</span>
          </div>
        </el-card>
      </div>
    </el-drawer>

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="星级" prop="star">
          <el-rate v-model="form.star" show-text></el-rate>
        </el-form-item>
        <el-form-item label="评价内容" prop="remark">
          <el-input type="textarea" v-model="form.remark" placeholder="请输入评价内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="exit">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";
import { addRemark } from "@/api/remark/remark";

export default {
  name: "Published",
  data() {
    return {
      open: false,
      activeNames: [], // 默认不展开，保持页面整洁
      tasks: [],
      drawer: false,
      recipientInformation: {}, // 初始化为空对象
      currentTask: null, // 新增：用于存储当前正在操作（评价）的那个任务对象
      form: {},
      rules: {},
      title: "",
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    this.retrieveData();
  },
  methods: {
    retrieveData() {
      this.$get("/task/published", { id: this.user.id }).then((res) => {
        this.tasks = res.data.task;
      });
    },
    receiver(val) {
      if (val.accept) {
        this.recipientInformation = val.accept;
        this.drawer = true;
      } else {
        this.$msg("暂无接受人详细信息", "warning");
      }
    },

    transform(time) {
      let date = new Date(time);
      return formatDate(date, "yyyy-MM-dd hh:mm");
    },

    cancel(id) {
      this.$del("/task/" + id).then((res) => {
        this.retrieveData();
        this.$msg(res.data.msg, "success"); // notifyMsg 改回 msg 保持一致
      });
    },

    completeTask(id) {
      this.$msgbox({
        title: "确认完成",
        message: "确定接受人已经解决了您的问题吗？",
        showCancelButton: true,
        confirmButtonText: "确定完成",
        cancelButtonText: "取消",
        type: "success",
        beforeClose: (action, instance, done) => {
          if (action == "confirm") {
            instance.confirmButtonText = "执行中...";
            instance.confirmButtonLoading = true;
            this.$put("task/" + id).then((res) => {
              done();
              instance.confirmButtonLoading = false;
              this.$msg(res.data.msg, "success");
              this.retrieveData();
            });
          } else {
            done();
          }
        },
      }).catch(() => {});
    },

    // 打开评价弹窗
    remark(item) {
      this.currentTask = item; // 关键：保存当前操作的任务
      this.reset();
      this.open = true;
      this.title = "评价服务";
    },

    // 提交评价
    submitForm() {
      // 这里的 val 已经没用了，使用 this.currentTask
      const val = this.currentTask;
      
      if (!this.form.star) {
        this.$message("请选择星级评分");
        return;
      } else if (!this.form.remark) {
        this.$message("请输入评价内容");
        return;
      }

      const aid = val.accept.id;
      const taskid = val.id;
      const pid = val.publish.id;

      addRemark({
        star: this.form.star,
        remark: this.form.remark,
        acceptId: aid,
        publishId: pid,
        taskId: taskid,
      }).then((response) => {
        this.$message.success("评价成功");
        this.open = false;
        // 评价完可能需要刷新列表状态，防止重复评价
        // this.retrieveData(); 
      });
    },

    exit() {
      this.open = false;
      this.reset();
    },

    reset() {
      this.form = {
        id: null,
        star: null,
        remark: null,
      };
    },
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
/* 1. 容器样式 */
.published-container {
  background: transparent;
  padding: 10px 0;

  /* 2. 主卡片样式 */
  .box-card {
    border-radius: 8px;
    border: none;
    
    /* 列表项 */
    .task-item {
      padding: 10px 0;

      .item-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;

        .title-section {
          display: flex;
          align-items: center;
          .task-title {
            font-size: 16px;
            font-weight: bold;
            color: #303133;
          }
        }

        .action-section {
          .el-button {
            margin-left: 10px;
            font-size: 14px;
          }
        }
      }

      .step-wrapper {
        padding: 0 20px;
        margin-bottom: 20px;
      }
      
      /* 自定义折叠面板样式，使其不那么突兀 */
      .custom-collapse {
        border-top: none;
        border-bottom: none;
        
        /deep/ .el-collapse-item__header {
          border-bottom: none;
          color: #909399;
          font-size: 13px;
          height: 35px;
          line-height: 35px;
        }

        /deep/ .el-collapse-item__wrap {
          border-bottom: none;
        }
        
        .detail-content {
          padding: 10px 20px;
          background-color: #f8f8f8;
          border-radius: 4px;
          color: #606266;
          font-size: 14px;
        }
      }

      .item-footer {
        text-align: right;
        margin-top: 10px;
      }
    }
  }

  /* 抽屉内容 */
  .content_drawer {
    padding: 20px;
    
    .info-card {
      border: 1px solid #EBEEF5;
      
      .info-row {
        margin-bottom: 15px;
        font-size: 14px;
        display: flex;
        
        label {
          color: #909399;
          width: 60px;
          text-align: right;
          margin-right: 10px;
        }
        span {
          color: #303133;
          flex: 1;
        }
      }
    }
  }
}
</style>