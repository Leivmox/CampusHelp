# 校园IT互助系统

一个面向高校学生的IT互助平台，帮助学生解决电脑故障、软件安装、系统配置等IT问题，通过积分悬赏机制促进校园互助。

## 项目简介

校园IT互助系统是一个基于 Spring Boot + Vue.js 的前后端分离项目，旨在为高校学生提供一个便捷的IT问题求助与互助平台。学生可以发布IT相关求助并设置悬赏积分，其他学生可以接单帮助解决问题，完成后获得悬赏积分。

## 功能特性

### 用户端功能

- **用户认证**：注册、登录、个人信息管理、头像上传
- **求助中心**
  - 求助广场：浏览所有待解决的求助，支持按时间/积分排序
  - 发布求助：发布IT问题求助，设置悬赏积分（10/15/20/25/30）
  - 我发布的：管理自己发布的求助，可修改或取消
  - 我接受的：查看已接单的求助任务
- **校园圈子**
  - 帖子发布与浏览：分享技术经验、校园生活
  - 点赞与评论：互动交流
  - 排序功能：按时间/点赞/评论排序
- **消息中心**
  - 私信聊天：实时消息通知
  - 图片发送：支持发送图片
  - 表情包：内置表情包快速回复
- **评价系统**：求助完成后可对帮助者进行星级评价
- **积分系统**：新用户100初始积分，发布求助扣除悬赏，完成互助获得积分
- **智能助手**：AI智能问答，解答平台使用问题和IT技术问题

### 管理端功能

- **用户管理**：查看、编辑、禁用用户，修改用户头像和积分
- **帖子管理**：查看、置顶、删除帖子，管理评论
- **求助管理**：查看所有求助记录
- **学校管理**：管理学校、院系、班级信息
- **公告管理**：发布系统公告
- **图片管理**：查看所有上传图片，清理未使用图片
- **数据统计**：用户统计、帖子统计、求助统计

## 技术栈

### 前端

- **框架**：Vue 2.6 + Vue Router + Vuex
- **UI组件库**：Element UI 2.15 + Vant 2.12
- **HTTP请求**：Axios
- **图表**：ECharts 6.0
- **构建工具**：Vue CLI 4.5
- **CSS预处理**：Less

### 后端

- **框架**：Spring Boot 2.5.6
- **ORM**：MyBatis-Plus 3.4.3
- **数据库**：MySQL 8.0
- **连接池**：Druid 1.2.6
- **缓存**：Redis
- **工具库**：Hutool 5.8.16、Lombok
- **认证**：JWT (jjwt 0.9.1)

## 项目结构

```
CampusHelp/
├── CampusHelpApi/                 # 后端项目
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/yqn/
│   │   │   │   ├── controller/    # 控制器层
│   │   │   │   ├── service/       # 服务层
│   │   │   │   ├── mapper/        # 数据访问层
│   │   │   │   ├── pojo/          # 实体类
│   │   │   │   └── common/        # 公共模块
│   │   │   └── resources/
│   │   │       ├── mapper/        # MyBatis XML映射文件
│   │   │       └── application.yml
│   │   └── test/
│   └── pom.xml
├── CampusHelpaVue/                # 前端项目
│   ├── public/
│   ├── src/
│   │   ├── api/                   # API接口
│   │   ├── assets/                # 静态资源
│   │   ├── components/            # 公共组件
│   │   ├── router/                # 路由配置
│   │   ├── store/                 # Vuex状态管理
│   │   ├── util/                  # 工具函数
│   │   └── views/                 # 页面组件
│   │       ├── admin/             # 管理端页面
│   │       └── user/              # 用户端页面
│   └── package.json
└── SQL/                           # 数据库脚本
    └── mysql5.7/
        └── campus_help.sql
```

## 快速开始

### 环境要求

- JDK 1.8+
- Node.js 14+
- MySQL 5.7+
- Redis 6.0+
- Maven 3.6+

### 后端启动

1. 导入数据库
```bash
mysql -u root -p < SQL/mysql5.7/campus_help.sql
```

2. 修改配置文件 `CampusHelpApi/src/main/resources/application.yml`
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/campus_help?useSSL=false&serverTimezone=UTC
    username: root
    password: your_password
  redis:
    host: localhost
    port: 6379
```

3. 启动后端
```bash
cd CampusHelpApi
mvn spring-boot:run
```

后端默认运行在 `http://localhost:8080`

### 前端启动

1. 安装依赖
```bash
cd CampusHelpaVue
npm install
```

2. 启动开发服务器
```bash
npm run serve
```

前端默认运行在 `http://localhost:8848`

### 生产构建

```bash
npm run build
```

## 默认账号

### 管理员账号
- 用户名：`admin`
- 密码：`123456`

### 测试用户
- 注册新用户即可使用

## 主要接口

| 模块 | 接口 | 说明 |
|------|------|------|
| 用户 | POST /user/login | 用户登录 |
| 用户 | POST /user | 用户注册 |
| 求助 | GET /task | 获取求助列表 |
| 求助 | POST /task | 发布求助 |
| 求助 | PUT /task/accept/{id} | 接受求助 |
| 帖子 | GET /post | 获取帖子列表 |
| 帖子 | POST /post | 发布帖子 |
| 消息 | GET /chat/history | 获取聊天记录 |
| 消息 | POST /chat/send | 发送消息 |
| AI | POST /ai/chat | AI智能问答 |

## 配置说明

### AI助手配置

在 `CampusHelpApi/src/main/resources/secret.properties` 中配置：
```properties
ai.api-key=your_api_key
ai.api-url=https://api.siliconflow.cn/v1/chat/completions
ai.model-id=deepseek-ai/DeepSeek-V3
```

### 文件上传配置

在 `application.yml` 中配置上传路径：
```yaml
project:
  profile: /path/to/upload/
```

## 项目截图

### 用户端
- 首页：数据概览、置顶帖子、个人信息
- 求助广场：浏览求助、接单帮助
- 校园圈子：发帖分享、点赞评论
- 消息中心：私信聊天、表情包

### 管理端
- 数据统计：用户统计、帖子统计
- 用户管理：用户列表、编辑禁用
- 帖子管理：帖子列表、置顶删除
- 图片管理：图片列表、清理未使用

## 开发者

- 作者：Leivmox

## 许可证

本项目采用 [MIT License](LICENSE) 开源协议。
