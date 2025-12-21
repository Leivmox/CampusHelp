<template>
  <div class="my-comment-container">
    <el-card class="box-card" shadow="never">
      <div slot="header" class="clearfix">
        <span style="font-size: 18px; font-weight: bold;">我的评论历史</span>
      </div>

      <div v-if="comments.length > 0">
        <el-timeline>
          <el-timeline-item
            v-for="(item, index) in comments"
            :key="index"
            :timestamp="item.createTime | formatDate"
            placement="top"
            color="#409EFF"
          >
            <el-card shadow="hover" class="comment-card">
              
              <div class="top-row">
                <div class="comment-content">
                  {{ item.content }}
                </div>

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
              
              <div class="post-source-bar">
                <span class="label">来源于帖子：</span>
                <span 
                  class="post-title" 
                  v-if="item.post" 
                  :title="item.post.title"
                  @click="toPostDetail(item.post.id)"
                >
                  {{ item.post.title }}
                </span>
                <span class="post-deleted" v-else>
                  (原贴已删除)
                </span>
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

    // 🟢 修改点 2: 添加跳转方法
    toPostDetail(postId) {
      if (!postId) return;
      // 使用 router/index.js 中定义的 name: 'PostDetail' 进行跳转
      this.$router.push({
        name: "PostDetail",
        params: { id: postId }
      });
    },

    // 删除评论
    handleDelete(commentId) {
      this.$del("/comment/" + commentId).then(res => {
        if (res.data.status) {
          this.$msg("删除成功", "success");
          this.fetchMyComments();
        } else {
          this.$msg(res.data.msg || "删除失败", "error");
        }
      }).catch(err => {
        console.error("删除请求报错:", err);
        this.$msg("请求异常", "error");
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
  background: transparent;
  padding: 10px 0;
  
  .box-card {
    border-radius: 8px;
    border: none;
  }

  .comment-card {
    border-radius: 6px;
  }
  
  .top-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 10px;

    .comment-content {
      flex: 1;
      font-size: 15px;
      color: #303133;
      line-height: 1.6;
      word-break: break-all;
      margin-right: 15px;
    }

    .action-box {
      .delete-btn {
        color: #F56C6C; 
        padding: 0; 
        font-size: 14px;
        
        &:hover {
          color: #ff4949;
        }
      }
    }
  }

  .post-source-bar {
    background: #f5f7fa;
    padding: 8px 12px;
    border-radius: 4px;
    font-size: 13px;
    color: #606266;

    .label {
      color: #909399;
    }
    
    // 🟢 修改点 3: 修改样式，让它看起来像链接
    .post-title {
      color: #409EFF;
      font-weight: bold;
      margin-left: 5px;
      cursor: pointer; // 变成小手
      transition: all 0.2s; // 添加过渡效果

      // 鼠标悬浮时添加下划线，颜色加深
      &:hover {
        text-decoration: underline;
        color: #2b85e4;
      }
    }

    .post-deleted {
      color: #909399;
      font-style: italic;
      margin-left: 5px;
    }
  }
}
</style>