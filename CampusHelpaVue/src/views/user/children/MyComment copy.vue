<template>
  <div class="my-comment-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold;">我的评论历史</span>
      </div>

      <div v-if="comments.length > 0">
        <!-- 时间轴样式展示评论 -->
        <el-timeline>
          <el-timeline-item
            v-for="(item, index) in comments"
            :key="index"
            :timestamp="item.createTime | formatDate"
            placement="top"
            color="#409EFF"
          >
            <el-card shadow="hover" class="comment-card">
              <!-- 评论内容 -->
              <div class="comment-content">
                {{ item.content }}
              </div>
              
              <!-- 底部区域：包含来源和删除按钮 -->
              <div class="card-footer">
                <!-- 左侧：来源信息 -->
                <div class="post-source">
                  <span class="label">评论于：</span>
                  <span class="post-title" v-if="item.post" :title="item.post.title">
                    {{ item.post.title }}
                  </span>
                  <span class="post-deleted" v-else>
                    (原贴已删除)
                  </span>
                </div>

                <!-- 右侧：删除操作 -->
                <div class="action-box">
                  <el-popconfirm
                    title="确定要删除这条评论吗？"
                    icon="el-icon-info"
                    icon-color="red"
                    @confirm="handleDelete(item.id)"
                  >
                    <el-button 
                      slot="reference" 
                      type="text" 
                      icon="el-icon-delete" 
                      class="delete-btn"
                    >
                      删除
                    </el-button>
                  </el-popconfirm>
                </div>
              </div>

            </el-card>
          </el-timeline-item>
        </el-timeline>
      </div>
      
      <el-empty v-else description="你还没有发表过评论哦"></el-empty>
    </el-card>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";

export default {
  name: "MyComment",
  data() {
    return {
      comments: []
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    this.fetchMyComments();
  },
  methods: {
    // 获取我的评论列表
    fetchMyComments() {
      this.$get("/comment/my", { userId: this.user.id }).then(res => {
        if (res.data.status) {
          this.comments = res.data.comments;
        } else {
          this.$msg("获取评论失败", "error");
        }
      });
    },

    // 删除评论
    handleDelete(commentId) {
      this.$del("/comment/" + commentId).then(res => {
        if (res.data.status) {
          this.$msg("删除成功", "success");
          // 删除成功后，重新获取列表以刷新页面
          this.fetchMyComments();
        } else {
          this.$msg(res.data.msg || "删除失败", "error");
        }
      });
    }
  },
  filters: {
    formatDate(time) {
      let date = new Date(time);
      return formatDate(date, "yyyy-MM-dd hh:mm");
    },
  }
};
</script>

<style scoped lang="less">
.my-comment-container {
  padding: 10px;
  
  .comment-content {
    font-size: 15px;
    color: #303133;
    margin-bottom: 15px;
    line-height: 1.6;
    word-break: break-all; // 防止长单词/链接撑破布局
  }

  // 底部容器样式
  .card-footer {
    display: flex;
    justify-content: space-between; // 左右对齐
    align-items: center; // 垂直居中
    background: #f5f7fa;
    padding: 8px 12px;
    border-radius: 4px;

    .post-source {
      font-size: 13px;
      flex: 1; // 占据剩余空间
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis; // 标题太长显示省略号
      margin-right: 10px;

      .label {
        color: #909399;
      }
      
      .post-title {
        color: #409EFF;
        font-weight: bold;
        cursor: default;
      }

      .post-deleted {
        color: #909399;
        font-style: italic;
      }
    }

    .action-box {
      .delete-btn {
        color: #F56C6C; // 红色删除按钮
        padding: 0;
        font-size: 13px;
        
        &:hover {
          color: #ff4949;
          text-decoration: underline;
        }
      }
    }
  }
}
</style>