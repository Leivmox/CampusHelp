<template>
  <div class="image-manager">
    <el-card shadow="never" class="stats-card">
      <div slot="header">
        <span>图片统计</span>
      </div>
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="stat-item">
            <div class="stat-value">{{ stats.totalCount }}</div>
            <div class="stat-label">图片总数</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-item used">
            <div class="stat-value">{{ stats.usedCount }}</div>
            <div class="stat-label">使用中</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-item unused">
            <div class="stat-value">{{ stats.unusedCount }}</div>
            <div class="stat-label">未使用</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-item size">
            <div class="stat-value">{{ stats.totalSizeText }}</div>
            <div class="stat-label">占用空间</div>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <el-card shadow="never" class="toolbar-card">
      <el-row :gutter="20" align="middle">
        <el-col :span="8">
          <el-select v-model="filterType" placeholder="按类型筛选" clearable style="width: 100%">
            <el-option label="全部类型" value=""></el-option>
            <el-option label="头像" value="avatar"></el-option>
            <el-option label="帖子" value="post"></el-option>
            <el-option label="聊天" value="chat"></el-option>
            <el-option label="评论" value="comment"></el-option>
            <el-option label="其他" value="common"></el-option>
          </el-select>
        </el-col>
        <el-col :span="8">
          <el-select v-model="filterStatus" placeholder="按状态筛选" clearable style="width: 100%">
            <el-option label="全部状态" value=""></el-option>
            <el-option label="使用中" value="used"></el-option>
            <el-option label="未使用" value="unused"></el-option>
          </el-select>
        </el-col>
        <el-col :span="8" style="text-align: right">
          <el-button type="danger" icon="el-icon-delete" @click="deleteAllUnused" :loading="deleting">
            清理未使用图片 ({{ stats.unusedCount }}张)
          </el-button>
          <el-button icon="el-icon-refresh" @click="loadData">刷新</el-button>
        </el-col>
      </el-row>
    </el-card>

    <el-card shadow="never" class="image-list-card">
      <div slot="header">
        <span>图片列表 ({{ filteredImages.length }}张)</span>
      </div>
      
      <div v-if="loading" class="loading-box">
        <i class="el-icon-loading"></i> 加载中...
      </div>

      <div v-else-if="filteredImages.length === 0" class="empty-box">
        <el-empty description="暂无图片"></el-empty>
      </div>

      <div v-else class="image-grid">
        <div 
          v-for="(img, index) in filteredImages" 
          :key="index" 
          class="image-item"
          :class="{ 'unused': !img.isUsed }"
        >
          <div class="image-preview">
            <el-image 
              :src="baseUrl + img.url" 
              fit="cover"
              :preview-src-list="[baseUrl + img.url]"
              lazy
            >
              <div slot="error" class="image-error">
                <i class="el-icon-picture-outline"></i>
              </div>
            </el-image>
            <div class="status-badge" :class="img.isUsed ? 'used' : 'unused'">
              {{ img.isUsed ? '使用中' : '未使用' }}
            </div>
          </div>
          <div class="image-info">
            <div class="image-name" :title="img.name">{{ img.name }}</div>
            <div class="image-meta">
              <span class="meta-item">{{ img.sizeText }}</span>
              <span class="meta-item">{{ img.type }}</span>
            </div>
            <div class="image-date">{{ img.lastModified }}</div>
          </div>
          <div class="image-actions">
            <el-button 
              v-if="!img.isUsed"
              type="danger" 
              size="mini" 
              icon="el-icon-delete"
              @click="deleteSingle(img)"
            >
              删除
            </el-button>
            <el-tag v-else type="success" size="mini">不可删除</el-tag>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "ImageManager",
  data() {
    return {
      loading: false,
      deleting: false,
      images: [],
      stats: {
        totalCount: 0,
        usedCount: 0,
        unusedCount: 0,
        totalSize: 0,
        totalSizeText: "0 B",
        usedSize: 0,
        usedSizeText: "0 B",
        unusedSize: 0,
        unusedSizeText: "0 B"
      },
      filterType: "",
      filterStatus: "",
      baseUrl: "http://localhost:8080"
    };
  },
  computed: {
    filteredImages() {
      let result = this.images;
      
      if (this.filterType) {
        result = result.filter(img => img.type === this.filterType);
      }
      
      if (this.filterStatus === "used") {
        result = result.filter(img => img.isUsed);
      } else if (this.filterStatus === "unused") {
        result = result.filter(img => !img.isUsed);
      }
      
      return result;
    }
  },
  created() {
    this.loadData();
  },
  methods: {
    loadData() {
      this.loading = true;
      Promise.all([
        this.$get("/image/list"),
        this.$get("/image/stats")
      ]).then(([listRes, statsRes]) => {
        this.loading = false;
        if (listRes.data.status) {
          this.images = listRes.data.images || [];
        }
        if (statsRes.data.status) {
          this.stats = statsRes.data.stats || this.stats;
        }
      }).catch(err => {
        this.loading = false;
        console.error(err);
        this.$msg("加载失败", "error");
      });
    },

    deleteAllUnused() {
      if (this.stats.unusedCount === 0) {
        this.$msg("没有未使用的图片", "info");
        return;
      }

      this.$confirm(
        `确定删除所有未使用的图片吗？共 ${this.stats.unusedCount} 张，将释放 ${this.stats.unusedSizeText} 空间。`,
        "清理确认",
        { type: "warning" }
      ).then(() => {
        this.deleting = true;
        this.$del("/image/unused").then(res => {
          this.deleting = false;
          if (res.data.status) {
            this.$msg(res.data.msg, "success");
            this.loadData();
          } else {
            this.$msg(res.data.msg, "error");
          }
        }).catch(err => {
          this.deleting = false;
          console.error(err);
          this.$msg("删除失败", "error");
        });
      }).catch(() => {});
    },

    deleteSingle(img) {
      this.$confirm(`确定删除图片 "${img.name}" 吗？`, "删除确认", { type: "warning" })
        .then(() => {
          const encodedUrl = encodeURIComponent(img.url);
          this.$del(`/image/${encodedUrl}`).then(res => {
            if (res.data.status) {
              this.$msg("删除成功", "success");
              this.loadData();
            } else {
              this.$msg(res.data.msg, "error");
            }
          }).catch(err => {
            console.error(err);
            this.$msg("删除失败", "error");
          });
        }).catch(() => {});
    }
  }
};
</script>

