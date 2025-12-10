<template>
  <div class="content">
    <!-- 全局操作区 -->
    <div class="global-actions">
      <el-button-group class="add-buttons">
        <el-button 
          type="primary" 
          icon="el-icon-plus"
          @click="showAddDialog('school')">
          新增学校
        </el-button>
        <el-button 
          icon="el-icon-plus"
          @click="showAddDialog('dept')">
          新增院系
        </el-button>
        <el-button 
          icon="el-icon-plus"
          @click="showAddDialog('class')">
          新增班级
        </el-button>
      </el-button-group>
    </div>
    
    <!-- 导航栏 -->
    <div class="nav-bar">
      <el-radio-group v-model="currentTab" fill="#409EFF">
        <el-radio-button label="school">
          <i class="el-icon-office-building"></i> 学校管理
        </el-radio-button>
        <el-radio-button label="dept">
          <i class="el-icon-menu"></i> 院系管理
        </el-radio-button>
        <el-radio-button label="class">
          <i class="el-icon-user"></i> 班级管理
        </el-radio-button>
      </el-radio-group>
      
      <!-- 搜索框 -->
      <div class="search-box">
        <el-input
          v-model="searchKeyword"
          placeholder="输入关键词搜索..."
          prefix-icon="el-icon-search"
          clearable
          @input="handleSearch">
        </el-input>
      </div>
    </div>
    
    <!-- 学校列表 -->
    <el-table 
      v-if="currentTab === 'school'"
      :data="filteredSchools" 
      border 
      style="width: 100%">
      <el-table-column label="学校名称">
        <template #default="{ row }">
          <span>{{ row.name }}</span>
        </template>
      </el-table-column>
    </el-table>
    
    <!-- 院系列表 -->
    <el-table 
      v-if="currentTab === 'dept'"
      :data="filteredDepts" 
      border 
      style="width: 100%">
      <el-table-column label="所属院校">
        <template #default="{ row }">
          <span>{{ getSchoolName(row.schoolId) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="院系名称">
        <template #default="{ row }">
          <span>{{ row.name }}</span>
        </template>
      </el-table-column>
    </el-table>
    
    <!-- 班级列表 -->
    <el-table 
      v-if="currentTab === 'class'"
      :data="filteredClasses" 
      border 
      style="width: 100%">
      <el-table-column label="所属院校">
        <template #default="{ row }">
          <span>{{ getSchoolName(row.schoolId) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="院系名称">
        <template #default="{ row }">
          <span>{{ getDeptName(row.deptId) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="班级">
        <template #default="{ row }">
          <span>{{ row.name }}</span>
        </template>
      </el-table-column>
    </el-table>
    <!-- 统一表单对话框 -->
    <el-dialog 
      :title="dialogTitle" 
      :visible.sync="dialogVisible" 
      width="500px"
      :close-on-click-modal="false">
      
      <el-form 
        ref="formRef" 
        :model="formData" 
        :rules="formRules" 
        label-width="100px">
        
        <!-- 学校表单 -->
        <template v-if="currentType === 'school'">
          <el-form-item label="学校名称" prop="name">
            <el-input 
              v-model="formData.name" 
              placeholder="请输入学校名称"
              clearable/>
          </el-form-item>
        </template>
        
        <!-- 院系表单 -->
        <template v-if="currentType === 'dept'">
          <el-form-item label="院系名称" prop="name">
            <el-input 
              v-model="formData.name" 
              placeholder="请输入院系名称"
              clearable/>
          </el-form-item>
          <el-form-item label="所属学校" prop="schoolId">
            <el-select 
              v-model="formData.schoolId" 
              placeholder="请选择学校"
              filterable>
              <el-option 
                v-for="school in schools" 
                :key="school.id"
                :label="school.name"
                :value="school.id"/>
            </el-select>
          </el-form-item>
        </template>
        
        <!-- 班级表单 -->
        <template v-if="currentType === 'class'">
          <el-form-item label="班级名称" prop="name">
            <el-input 
              v-model="formData.name" 
              placeholder="请输入班级名称"
              clearable/>
          </el-form-item>
          
          <!-- 新增学校选择 -->
          <el-form-item label="所属学校" prop="schoolId">
            <el-select 
              v-model="formData.schoolId" 
              placeholder="请选择学校"
              filterable
              @change="handleSchoolChange">
              <el-option 
                v-for="school in schools" 
                :key="school.id"
                :label="school.name"
                :value="school.id"/>
            </el-select>
          </el-form-item>
          
          <!-- 院系选择保持不变，但需要根据学校ID过滤 -->
          <el-form-item label="所属院系" prop="deptId">
            <el-select 
              v-model="formData.deptId" 
              placeholder="请选择院系"
              filterable
              :disabled="!formData.schoolId">
              <el-option 
                v-for="dept in filteredDeptsForClass" 
                :key="dept.id"
                :label="dept.name"
                :value="dept.id"/>
            </el-select>
          </el-form-item>
        </template>
      </el-form>
      
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button 
          type="primary" 
          @click="submitForm"
          :loading="submitLoading">
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>
<script>
export default {
  name: "TabSchoolManagement",
  data() {
    return {
      currentTab: 'school',
      schools: [],
      depts: [],
      classes: [],
      searchKeyword: '',
      dialogVisible: false,
      currentType: '',
      submitLoading: false,
      formData: {
        id: null,
        name: '',
        schoolId: null,
        deptId: null
      }
    };
  },
  computed: {
    dialogTitle() {
      const titles = {
        school: '新增学校',
        dept: '新增院系',
        class: '新增班级'
      };
      return titles[this.currentType] || '新增管理';
    },
    
    formRules() {
      const rules = {
        name: [
          { required: true, message: '名称不能为空', trigger: 'blur' },
          { min: 2, max: 20, message: '长度在2到20个字符', trigger: 'blur' }
        ]
      };
      
      if (this.currentType === 'dept') {
        rules.schoolId = [
          { required: true, message: '请选择所属学校', trigger: 'change' }
        ];
      }
      
      if (this.currentType === 'class') {
        rules.schoolId = [
          { required: true, message: '请选择所属学校', trigger: 'change' }
        ];
        rules.deptId = [
          { required: true, message: '请选择所属院系', trigger: 'change' }
        ];
      }
      
      return rules;
    },
    
    filteredSchools() {
      if (!this.searchKeyword) return this.schools;
      return this.schools.filter(item => 
        item.name.includes(this.searchKeyword)
      );
    },
    
    filteredDepts() {
      if (!this.searchKeyword) return this.depts;
      return this.depts.filter(item => 
        item.name.includes(this.searchKeyword) ||
        this.getSchoolName(item.schoolId).includes(this.searchKeyword)
      );
    },
    
    filteredClasses() {
      if (!this.searchKeyword) return this.classes;
      return this.classes.filter(item => 
        item.name.includes(this.searchKeyword) ||
        this.getDeptName(item.deptId).includes(this.searchKeyword) ||
        this.getSchoolName(item.schoolId).includes(this.searchKeyword)
      );
    },
    
    filteredDeptsForClass() {
      if (!this.formData.schoolId) return [];
      return (this.depts || []).filter(dept => 
        dept.schoolId === this.formData.schoolId
      );
    }
  },
  methods: {
    async loadData() {
      try {
        const [schoolsRes, deptsRes, classesRes] = await Promise.all([
          this.$get('/school'),
          this.$get('/dept'),
          this.$get('/class')
        ]);
        
        this.schools = schoolsRes.data.school || [];
        this.depts = deptsRes.data.dept || [];
        this.classes = classesRes.data.class || [];
        
      } catch (error) {
        this.$message.error(`数据加载失败: ${error.message}`);
      }
    },
    
    getSchoolName(schoolId) {
      const school = (this.schools || []).find(s => s.id === schoolId);
      return school ? school.name : '未知学校';
    },
    
    getDeptName(deptId) {
      const dept = (this.depts || []).find(d => d.id === deptId);
      return dept ? dept.name : '未知院系';
    },
    
    showAddDialog(type) {
      this.currentType = type;
      this.formData = { 
        name: '',
        schoolId: null,
        deptId: null
      };
      
      if (type === 'dept' && this.schools.length > 0) {
        this.formData.schoolId = this.schools[0].id;
      }
      
      this.dialogVisible = true;
    },
    
    handleSearch() {
      // 搜索逻辑已在computed中实现
    },
    
    handleSchoolChange(schoolId) {
      this.formData.deptId = null;
    },
    
    async submitForm() {
      try {
        // 表单验证
        await this.$refs.formRef.validate();
        this.submitLoading = true;
        
        let url, method = 'post';
        const data = { ...this.formData };
        
        switch (this.currentType) {
          case 'school': url = '/school'; break;
          case 'dept': url = '/dept'; break;
          case 'class': 
            url = '/class';
            if (!this.formData.deptId) {
              this.$message.warning('请先选择所属院系');
              this.submitLoading = false;
              return;
            }
            data.schoolId = this.formData.schoolId;
            break;
        }
        
        await this.$request[method](url, data);
        this.$message.success('新增成功');
        this.dialogVisible = false;
        this.loadData();
        
      } catch (error) {
        // 错误处理
        if (error?.response?.data?.message) {
          this.$message.error(error.response.data.message);
        } else if (error.message.includes('院系')) {
          this.$message.warning('请选择院系');
        } else {
          this.$message.error(`操作失败: ${error.message || error}`);
        }
      } finally {
        this.submitLoading = false;
      }
    }
  },
  mounted() {
    this.loadData();
  }
};
</script>
<style scoped>
.content {
  padding: 20px;
}
.global-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.add-buttons {
  margin-left: 0;
}
.nav-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.search-box {
  width: 300px;
}
.info-text {
  color: #999;
  font-size: 12px;
  margin-top: 5px;
}
.el-table__row {
  height: 55px;
}
</style>