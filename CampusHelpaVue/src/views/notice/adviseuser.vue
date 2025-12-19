<template>
  <div class="app-container">
    <el-card class="box-card" shadow="never">
      
      <div class="card-header-wrapper">
        <div class="left-title">
          <i class="el-icon-bell header-icon"></i>
          <span>系统公告</span>
        </div>
        
        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" class="top-search-form">
          <el-form-item prop="noticeTitle" style="margin-bottom: 0">
            <el-input
              v-model="queryParams.noticeTitle"
              placeholder="搜索标题"
              prefix-icon="el-icon-search"
              clearable
              @keyup.enter.native="handleQuery"
            />
          </el-form-item>
           <el-form-item style="margin-bottom: 0">
            <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>
      </div>

      <div class="notice-list" v-loading="loading">
        <el-empty v-if="adviseList.length === 0" description="暂无公告信息"></el-empty>

        <div v-else class="notice-item" v-for="(item, index) in adviseList" :key="item.noticeId">
          
          <div class="item-header">
            <div class="title-section">
              <span class="status-dot"></span> <span class="notice-title">{{ item.noticeTitle }}</span>
              <el-tag size="mini" effect="plain" class="role-tag" v-if="item.createBy">
                 {{ item.createBy }}
              </el-tag>
            </div>
            
            <div class="time-section">
               <i class="el-icon-time"></i> {{ transform(item.createTime) }}
            </div>
          </div>

          <div class="item-content-bubble">
             <div class="bubble-text">
               {{ item.noticeContent }}
             </div>
             
             <div class="bubble-footer" v-if="item.remark">
                <i class="el-icon-info"></i> 备注: {{ item.remark }}
             </div>
          </div>

          <el-divider v-if="index !== adviseList.length - 1" class="custom-divider"></el-divider>
        </div>
      </div>

    </el-card>
  </div>
</template>

<script>
import { listAdvise } from "@/api/notice/advise";
import { formatDate } from '@/util/date';

export default {
  name: "Advise",
  data() {
    return {
      loading: true,
      total: 0,
      adviseList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        noticeTitle: null,
        noticeContent: null,
      },
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询公告列表 */
    getList() {
      this.loading = true;
      listAdvise(this.queryParams).then(response => {
        // 兼容处理：防止后端直接返回数组没有rows
        if (response.rows) {
             this.adviseList = response.rows;
             this.total = response.total;
        } else if (response.data && response.data.rows) {
             this.adviseList = response.data.rows;
             this.total = response.data.total;
        } else {
             this.adviseList = [];
        }
        this.loading = false;
      }).catch(() => {
          this.loading = false;
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.queryParams.noticeTitle = null;
      this.queryParams.noticeContent = null;
      this.handleQuery();
    },
    transform(time) {
      if (!time) return '';
      let date = new Date(time);
      return formatDate(date, 'yyyy-MM-dd HH:mm'); // 精确到分钟可能更好看
    }
  }
};
</script>

<style scoped lang="less">
/* 1. 外层容器：透明，去背景 */
.app-container {
  background: transparent;
  padding: 10px 0;
  // max-width: 1000px;
  margin: 0 auto;

  /* 2. 主卡片：白底，圆角，去边框，去阴影(shadow="never") */
  .box-card {
    border-radius: 8px;
    border: none;
    background: #fff;
    min-height: 80vh; /* 保证高度，看起来大气 */

    /* 顶部 标题+搜索 布局 */
    .card-header-wrapper {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 25px;
      padding-bottom: 15px;
      border-bottom: 1px solid #f0f2f5;

      .left-title {
        font-size: 18px;
        font-weight: bold;
        color: #303133;
        display: flex;
        align-items: center;

        .header-icon {
          color: #409EFF;
          margin-right: 8px;
          font-size: 20px;
        }
      }

      .top-search-form {
        /* 让搜索框稍微紧凑一点 */
        display: flex;
        align-items: center;
      }
    }

    /* 列表单项样式 */
    .notice-item {
      padding: 10px 10px;

      /* 头部：标题行 */
      .item-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;

        .title-section {
          display: flex;
          align-items: center;

          .status-dot {
            width: 8px;
            height: 8px;
            background-color: #409EFF;
            border-radius: 50%;
            margin-right: 10px;
            box-shadow: 0 0 4px rgba(64, 158, 255, 0.5);
          }

          .notice-title {
            font-size: 16px;
            font-weight: 600;
            color: #303133;
            margin-right: 10px;
          }

          .role-tag {
            border: none;
            background: #e8f3ff;
            color: #409EFF;
          }
        }

        .time-section {
          font-size: 13px;
          color: #909399;
          i { margin-right: 4px; }
        }
      }

      /* 内容气泡：模仿微信/评价页面的气泡风格 */
      .item-content-bubble {
        background-color: #f8f9fa; /* 极淡灰 */
        border-radius: 6px;
        padding: 16px;
        position: relative;
        margin-left: 18px; /* 稍微缩进一点，和标题对齐 */

        .bubble-text {
          font-size: 14px;
          color: #505255;
          line-height: 1.7;
          white-space: pre-wrap; /* 保留换行 */
          text-align: justify;
        }

        .bubble-footer {
          margin-top: 12px;
          padding-top: 8px;
          border-top: 1px dashed #ebeef5;
          font-size: 12px;
          color: #909399;
          i { color: #E6A23C; margin-right: 4px; }
        }

        /* 可选：加一个小三角箭头指向左上 (装饰性) */
        &::before {
           content: "";
           position: absolute;
           top: -6px;
           left: 20px;
           width: 0;
           height: 0;
           border-left: 6px solid transparent;
           border-right: 6px solid transparent;
           border-bottom: 6px solid #f8f9fa;
        }
      }

      .custom-divider {
        background-color: #f0f2f5;
        margin: 25px 0 10px 0;
      }
    }
  }
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .card-header-wrapper {
    flex-direction: column;
    align-items: flex-start !important;
    .top-search-form {
      margin-top: 15px;
      width: 100%;
      justify-content: space-between;
    }
  }
}
</style>