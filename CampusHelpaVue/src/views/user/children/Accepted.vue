<template>
  <div class="content">
    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold;">已接收求助</span>
      </div>

      <div v-if="tasks.length > 0">
        <div v-for="(item, index) in tasks" :key="item.id" class="task-item">
          
          <div class="item-header">
            <div class="title-wrapper">
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

            <div class="action-wrapper">
               <el-popconfirm 
                  title="确定取消帮助吗？这将通知发布者。" 
                  @confirm="del(item.id)"
                  v-show="item.state != 2"
                >
                <el-button slot="reference" type="text" class="cancel-btn" icon="el-icon-circle-close">取消帮助</el-button>
              </el-popconfirm>
            </div>
          </div>

          <div class="task-content">
            {{ item.taskContext }}
          </div>

          <el-collapse v-model="activeNames" class="custom-collapse">
            <el-collapse-item :name="index + ''"> <template slot="title">
                <i class="el-icon-user-solid"></i> 发布人详细信息
              </template>
              
              <div class="info-wrapper">
                <el-descriptions title="" :column="3" border size="small">
                  <el-descriptions-item label="发布人">
                    {{ item.publish.username }}
                  </el-descriptions-item>
                  <el-descriptions-item label="电话">
                    {{ item.publish.phone }}
                  </el-descriptions-item>
                  <el-descriptions-item label="学校">
                    {{ item.publish.school.name }}
                  </el-descriptions-item>
                  <el-descriptions-item label="所在系">
                    {{ item.publish.dept.name }}
                  </el-descriptions-item>
                  <el-descriptions-item label="所在班级">
                    {{ item.publish.aclass.name }}
                  </el-descriptions-item>
                  <el-descriptions-item label="接单时间">
                    {{ item.orderTime | formatDate }}
                  </el-descriptions-item>
                </el-descriptions>
                
                </div>
            </el-collapse-item>
          </el-collapse>

          <el-divider v-if="index !== tasks.length - 1"></el-divider>
        </div>
      </div>

      <el-empty v-else description="你还没有接收任何求助，快去广场看看吧"></el-empty>

    </el-card>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";

export default {
  name: "Accepted",
  data() {
    return {
      activeNames: [], // 控制折叠面板
      tasks: [],
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    this.newList();
  },
  methods: {
    del(id) {
      this.$put("/task/takerCancel/" + id).then((res) => {
        this.$notifyMsg("成功", "已取消帮助", "success");
        this.newList();
      });
    },
    newList() {
      this.$get("/task/accepted", { id: this.user.id }).then((res) => {
        this.tasks = res.data.task;
      });
    },
  },
  filters: {
    formatDate(time) {
      if (!time) return '暂无';
      let date = new Date(time);
      return formatDate(date, "yyyy-MM-dd hh:mm");
    },
  },
};
</script>

<style scoped lang="less">
/* 1. 容器样式 */
.content {
  background: transparent;
  margin: 0;
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
        margin-bottom: 15px;

        .title-wrapper {
          display: flex;
          align-items: center;
          .task-title {
            font-size: 16px;
            font-weight: bold;
            color: #303133;
          }
        }
        
        .cancel-btn {
            color: #F56C6C;
            &:hover {
                color: #f78989;
            }
        }
      }

      .task-content {
        font-size: 14px;
        color: #606266;
        line-height: 1.6;
        margin-bottom: 15px;
        padding-left: 5px; /* 稍微缩进一点 */
      }

      /* 自定义折叠面板样式 */
      .custom-collapse {
        border-top: none;
        border-bottom: none;

        /deep/ .el-collapse-item__header {
          border-bottom: none;
          background-color: transparent;
          font-size: 13px;
          color: #909399;
          height: 40px;
          line-height: 40px;
        }
        
        /deep/ .el-collapse-item__wrap {
          border-bottom: none;
        }

        .info-wrapper {
            padding: 10px 0;
        }
      }
    }
  }
}
</style>