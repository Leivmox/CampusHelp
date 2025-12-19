<template>
  <div class="remark-container">
    <el-card class="box-card" shadow="never">
      <div slot="header" class="card-header">
        <div class="header-left">
           <span class="header-title">我收到的评价</span>
           <span class="header-desc">（来自求助者的反馈）</span>
        </div>
        <span class="header-count" v-if="total > 0">共 {{ total }} 条</span>
      </div>

      <div v-if="remarkList.length > 0">
        <div v-for="(item, index) in remarkList" :key="item.id" class="remark-item">
          
          <div class="item-main">
            <div class="item-header">
              <div class="star-wrapper">
                <span class="label">对方评分</span>
                <el-rate
                  v-model="item.star"
                  disabled
                  show-score
                  text-color="#ff9900"
                  score-template="{value} 分">
                </el-rate>
              </div>
            </div>

            <div class="item-content">
              {{ item.remark || '对方没有留下文字评价' }}
            </div>

            <div class="item-meta">
              <div class="seeker-info">
                 <span class="info-tag">
                    <i class="el-icon-user"></i>
                    <span class="label-text">求助者:</span>
                    <span class="highlight">
                        {{ (item.task && item.task.publish) ? item.task.publish.username : '未知用户' }}
                    </span>
                 </span>
                 
                 <span class="info-tag">
                    <i class="el-icon-phone-outline"></i>
                    <span class="label-text">电话:</span>
                    <span class="highlight">
                        {{ (item.task && item.task.publish) ? (item.task.publish.phone || item.task.publish.phonenumber) : '暂无' }}
                    </span>
                 </span>

                 <span class="info-tag task-title-tag" v-if="item.task">
                    <i class="el-icon-document"></i>
                    <span>{{ item.task.taskTitle }}</span>
                 </span>
              </div>

              <div class="task-id">
                <span>任务ID: #{{ item.taskId }}</span>
              </div>
            </div>
          </div>

          <el-divider v-if="index !== remarkList.length - 1" class="custom-divider"></el-divider>
        </div>
      </div>

      <el-empty v-else description="暂无收到的评价"></el-empty>
    </el-card>
  </div>
</template>

<script>
import { listRemark } from "@/api/remark/remark";
import { mapState } from "vuex";

export default {
  name: "RemarkReceived",
  data() {
    return {
      loading: true,
      total: 0,
      remarkList: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
      },
    };
  },
  computed: {
    ...mapState("user", ["user"]),
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询列表 */
    getList() {
      this.loading = true;
      // 构造查询参数：我是接受者(acceptId)，我要看谁评价了我
      const params = {
          ...this.queryParams,
          acceptId: this.user.id 
      };

      listRemark(params).then((res) => {
        const body = res.data ? res.data : res;
        if (body && body.rows) {
            this.remarkList = body.rows;
            this.total = body.total;
        } else {
            this.remarkList = [];
            this.total = 0;
        }
        this.loading = false;
      }).catch(err => {
          this.loading = false;
      });
    }
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
    background-color: #fff; 

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-bottom: 5px;
      
      .header-left {
          display: flex;
          align-items: baseline;
          .header-title {
              font-size: 18px; 
              font-weight: bold; 
              color: #303133;
          }
          .header-desc {
              font-size: 13px;
              color: #909399;
              margin-left: 8px;
          }
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
      }

      /* 核心内容区 */
      .item-content {
        font-size: 15px;
        color: #303133;
        line-height: 1.6;
        margin-bottom: 16px;
        background: #f0f9eb; /* 浅绿色背景 */
        padding: 15px;
        border-radius: 6px;
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
                margin-right: 20px;
                display: flex;
                align-items: center;
                
                i {
                    margin-right: 6px;
                    color: #67C23A; /* 绿色图标 */
                    font-size: 14px;
                }
                
                .label-text { margin-right: 4px; }
                .highlight { color: #303133; font-weight: 500; }
            }
            
            /* 任务标题 tag 样式 (纯展示) */
            .task-title-tag {
                background: #f0f9eb;
                padding: 4px 10px;
                border-radius: 4px; 
                color: #67C23A;
            }
        }

        .task-id {
            color: #C0C4CC;
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