<template>
  <div class="content">
    <el-alert
      :title="user.school.name + '- - -互助平台共' + tasks.length + '个求助'"
      :closable="false"
      type="info"
    >
    </el-alert>

    <div>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <span>求助广场</span>
          <el-button style="float: right; padding: 3px 0" type="text">最新</el-button>
        </div>
        
        <el-card class="box-card" v-for="item in tasks" :key="item.id">
          <div
            slot="header"
            class="clearfix"
            style="display: flex; align-items: center; justify-content: space-between"
          >
            <span>
              <el-tag 
                :type="item.state == 0 ? 'success' : 'info'" 
                style="margin-right: 5px"
                effect="dark"
              >
                {{ item.state == 0 ? '待解决' : '已解决' }}
              </el-tag>
              
              <span :style="{ color: item.state == 0 ? '#303133' : '#909399' }">
                 {{ item.taskTitle }}
              </span>
            </span>

            <el-button
              style="float: right; padding: 3px 0"
              type="text"
              v-show="user.id != item.publish.id && item.state == 0"
              @click="acceptTask(item.id)"
            >
              接受求助
            </el-button>

            <el-button
              style="float: right; padding: 3px 0"
              type="text"
              v-show="user.id == item.publish.id"
            >
              本人求助
            </el-button>
          </div>
          
          <div class="text item">
            <p class="el-icon-s-custom" :style="{ color: item.state == 0 ? '#606266' : '#999' }">
              {{ item.publish.username }}
              <span style="margin-left: 10px;">{{ item.taskContext }}</span>
            </p>
            <span style="float: right; color: #909399">{{ item.createTime | formatDate }}</span>
          </div>
        </el-card>

        <div style="text-align: center" v-if="tasks.length == 0">
          <span><i class="el-icon-refresh-right"></i>暂无求助</span>
        </div>
      </el-card>
    </div>
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
        message: "确定接受此求助吗？",
        showCancelButton: true,
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        beforeClose: (action, instance, done) => {
          if (action == "confirm") {
            instance.confirmButtonText = "执行中...";
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
      // 修改点4：获取数据后进行排序
      let list = res.data.task;
      
      // 使用 sort 方法排序
      // 规则：state=0 (待解决) 排在前面，其他状态 (已解决) 排在后面
      // 如果状态相同，则按时间倒序（新的在上面）
      list.sort((a, b) => {
        if (a.state === b.state) {
          // 如果状态一样，按时间降序（最新的在上面）
          return new Date(b.createTime) - new Date(a.createTime);
        }
        // 状态不一样，0在前面
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
.content {
  background: #fff;
  margin: 0 15px;
  padding: 15px;

  .card h2 {
    font-weight: normal;
    font-size: 18px;

    span {
      font-size: 12px;
      display: inline-block;
      border: 1px solid red;
      padding: 1px 3px;
    }
  }
}

/deep/ .el-alert--info.is-light {
  height: 50px;
}

/deep/ .el-select .el-input {
  width: 130px;
}

/deep/ .input-with-select .el-input-group__prepend {
  background-color: #fff;
}

/deep/ .el-card {
  margin-bottom: 20px;
}
</style>