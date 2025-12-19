<template>
  <div class="content">
    <el-alert
      :title="user.school.name + ' - 互助平台共 ' + tasks.length + ' 个求助'"
      :closable="false"
      type="info"
      style="margin-bottom: 10px;"
    >
    </el-alert>

    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold;">求助广场</span>
        <el-button style="float: right; padding: 3px 0; font-size: 14px" type="text" icon="el-icon-refresh">最新</el-button>
      </div>
      
      <div v-if="tasks.length > 0">
        <div v-for="item in tasks" :key="item.id" class="task-item">
          
          <div class="task-header">
            <div class="title-wrapper">
              <el-tag 
                :type="item.state == 0 ? 'success' : 'info'" 
                size="small"
                effect="dark"
                style="margin-right: 8px"
              >
                {{ item.state == 0 ? '待解决' : '已解决' }}
              </el-tag>
              
              <span class="task-title" :class="{ 'solved': item.state != 0 }">
                 {{ item.taskTitle }}
              </span>
            </div>

            <div class="action-btn">
              <el-button
                size="small"
                type="primary"
                plain
                v-show="user.id != item.publish.id && item.state == 0"
                @click="acceptTask(item.id)"
              >
                接受求助
              </el-button>

              <el-tag type="warning" v-show="user.id == item.publish.id" size="medium" effect="plain">
                本人求助
              </el-tag>
            </div>
          </div>
          
          <div class="task-content">
             {{ item.taskContext }}
          </div>

          <div class="task-footer">
            <span class="user-info">
              <i class="el-icon-user-solid"></i> {{ item.publish.username }}
            </span>
            <span class="time-info">
              {{ item.createTime | formatDate }}
            </span>
          </div>

          <el-divider></el-divider>
        </div>
      </div>

      <el-empty v-else description="暂时没有求助任务，休息一下吧~"></el-empty>
    </el-card>
  </div>
</template>

<script>
import { mapMutations, mapState } from "vuex";
import { formatDate } from "@/util/date";

export default {
  name: "Index",
  data() {
    return {
      tasks: [],
    };
  },

  methods: {
    acceptTask(id) {
      this.$msgbox({
        title: "提示",
        message: "确定接受此求助吗？请确保您有能力解决该问题。",
        showCancelButton: true,
        confirmButtonText: "确定接受",
        cancelButtonText: "取消",
        type: 'warning',
        beforeClose: (action, instance, done) => {
          if (action == "confirm") {
            instance.confirmButtonText = "执行中...";
            instance.confirmButtonLoading = true;
            this.$put("task/takerAccept", {
              id: id,
              acceptId: this.user.id,
            }).then((res) => {
              done();
              instance.confirmButtonLoading = false;
              this.$msg(res.data.msg, "success");
              this.$router.push("/home/accepted");
            });
          } else {
            done();
          }
        },
      }).catch(() => {});
    },
  },

  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    this.$get("/task", { id: this.user.id }).then((res) => {
      let list = res.data.task;
      
      // 排序规则：待解决优先，时间倒序
      list.sort((a, b) => {
        if (a.state === b.state) {
          return new Date(b.createTime) - new Date(a.createTime);
        }
        return a.state - b.state;
      });

      this.tasks = list;
    });
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
/* 1. 容器样式重置 */
.content {
  background: transparent;
  margin: 0;
  padding: 10px 0; /* 上下10px，左右0 */

  /* 2. 主卡片样式 */
  .box-card {
    border-radius: 8px;
    border: none;
    
    /* 列表项样式 */
    .task-item {
      padding: 5px 0;
      
      .task-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;

        .title-wrapper {
          display: flex;
          align-items: center;
          
          .task-title {
            font-size: 16px;
            font-weight: bold;
            color: #303133;
            
            &.solved {
              color: #909399;
              text-decoration: line-through; /* 已解决的加个删除线效果，可选 */
            }
          }
        }
      }

      .task-content {
        font-size: 14px;
        color: #606266;
        line-height: 1.6;
        margin-bottom: 12px;
        /* 最多显示两行，超出省略 */
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 2;
        overflow: hidden;
      }

      .task-footer {
        display: flex;
        justify-content: space-between;
        font-size: 13px;
        color: #909399;
        
        .user-info {
          display: flex;
          align-items: center;
          i { margin-right: 4px; }
        }
      }
    }
  }
}
</style>