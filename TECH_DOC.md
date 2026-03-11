# 校园IT互助系统 - 技术文档

## 一、技术栈

### 1.1 后端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Spring Boot | 2.5.6 | 核心框架 |
| MyBatis-Plus | 3.4.3 | ORM框架，简化MyBatis开发 |
| MySQL | 8.0.18 | 关系型数据库 |
| Druid | 1.2.6 | 数据库连接池 |
| Redis | - | 缓存中间件 |
| JWT (jjwt) | 0.9.1 | Token认证 |
| Hutool | 5.8.16 | Java工具类库 |
| Lombok | - | 简化实体类开发 |
| FastJSON | 1.2.83 | JSON处理 |
| PageHelper | 5.1.10 | 分页插件 |
| Commons-Lang3 | - | 通用工具类 |

### 1.2 前端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue.js | 2.6.11 | 渐进式JavaScript框架 |
| Vue Router | 3.2.0 | 路由管理 |
| Vuex | 3.4.0 | 状态管理 |
| Element UI | 2.15.8 | PC端UI组件库 |
| Vant | 2.12.18 | 移动端UI组件库 |
| Axios | 0.21.1 | HTTP请求库 |
| ECharts | 6.0.0 | 数据可视化图表 |
| Less | 3.0.4 | CSS预处理器 |
| Vue CLI | 4.5.0 | 项目构建工具 |
| js-md5 | 0.7.3 | MD5加密 |
| NProgress | 0.2.0 | 进度条组件 |

---

## 二、核心业务模块

### 2.1 用户模块 (User)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 用户登录 | /user/login | POST | 学号+密码登录，返回JWT Token |
| 用户注册 | /user | POST | 注册新用户，初始100积分 |
| 获取用户信息 | /user/{id} | GET | 获取用户详细信息 |
| 更新用户信息 | /user | PUT | 修改昵称、头像、签名等 |
| 修改密码 | /user/password | PUT | 修改登录密码 |
| 更新头像 | /user/avatar | PUT | 更新用户头像 |

### 2.2 求助模块 (Task)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 获取求助列表 | /task | GET | 获取求助广场列表 |
| 发布求助 | /task | POST | 发布新求助，扣除悬赏积分 |
| 获取求助详情 | /task/{id} | GET | 获取求助详细信息 |
| 更新求助 | /task | PUT | 修改求助内容 |
| 删除求助 | /task/{id} | DELETE | 删除求助，退回积分 |
| 接受求助 | /task/accept/{id} | PUT | 接单帮助他人 |
| 完成求助 | /task/complete/{id} | PUT | 标记求助完成，积分转账 |
| 我发布的求助 | /task/published/{userId} | GET | 获取用户发布的求助 |
| 我接受的求助 | /task/accepted/{userId} | GET | 获取用户接单的求助 |

### 2.3 帖子模块 (Post)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 获取帖子列表 | /post | GET | 获取校园圈子帖子列表 |
| 发布帖子 | /post | POST | 发布新帖子 |
| 获取帖子详情 | /post/{id} | GET | 获取帖子详细内容 |
| 更新帖子 | /post | PUT | 修改帖子内容 |
| 删除帖子 | /post/{id} | DELETE | 删除帖子 |
| 置顶帖子 | /post/top/{id} | PUT | 管理员置顶帖子 |
| 取消置顶 | /post/untop/{id} | PUT | 取消帖子置顶 |
| 获取我的帖子 | /post/my/{userId} | GET | 获取用户自己的帖子 |

### 2.4 评论模块 (Comment)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 发布评论 | /post/comment | POST | 评论帖子 |
| 删除评论 | /comment/{id} | DELETE | 删除评论 |

### 2.5 点赞模块 (UserLike)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 点赞/取消点赞 | /like | PUT | 点赞或取消点赞（帖子/评论） |

### 2.6 消息模块 (Chat)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 发送消息 | /chat/send | POST | 发送私信（支持文字/图片/表情） |
| 获取聊天记录 | /chat/history | GET | 获取与某人的聊天记录 |
| 获取最近联系人 | /chat/recent | GET | 获取最近聊天列表 |
| 标记已读 | /chat/read | PUT | 标记消息为已读 |
| 清空聊天记录 | /chat/clear | DELETE | 清空与某人的聊天 |
| 删除聊天 | /chat/delete | DELETE | 删除聊天并清空记录 |

