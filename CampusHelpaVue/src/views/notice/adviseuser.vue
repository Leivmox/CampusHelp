<template>
  <div class="app-container">
    <el-card shadow="never" class="search-card">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="公告标题" prop="noticeTitle">
          <el-input
            v-model="queryParams.noticeTitle"
            placeholder="请输入公告标题"
            clearable
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="公告内容" prop="noticeContent">
          <el-input
            v-model="queryParams.noticeContent"
            placeholder="请输入公告内容"
            clearable
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <div class="notice-list" v-loading="loading">
      
      <el-empty v-if="adviseList.length === 0" description="暂无公告"></el-empty>

      <div v-else class="notice-wrapper" v-for="item in adviseList" :key="item.noticeId">
        <el-card shadow="hover" class="notice-card">
          <div class="card-header">
            <div class="header-left">
              <span class="notice-icon"><i class="el-icon-message-solid"></i></span>
              <span class="notice-title">{{ item.noticeTitle }}</span>
            </div>
            <div class="header-right">
              <el-tag size="mini" type="info" effect="plain" class="meta-tag">
                <i class="el-icon-user"></i> {{ item.createBy || '管理员' }}
              </el-tag>
              <span class="time-text">
                <i class="el-icon-time"></i> {{ transform(item.createTime) }}
              </span>
            </div>
          </div>

          <el-divider></el-divider>

          <div class="card-content">
            {{ item.noticeContent }}
          </div>
          
          <div class="card-footer" v-if="item.remark">
             <span class="remark-text">备注: {{ item.remark }}</span>
          </div>
        </el-card>
      </div>
    </div>
  </div>
</template>

<script>
import { listAdvise } from "@/api/notice/advise";
import { formatDate } from '@/util/date';

export default {
  name: "Advise",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 公告列表数据
      adviseList: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10, // 如果你想一页显示更多，可以把这里改大，比如 20
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
        this.adviseList = response.data.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.queryParams.noticeTitle = null;
      this.queryParams.noticeContent = null;
      this.handleQuery();
    },
    // 时间格式化
    transform(time) {
      if (!time) return '';
      let date = new Date(time);
      return formatDate(date, 'yyyy-MM-dd');
    }
  }
};
</script>

<style scoped lang="less">
.app-container {
  padding: 20px;
  // background-color: #f5f7fa; /* 给整个页面一个浅灰背景，突出白色卡片 */
  min-height: 100vh;
}

.search-card {
  // margin-bottom: 20px;
  border: none; 
  /* 让搜索栏稍微圆润一点 */
  border-radius: 8px; 
}

/* 公告列表容器 */
.notice-list {
  display: flex;
  flex-direction: column;
  gap: 20px; /* 卡片之间的间距 */
}

/* 单个公告卡片样式 */
.notice-card {
  border-radius: 8px;
  border: none;
  transition: all 0.3s ease;
  position: relative;
  
  /* 移除默认边框，使用阴影代替，更现代 */
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);

  &:hover {
    transform: translateY(-2px); /* 鼠标悬浮微微上浮 */
    box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.1);
  }
}

/* 头部布局 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  // padding: 5px 0;

  .header-left {
    display: flex;
    align-items: center;
    
    .notice-icon {
      font-size: 20px;
      color: #1890ff; /* 主题蓝色 */
      margin-right: 10px;
    }

    .notice-title {
      font-size: 18px;
      font-weight: 600;
      color: #303133;
    }
  }

  .header-right {
    display: flex;
    align-items: center;

    .meta-tag {
      margin-right: 15px;
    }

    .time-text {
      font-size: 13px;
      color: #909399;
    }
  }
}

/* 调整 Element UI 自带分割线的间距 */
/deep/ .el-divider--horizontal {
  margin: 15px 0;
}

/* 内容区域 */
.card-content {
  font-size: 15px;
  color: #606266;
  line-height: 1.8; /* 增加行高，阅读更舒适 */
  white-space: pre-wrap; /* 保留文本中的换行和空格 */
  text-align: justify; /* 两端对齐 */
  padding: 0 5px;
  min-height: 60px; /* 最小高度，防止内容太少不好看 */
}

.card-footer {
  margin-top: 15px;
  padding-top: 10px;
  border-top: 1px dashed #ebeef5;
  
  .remark-text {
    font-size: 12px;
    color: #999;
  }
}

/* 移动端适配微调 (如果需要在手机看) */
@media screen and (max-width: 768px) {
  .card-header {
    flex-direction: column;
    align-items: flex-start;
    
    .header-right {
      margin-top: 10px;
      width: 100%;
      justify-content: space-between;
    }
  }
}
</style>