<template>
  <div class="remark-container">
    <el-card class="box-card" shadow="never">
      <div slot="header" class="card-header">
        <span class="header-title">我的评价记录</span>
        <span class="header-count" v-if="total > 0">共 {{ total }} 条</span>
      </div>

      <div v-if="remarkList.length > 0">
        <div
          v-for="(item, index) in remarkList"
          :key="item.id"
          class="remark-item"
        >
          <div class="item-main">
            <div class="item-header">
              <div class="star-wrapper">
                <span class="label">评分</span>
                <el-rate
                  v-model="item.star"
                  disabled
                  show-score
                  text-color="#ff9900"
                  score-template="{value} 分"
                >
                </el-rate>
              </div>

              <div class="action-btns">
                <el-button
                  type="text"
                  icon="el-icon-edit"
                  size="small"
                  class="btn-edit"
                  @click="handleUpdate(item)"
                  >修改</el-button
                >
                <el-popconfirm
                  title="确定删除这条评价吗？"
                  @confirm="handleDelete(item)"
                >
                  <el-button
                    slot="reference"
                    type="text"
                    icon="el-icon-delete"
                    class="btn-delete"
                    size="small"
                    >删除</el-button
                  >
                </el-popconfirm>
              </div>
            </div>

            <div class="item-content">
              {{ item.remark }}
            </div>

            <div class="item-meta">
              <div class="seeker-info">
                <span class="info-tag">
                  <i class="el-icon-s-custom"></i>
                  <span class="label-text">互助者:</span>
                  <span class="highlight">
                    {{
                      item.task && item.task.accept
                        ? item.task.accept.username
                        : "未知用户"
                    }}
                  </span>
                </span>

                <span class="info-tag">
                  <i class="el-icon-phone"></i>
                  <span class="label-text">电话:</span>
                  <span class="highlight">
                    {{
                      item.task && item.task.accept
                        ? item.task.accept.phone
                        : "暂无"
                    }}
                  </span>
                </span>

                <span class="info-tag task-title-tag" v-if="item.task">
                  <i class="el-icon-document"></i>
                  <span>{{ item.task.taskTitle }}</span>
                </span>
              </div>

              <div class="task-id">
                <span>ID: #{{ item.taskId }}</span>
              </div>
            </div>
          </div>

          <el-divider
            v-if="index !== remarkList.length - 1"
            class="custom-divider"
          ></el-divider>
        </div>
      </div>

      <el-empty v-else description="暂无评价记录"></el-empty>
    </el-card>

    <el-dialog
      :title="title"
      :visible.sync="open"
      width="500px"
      append-to-body
      custom-class="custom-dialog"
    >
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="评分" prop="star">
          <el-rate
            v-model="form.star"
            show-text
            :texts="['极差', '失望', '一般', '满意', '惊喜']"
          >
          </el-rate>
        </el-form-item>

        <el-form-item label="评价内容" prop="remark">
          <el-input
            type="textarea"
            :rows="4"
            v-model="form.remark"
            placeholder="请输入您对本次帮助的评价..."
            maxlength="200"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  listRemark,
  getRemark,
  delRemark,
  addRemark,
  updateRemark,
} from "@/api/remark/remark";
import { mapState } from "vuex";

export default {
  name: "Remark",
  data() {
    return {
      loading: true,
      total: 0,
      remarkList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        publishId: null,
      },
      form: {},
      rules: {
        star: [{ required: true, message: "请打分", trigger: "change" }],
        remark: [
          { required: true, message: "请输入评价内容", trigger: "blur" },
        ],
      },
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    if (this.user && this.user.id) {
      this.queryParams.publishId = this.user.id;
      this.getList();
    }
  },
  methods: {
    /** 查询remark列表 - 使用稳健的获取方式 */
    getList() {
      this.loading = true;
      listRemark(this.queryParams)
        .then((res) => {
          // 核心修复：兼容 res.data 和 res
          const body = res.data ? res.data : res;

          if (body && body.rows) {
            this.remarkList = body.rows;
            this.total = body.total;
          } else {
            this.remarkList = [];
            this.total = 0;
          }
          this.loading = false;
        })
        .catch((err) => {
          this.loading = false;
        });
    },

    cancel() {
      this.open = false;
      this.reset();
    },

    reset() {
      this.form = {
        id: null,
        star: 5,
        remark: null,
        taskId: null,
        acceptId: null,
        publishId: null,
      };
    },

    handleUpdate(row) {
      this.reset();
      const id = row.id;
      getRemark(id).then((response) => {
        // 核心修复：兼容 res.data
        this.form = response.data ? response.data : response;
        this.open = true;
        this.title = "修改评价";
      });
    },

    submitForm() {
      this.$refs["form"].validate((valid) => {
        if (valid) {
          if (this.form.id != null) {
            updateRemark(this.form).then((response) => {
              this.$message.success("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addRemark(this.form).then((response) => {
              this.$message.success("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },

    handleDelete(row) {
      const ids = row.id;
      delRemark(ids)
        .then((response) => {
          this.$message.success("删除成功");
          this.getList();
        })
        .catch(() => {});
    },
  },
};
</script>

<style scoped lang="less">
/* 容器：去掉背景，上下留白 */
.remark-container {
  background: transparent;
  padding: 0;

  /* 主卡片：去边框，去阴影，圆角 */
  .box-card {
    border-radius: 8px;
    border: none;
    background-color: #fff; /* 确保卡片是白色的 */

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-bottom: 5px;

      .header-title {
        font-size: 18px;
        font-weight: bold;
        color: #303133;
      }
      .header-count {
        font-size: 13px;
        color: #909399;
      }
    }

    .remark-item {
      padding: 15px 0 5px 0;

      /* 头部区域 */
      .item-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;

        .star-wrapper {
          display: flex;
          align-items: center;
          .label {
            font-size: 14px;
            color: #606266;
            margin-right: 12px;
            font-weight: 500;
          }
        }

        .action-btns {
          /* 按钮平时是灰色的，鼠标悬停变色 */
          .btn-edit {
            color: #909399;
            &:hover {
              color: #409eff;
            }
          }
          .btn-delete {
            color: #909399;
            margin-left: 10px;
            &:hover {
              color: #f56c6c;
            }
          }
        }
      }

      /* 核心内容区：做成气泡样式 */
      .item-content {
        font-size: 15px;
        color: #303133;
        line-height: 1.6;
        margin-bottom: 16px;
        background: #f8f9fa; /* 浅灰色背景 */
        padding: 15px;
        border-radius: 6px;
        position: relative;
      }

      /* 底部信息栏 */
      .item-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 13px;
        color: #909399;
        padding: 0 5px;

        .seeker-info {
          display: flex;
          align-items: center;
          flex-wrap: wrap;

          .info-tag {
            margin-right: 25px;
            display: flex;
            align-items: center;

            i {
              margin-right: 6px;
              color: #409eff; /* 图标蓝色 */
              font-size: 14px;
            }

            .label-text {
              margin-right: 4px;
            }

            .highlight {
              color: #303133;
              font-weight: 500;
            }
          }

          .task-title-tag {
            background: #ecf5ff;
            padding: 2px 8px;
            border-radius: 4px;
            color: #409eff;
            i {
              color: #409eff;
            }
          }
        }

        .task-id {
          color: #c0c4cc;
          font-size: 12px;
          font-family: monospace;
        }
      }

      .custom-divider {
        background-color: #f0f2f5;
        margin: 20px 0 0 0;
      }
    }
  }
}
</style>