### 2.7 评价模块 (Remark)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 提交评价 | /remark | POST | 对帮助者进行评价 |
| 我给出的评价 | /remark/my/{userId} | GET | 获取我给别人的评价 |
| 我收到的评价 | /remark/to/{userId} | GET | 获取别人给我的评价 |

### 2.8 公告模块 (Notice)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 获取公告列表 | /notice | GET | 获取系统公告 |
| 发布公告 | /notice | POST | 管理员发布公告 |
| 删除公告 | /notice/{id} | DELETE | 删除公告 |

### 2.9 学校管理模块 (School/Dept/Class)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 获取学校列表 | /school | GET | 获取所有学校 |
| 获取院系列表 | /dept | GET | 获取院系列表 |
| 获取班级列表 | /class | GET | 获取班级列表 |

### 2.10 AI助手模块 (AI)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| AI对话 | /ai/chat | POST | 智能问答（基于DeepSeek-V3） |

### 2.11 文件上传模块 (Common)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 文件上传 | /common/upload | POST | 上传图片/文件 |

### 2.12 图片管理模块 (Image) - 管理端

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 获取图片列表 | /image/list | GET | 获取所有图片，标记使用状态 |
| 获取图片统计 | /image/stats | GET | 获取图片占用空间统计 |
| 删除未使用图片 | /image/unused | DELETE | 批量删除未使用图片 |
| 删除单个图片 | /image/{url} | DELETE | 删除指定图片 |

### 2.13 管理员模块 (Admin)

| 功能 | 接口 | 方法 | 说明 |
|------|------|------|------|
| 管理员登录 | /admin/login | POST | 管理员登录 |
| 获取统计数据 | /admin/stats | GET | 获取系统统计数据 |

---

## 三、项目目录结构

### 3.1 后端目录结构