<style scoped lang="less">
.image-manager {
  padding: 0;
}

.stats-card {
  margin-bottom: 15px;

  .stat-item {
    text-align: center;
    padding: 15px;
    background: #f5f7fa;
    border-radius: 8px;

    .stat-value {
      font-size: 28px;
      font-weight: bold;
      color: #303133;
    }

    .stat-label {
      font-size: 14px;
      color: #909399;
      margin-top: 5px;
    }

    &.used .stat-value {
      color: #67c23a;
    }

    &.unused .stat-value {
      color: #f56c6c;
    }

    &.size .stat-value {
      color: #409eff;
    }
  }
}

.toolbar-card {
  margin-bottom: 15px;
}

.image-list-card {
  .loading-box,
  .empty-box {
    padding: 50px;
    text-align: center;
    color: #909399;
  }

  .image-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 15px;
  }

  .image-item {
    border: 1px solid #ebeef5;
    border-radius: 8px;
    overflow: hidden;
    transition: all 0.3s;

    &:hover {
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
    }

    &.unused {
      border-color: #f56c6c;
      background: #fef0f0;
    }

    .image-preview {
      position: relative;
      height: 150px;
      background: #f5f7fa;

      .el-image {
        width: 100%;
        height: 100%;
      }

      .image-error {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
        color: #c0c4cc;
        font-size: 40px;
      }

      .status-badge {
        position: absolute;
        top: 8px;
        right: 8px;
        padding: 2px 8px;
        border-radius: 4px;
        font-size: 12px;
        color: #fff;

        &.used {
          background: #67c23a;
        }

        &.unused {
          background: #f56c6c;
        }
      }
    }

    .image-info {
      padding: 10px;

      .image-name {
        font-size: 13px;
        color: #303133;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        margin-bottom: 5px;
      }

      .image-meta {
        display: flex;
        gap: 10px;
        margin-bottom: 5px;

        .meta-item {
          font-size: 12px;
          color: #909399;
          background: #f5f7fa;
          padding: 2px 6px;
          border-radius: 4px;
        }
      }

      .image-date {
        font-size: 12px;
        color: #c0c4cc;
      }
    }

    .image-actions {
      padding: 10px;
      text-align: center;
      border-top: 1px solid #ebeef5;
    }
  }
}
</style>