```
CampusHelpApi/
├── src/
│   ├── main/
│   │   ├── java/com/yqn/
│   │   │   ├── CampusHelpApplication.java    # 启动类
│   │   │   ├── common/                       # 公共模块
│   │   │   │   ├── config/                   # 配置类
│   │   │   │   │   ├── CorsConfig.java       # 跨域配置
│   │   │   │   │   └── ResourcesConfig.java  # 资源配置
│   │   │   │   ├── constant/                 # 常量定义
│   │   │   │   │   ├── Constants.java
│   │   │   │   │   └── HttpStatus.java
│   │   │   │   ├── core/                     # 核心基类
│   │   │   │   │   ├── controller/
│   │   │   │   │   │   └── BaseController.java
│   │   │   │   │   ├── domain/               # 领域对象
│   │   │   │   │   │   ├── AjaxResult.java   # 统一响应
│   │   │   │   │   │   └── BaseEntity.java
│   │   │   │   │   └── page/                 # 分页相关
│   │   │   │   ├── exception/                # 异常定义
│   │   │   │   ├── tools/                    # 工具类
│   │   │   │   │   ├── MessageTools.java     # 响应消息工具
│   │   │   │   │   └── PocketMoney.java
│   │   │   │   └── utils/                    # 通用工具
│   │   │   │       ├── DateUtils.java
│   │   │   │       ├── StringUtils.java
│   │   │   │       └── ServletUtils.java
│   │   │   ├── controller/                   # 控制器层
│   │   │   │   ├── AdminController.java      # 管理员控制器
│   │   │   │   ├── AdminStatsController.java # 统计控制器
│   │   │   │   ├── ChatController.java       # 聊天控制器
│   │   │   │   ├── ClassController.java      # 班级控制器
│   │   │   │   ├── CommentController.java    # 评论控制器
│   │   │   │   ├── CommonController.java     # 公共控制器
│   │   │   │   ├── DeptController.java       # 院系控制器
│   │   │   │   ├── ImageController.java      # 图片管理控制器
│   │   │   │   ├── NoticeController.java     # 公告控制器
│   │   │   │   ├── PostController.java       # 帖子控制器
│   │   │   │   ├── RemarkController.java     # 评价控制器
│   │   │   │   ├── SchoolController.java     # 学校控制器
│   │   │   │   ├── StudentController.java    # 学生控制器
│   │   │   │   ├── TaskController.java       # 求助控制器
│   │   │   │   ├── UserController.java       # 用户控制器
│   │   │   │   └── UserLikeController.java   # 点赞控制器
│   │   │   ├── mapper/                       # 数据访问层
│   │   │   │   ├── AdminMapper.java
│   │   │   │   ├── ChatMessageMapper.java
│   │   │   │   ├── ClassMapper.java
│   │   │   │   ├── CommentMapper.java
│   │   │   │   ├── DeptMapper.java
│   │   │   │   ├── NoticeMapper.java
│   │   │   │   ├── PostMapper.java
│   │   │   │   ├── RemarkMapper.java
│   │   │   │   ├── SchoolMapper.java
│   │   │   │   ├── StudentMapper.java
│   │   │   │   ├── TaskMapper.java
│   │   │   │   ├── UserLikeMapper.java
│   │   │   │   └── UserMapper.java
│   │   │   ├── pojo/                         # 实体类
│   │   │   │   ├── Admin.java                # 管理员实体
│   │   │   │   ├── ChatMessage.java          # 聊天消息实体
│   │   │   │   ├── Class.java                # 班级实体
│   │   │   │   ├── Comment.java              # 评论实体
│   │   │   │   ├── Dept.java                 # 院系实体
│   │   │   │   ├── Notice.java               # 公告实体
│   │   │   │   ├── Post.java                 # 帖子实体
│   │   │   │   ├── Remark.java               # 评价实体
│   │   │   │   ├── School.java               # 学校实体
│   │   │   │   ├── Student.java              # 学生实体
│   │   │   │   ├── Task.java                 # 求助实体
│   │   │   │   ├── User.java                 # 用户实体
│   │   │   │   └── UserLike.java             # 点赞实体
│   │   │   └── service/                      # 服务层
│   │   │       ├── impl/                     # 服务实现
│   │   │       │   ├── AdminServiceImpl.java
│   │   │       │   ├── AiController.java     # AI助手服务
│   │   │       │   ├── ChatMessageServiceImpl.java
│   │   │       │   ├── ClassServiceImpl.java
│   │   │       │   ├── CommentServiceImpl.java
│   │   │       │   ├── DeptServiceImpl.java
│   │   │       │   ├── NoticeServiceImpl.java
│   │   │       │   ├── PostServiceImpl.java
│   │   │       │   ├── RemarkServiceImpl.java
│   │   │       │   ├── SchoolServiceImpl.java
│   │   │       │   ├── StudentServiceImpl.java
│   │   │       │   ├── TaskServiceImpl.java
│   │   │       │   ├── UserLikeServiceImpl.java
│   │   │       │   └── UserServiceImpl.java
│   │   │       ├── AdminService.java
│   │   │       ├── ChatMessageService.java
│   │   │       ├── ClassService.java
│   │   │       ├── CommentService.java
│   │   │       ├── DeptService.java
│   │   │       ├── INoticeService.java
│   │   │       ├── IRemarkService.java
│   │   │       ├── IStudentService.java
│   │   │       ├── PostService.java
│   │   │       ├── SchoolService.java
│   │   │       ├── TaskService.java
│   │   │       ├── UserLikeService.java
│   │   │       └── UserService.java
│   │   └── resources/
│   │       ├── mapper/                       # MyBatis XML映射
│   │       │   ├── ClassMapper.xml
│   │       │   ├── CommentMapper.xml
│   │       │   ├── DeptMapper.xml
│   │       │   ├── NoticeMapper.xml
│   │       │   ├── PostMapper.xml
│   │       │   ├── RemarkMapper.xml
│   │       │   ├── SchoolMapper.xml
│   │       │   ├── StudentMapper.xml
│   │       │   ├── TaskMapper.xml
│   │       │   ├── UserLikeMapper.xml
│   │       │   └── UserMapper.xml
│   │       └── application.yml               # 应用配置
│   └── test/                                 # 测试目录
└── pom.xml                                   # Maven配置
```

### 3.2 前端目录结构

```
CampusHelpaVue/
├── public/
│   ├── favicon.ico                           # 网站图标
│   └── index.html                            # 入口HTML
├── src/
│   ├── api/                                  # API接口定义
│   │   ├── notice/
│   │   │   └── advise.js                     # 公告接口
│   │   ├── remark/
│   │   │   └── remark.js                     # 评价接口
│   │   ├── student/
│   │   │   └── stuage.js                     # 学生接口
│   │   ├── system/
│   │   │   └── user.js                       # 用户接口
│   │   └── task/
│   │       └── task.js                       # 求助接口
│   ├── assets/                               # 静态资源
│   │   ├── emoji/                            # 表情包图片
│   │   ├── images/                           # 图片资源
│   │   ├── img/                              # 其他图片
│   │   ├── icon.png
│   │   └── logo.png
│   ├── plugin/                               # 插件
│   │   ├── index.js
│   │   └── myPlugin.js
│   ├── router/                               # 路由配置
│   │   └── index.js
│   ├── store/                                # Vuex状态管理
│   │   ├── module/
│   │   │   ├── admin.js                      # 管理员状态
│   │   │   ├── theme.js                      # 主题状态
│   │   │   └── user.js                       # 用户状态
│   │   └── index.js
│   ├── util/                                 # 工具函数
│   │   ├── date.js                           # 日期处理
│   │   ├── request.js                        # Axios封装
│   │   └── util.js                           # 通用工具
│   ├── views/                                # 页面组件
│   │   ├── admin/                            # 管理端
│   │   │   ├── children/
│   │   │   │   ├── Image.vue                 # 图片管理
│   │   │   │   ├── Index.vue                 # 首页统计
│   │   │   │   ├── Post.vue                  # 帖子管理
│   │   │   │   ├── School.vue                # 学校管理
│   │   │   │   ├── Student.vue               # 学生管理
│   │   │   │   └── Task.vue                  # 求助管理
│   │   │   ├── Home.vue                      # 管理端主页
│   │   │   └── Login.vue                     # 管理端登录
│   │   ├── notice/                           # 公告
│   │   │   ├── advise.vue
│   │   │   └── adviseuser.vue
│   │   ├── remark/                           # 评价
│   │   │   ├── myremark.vue
│   │   │   ├── remark.vue
│   │   │   └── userremark.vue
│   │   ├── user/                             # 用户端
│   │   │   ├── children/
│   │   │   │   ├── Accept.vue                # 求助广场
│   │   │   │   ├── Accepted.vue              # 我接受的
│   │   │   │   ├── AiHelp.vue                # AI助手
│   │   │   │   ├── ChatDetail.vue            # 聊天详情
│   │   │   │   ├── ChatList.vue              # 消息列表
│   │   │   │   ├── Forum.vue                 # 校园圈子
│   │   │   │   ├── ForumCenter.vue           # 圈子中心
│   │   │   │   ├── HelpCenter.vue            # 求助中心
│   │   │   │   ├── Index.vue                 # 用户首页
│   │   │   │   ├── MyComment.vue             # 我的评论
│   │   │   │   ├── MyProfile.vue             # 个人信息
│   │   │   │   ├── PostDetail.vue            # 帖子详情
│   │   │   │   ├── Published.vue             # 我发布的
│   │   │   │   ├── RemarkCenter.vue          # 评价中心
│   │   │   │   ├── Task.vue                  # 发布/编辑求助
│   │   │   │   └── TaskDetail.vue            # 求助详情
│   │   │   ├── Home.vue                      # 用户端主页
│   │   │   └── Login.vue                     # 用户端登录
│   │   └── Error.vue                         # 错误页面
│   ├── App.vue                               # 根组件
│   └── main.js                               # 入口文件
├── babel.config.js                           # Babel配置
├── package.json                              # 项目依赖
└── vue.config.js                             # Vue CLI配置
```

---

## 四、数据库设计

### 4.1 核心数据表

| 表名 | 说明 |
|------|------|
| user | 用户表 |
| admin | 管理员表 |
| school | 学校表 |
| dept | 院系表 |
| class | 班级表 |
| task | 求助表 |
| post | 帖子表 |
| comment | 评论表 |
| user_like | 点赞记录表 |
| chat_message | 聊天消息表 |
| remark | 评价表 |
| notice | 公告表 |

---

## 五、项目配置

### 5.1 后端配置 (application.yml)

```yaml
server:
  port: 8080

spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/campus_help
    username: root
    password: your_password
  redis:
    host: localhost
    port: 6379

mybatis-plus:
  mapper-locations: classpath:mapper/*.xml

project:
  profile: ./uploadPath/    # 文件上传路径
```

### 5.2 前端配置 (vue.config.js)

```javascript
module.exports = {
  devServer: {
    port: 8848,
    proxy: {
      '/': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
}
```

---

## 六、运行环境要求

| 环境 | 版本要求 |
|------|----------|
| JDK | 1.8+ |
| Node.js | 14+ |
| MySQL | 5.7+ / 8.0+ |
| Redis | 6.0+ |
| Maven | 3.6+ |
