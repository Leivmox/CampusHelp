/*
 Navicat Premium Data Transfer

 Source Server         : 127
 Source Server Type    : MySQL
 Source Server Version : 50724 (5.7.24)
 Source Host           : localhost:3306
 Source Schema         : campus_help

 Target Server Type    : MySQL
 Target Server Version : 50724 (5.7.24)
 File Encoding         : 65001

 Date: 30/01/2026 02:33:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
  `account` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '账号',
  `password` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `username` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `state` int(11) NOT NULL DEFAULT 0 COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, '666666', '123456', '管理员', '2025-10-17 09:16:25', 0);

-- ----------------------------
-- Table structure for chat_message
-- ----------------------------
DROP TABLE IF EXISTS `chat_message`;
CREATE TABLE `chat_message`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender_id` bigint(20) NOT NULL,
  `receiver_id` bigint(20) NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `type` tinyint(2) NULL DEFAULT 0 COMMENT '0:文本, 1:图片',
  `is_read` int(11) NOT NULL DEFAULT 0 COMMENT '是否已读：0未读 1已读',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sender_receiver`(`sender_id`, `receiver_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_message
-- ----------------------------
INSERT INTO `chat_message` VALUES (1, 2, 10, '1', '2026-01-30 01:06:39', 0, 1);
INSERT INTO `chat_message` VALUES (2, 10, 2, '111', '2026-01-30 01:08:13', 0, 1);
INSERT INTO `chat_message` VALUES (3, 10, 2, '111', '2026-01-30 01:13:40', 0, 1);
INSERT INTO `chat_message` VALUES (4, 10, 2, '1', '2026-01-30 01:16:19', 0, 1);
INSERT INTO `chat_message` VALUES (5, 10, 2, '1', '2026-01-30 01:16:21', 0, 1);
INSERT INTO `chat_message` VALUES (6, 10, 2, '1', '2026-01-30 01:16:21', 0, 1);
INSERT INTO `chat_message` VALUES (7, 10, 2, '1', '2026-01-30 01:16:21', 0, 1);
INSERT INTO `chat_message` VALUES (8, 10, 2, '1', '2026-01-30 01:16:22', 0, 1);
INSERT INTO `chat_message` VALUES (9, 10, 2, '1', '2026-01-30 01:16:22', 0, 1);
INSERT INTO `chat_message` VALUES (10, 10, 2, '1', '2026-01-30 01:16:22', 0, 1);
INSERT INTO `chat_message` VALUES (11, 10, 2, '1', '2026-01-30 01:16:23', 0, 1);
INSERT INTO `chat_message` VALUES (12, 2, 10, '1', '2026-01-30 01:19:31', 0, 1);
INSERT INTO `chat_message` VALUES (13, 2, 10, '巴巴博一巴巴博一', '2026-01-30 01:19:36', 0, 1);

-- ----------------------------
-- Table structure for class
-- ----------------------------
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '班级id',
  `name` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '班级名',
  `school_id` int(11) NOT NULL COMMENT '学校id',
  `dept_id` int(11) NOT NULL COMMENT '系别id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_CLASS_SCHOOL`(`school_id`) USING BTREE,
  INDEX `FK_CLASS_DEPT`(`dept_id`) USING BTREE,
  INDEX `name`(`name`) USING BTREE,
  CONSTRAINT `FK_CLASS_DEPT` FOREIGN KEY (`dept_id`) REFERENCES `dept` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_CLASS_SCHOOL` FOREIGN KEY (`school_id`) REFERENCES `school` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of class
-- ----------------------------
INSERT INTO `class` VALUES (1, '计科一班', 1, 1);
INSERT INTO `class` VALUES (2, '软工一班', 1, 2);
INSERT INTO `class` VALUES (3, '计科二班', 1, 1);
INSERT INTO `class` VALUES (4, '计科三班', 1, 1);

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL COMMENT '关联的帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '评论人ID',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '评论内容',
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 76 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 2, 6, '诱导更新，然后自动重新安装智能看图。 伪装成win11默认的照片UI。没想到这个时代了还有这么赤裸裸流氓软件，对各种小白来说，这个吃相也太难看了', '2025-12-15 18:37:32');
INSERT INTO `comment` VALUES (4, 2, 2, '看看这个:https://xzonn.top/posts/Remove-Intelligent-Image-Viewer.html', '2025-12-15 18:39:16');
INSERT INTO `comment` VALUES (5, 2, 5, '巴巴博一', '2025-12-15 18:39:38');
INSERT INTO `comment` VALUES (6, 3, 4, '顶', '2025-12-15 18:41:34');
INSERT INTO `comment` VALUES (7, 3, 10, '1', '2025-12-20 03:49:09');
INSERT INTO `comment` VALUES (14, 3, 2, '感谢楼主', '2025-12-22 04:21:04');
INSERT INTO `comment` VALUES (15, 9, 4, '测试', '2025-12-22 08:33:30');
INSERT INTO `comment` VALUES (16, 11, 2, '123', '2026-01-01 02:03:10');
INSERT INTO `comment` VALUES (17, 11, 17, '建议用Spring Boot，生态更完善', '2025-12-22 10:15:00');
INSERT INTO `comment` VALUES (18, 11, 18, 'Vue比React上手快，推荐Vue3', '2025-12-22 11:30:00');
INSERT INTO `comment` VALUES (19, 12, 3, '我也在图书馆，几点？', '2026-01-15 11:00:00');
INSERT INTO `comment` VALUES (20, 12, 19, '高数太难了，求带', '2026-01-15 14:20:00');
INSERT INTO `comment` VALUES (21, 13, 1, '黄焖鸡确实不错，下次试试', '2026-01-18 13:00:00');
INSERT INTO `comment` VALUES (22, 14, 4, '试试长按电源键10秒强制重启', '2026-01-20 09:30:00');
INSERT INTO `comment` VALUES (23, 14, 17, '可能是电池问题，插上电源试试', '2026-01-20 10:00:00');
INSERT INTO `comment` VALUES (24, 15, 2, '坚持就是胜利！', '2026-01-22 08:00:00');
INSERT INTO `comment` VALUES (25, 15, 20, '想加入，怎么联系', '2026-01-22 09:15:00');
INSERT INTO `comment` VALUES (26, 18, 19, '报错信息发出来看看', '2026-01-25 15:00:00');
INSERT INTO `comment` VALUES (27, 18, 11, '检查一下maven依赖有没有下完', '2026-01-25 16:30:00');
INSERT INTO `comment` VALUES (28, 22, 18, '一饭的拉面也很好吃', '2026-01-20 13:00:00');
INSERT INTO `comment` VALUES (29, 22, 21, '三饭奶茶yyds', '2026-01-20 14:30:00');
INSERT INTO `comment` VALUES (30, 23, 17, '私信了，求分享', '2026-01-22 16:00:00');
INSERT INTO `comment` VALUES (31, 23, 22, '好人一生平安', '2026-01-22 17:20:00');
INSERT INTO `comment` VALUES (32, 26, 1, '同感，建议穿长袖去', '2026-01-24 15:00:00');
INSERT INTO `comment` VALUES (33, 30, 19, '太美了！', '2026-01-29 18:00:00');
INSERT INTO `comment` VALUES (34, 30, 12, '求拍摄地点', '2026-01-29 18:30:00');
INSERT INTO `comment` VALUES (35, 28, 21, '菜鸟驿站确实慢', '2026-01-26 17:00:00');
INSERT INTO `comment` VALUES (36, 2, 17, '我也中招了，太恶心了', '2025-12-15 19:00:00');
INSERT INTO `comment` VALUES (37, 3, 18, '收藏了，感谢分享', '2025-12-15 20:30:00');
INSERT INTO `comment` VALUES (38, 8, 1, '图片挺清晰的', '2025-12-22 06:00:00');
INSERT INTO `comment` VALUES (39, 20, 18, '在哪个位置？求具体地址', '2026-01-27 12:00:00');
INSERT INTO `comment` VALUES (40, 20, 22, '去过，确实不错', '2026-01-27 13:30:00');
INSERT INTO `comment` VALUES (41, 24, 4, '多少钱一天', '2026-01-21 10:00:00');
INSERT INTO `comment` VALUES (42, 24, 11, '私信你了', '2026-01-21 11:30:00');
INSERT INTO `comment` VALUES (43, 25, 3, '什么时候截止报名', '2026-01-23 11:00:00');
INSERT INTO `comment` VALUES (44, 25, 17, '支持！期待精彩表演', '2026-01-23 12:30:00');
INSERT INTO `comment` VALUES (45, 29, 1, '茶百道确实好喝', '2026-01-27 12:00:00');
INSERT INTO `comment` VALUES (46, 29, 4, '烤奶也不错推荐', '2026-01-27 13:00:00');
INSERT INTO `comment` VALUES (47, 13, 19, '辣度怎么样', '2026-01-18 14:00:00');
INSERT INTO `comment` VALUES (48, 13, 21, '微辣还是中辣好吃', '2026-01-18 15:30:00');
INSERT INTO `comment` VALUES (49, 26, 17, '冬天去简直受罪', '2026-01-24 16:00:00');
INSERT INTO `comment` VALUES (50, 26, 18, '自习室比图书馆暖和', '2026-01-24 17:30:00');
INSERT INTO `comment` VALUES (51, 28, 2, '建议早点去，人少', '2026-01-26 18:00:00');
INSERT INTO `comment` VALUES (52, 28, 19, '中午去没人排队', '2026-01-26 19:00:00');
INSERT INTO `comment` VALUES (53, 27, 20, '周末可以吗', '2026-01-25 20:00:00');
INSERT INTO `comment` VALUES (54, 27, 11, '技术怎么样，菜鸟能来吗', '2026-01-25 21:00:00');
INSERT INTO `comment` VALUES (55, 23, 4, '学霸带带我', '2026-01-22 18:00:00');
INSERT INTO `comment` VALUES (56, 31, 2, '太全了，收藏了！', '2026-01-14 10:00:00');
INSERT INTO `comment` VALUES (57, 31, 17, 'LTSC版本推荐，纯净无广告', '2026-01-14 11:30:00');
INSERT INTO `comment` VALUES (58, 31, 3, '迅雷下载速度很快，感谢分享', '2026-01-14 14:00:00');
INSERT INTO `comment` VALUES (59, 31, 19, '请问Office有永久激活的方法吗', '2026-01-14 16:20:00');
INSERT INTO `comment` VALUES (60, 32, 1, '终于找到关闭Defender的方法了', '2025-12-10 10:00:00');
INSERT INTO `comment` VALUES (61, 32, 18, '我的硬盘占用100%就是这玩意搞的', '2025-12-10 12:30:00');
INSERT INTO `comment` VALUES (62, 32, 4, '关了之后电脑流畅多了', '2025-12-10 15:00:00');
INSERT INTO `comment` VALUES (63, 32, 21, '图文教程很详细，小白也能看懂', '2025-12-11 09:00:00');
INSERT INTO `comment` VALUES (64, 33, 11, '原来M.2和PCI-E是这种关系', '2025-12-10 14:00:00');
INSERT INTO `comment` VALUES (65, 33, 20, '怪不得我的固态跑分不高，主板不支持', '2025-12-10 16:30:00');
INSERT INTO `comment` VALUES (66, 33, 5, '买固态前一定要看主板支持什么接口', '2025-12-11 10:00:00');
INSERT INTO `comment` VALUES (67, 34, 6, '系统安装教程合集，太实用了', '2026-01-05 16:00:00');
INSERT INTO `comment` VALUES (68, 34, 17, '新手装系统必看', '2026-01-05 18:30:00');
INSERT INTO `comment` VALUES (69, 34, 22, '封装教程能出个详细版吗', '2026-01-06 09:00:00');
INSERT INTO `comment` VALUES (70, 34, 10, '按教程操作，成功装好了双系统', '2026-01-06 14:00:00');
INSERT INTO `comment` VALUES (71, 35, 3, '半个月有点夸张了吧', '2025-12-11 12:00:00');
INSERT INTO `comment` VALUES (72, 35, 12, '学习路径很清晰，照着练', '2025-12-11 14:30:00');
INSERT INTO `comment` VALUES (73, 35, 18, '第一阶段我已经达到了哈哈', '2025-12-11 16:00:00');
INSERT INTO `comment` VALUES (74, 35, 19, '大神之路从装系统开始', '2025-12-12 10:00:00');
INSERT INTO `comment` VALUES (75, 35, 4, '感觉自己在第二阶段徘徊', '2025-12-12 15:30:00');

-- ----------------------------
-- Table structure for dept
-- ----------------------------
DROP TABLE IF EXISTS `dept`;
CREATE TABLE `dept`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '系别id',
  `name` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '系别名称',
  `school_id` int(11) NOT NULL COMMENT '学校id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_DEPT_SCHOOL`(`school_id`) USING BTREE,
  INDEX `name`(`name`) USING BTREE,
  CONSTRAINT `FK_DEPT_SCHOOL` FOREIGN KEY (`school_id`) REFERENCES `school` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dept
-- ----------------------------
INSERT INTO `dept` VALUES (1, '计算机科学与技术', 1);
INSERT INTO `dept` VALUES (2, '软件工程', 1);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `notice_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告标题',
  `notice_content` longblob NULL COMMENT '公告内容',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '测试公告', 0xE7B3BBE7BB9FE6B58BE8AF95E68890E58A9FEFBC8CE6ADA3E5BC8FE4B88AE7BABFEFBC8CE6ACA2E8BF8EE4BDBFE794A8EFBC81, '管理员', '2025-10-18 17:31:50', '无');
INSERT INTO `notice` VALUES (2, '123123123', 0x313233313233313233, '111', '2025-12-15 19:35:11', '111');

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '发布人ID',
  `school_id` int(11) NOT NULL COMMENT '所属学校ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '内容',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `create_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `img_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post
-- ----------------------------
INSERT INTO `post` VALUES (2, 3, 1, '怎么卸载智能看图啊', '今日某度盘软件更新了之后附带了一个流氓软件-“智能看图”，会把默认的看图软件覆盖掉，由于其风格模仿了Windows自带的看图软件，让我一度以为是Windows自带看图软件...', 3, '2025-12-15 18:33:21', NULL);
INSERT INTO `post` VALUES (3, 1, 1, '分享一个好用的翻译工具', '英文音效看不懂、不会搜？别再一个个猜单词了！用出片音效素材批量翻译工具，简单好用！', 5, '2025-12-15 18:41:05', NULL);
INSERT INTO `post` VALUES (8, 2, 1, '测试111', '测试1111', 1, '2025-12-22 05:04:00', '/profile/post/202512/24acb8f7-e0c6-4635-96c0-a5002fe195c5.jpg,/profile/post/202512/697cf8cd-89fe-4b01-82bd-aa9b1cc97b76.jpg');
INSERT INTO `post` VALUES (9, 2, 1, '测试字数123', '达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊', 18, '2025-12-22 05:35:50', '/profile/post/202512/362e95ef-aa92-44b2-8314-dc3e9d405ffe.jpg,/profile/post/202512/564e4209-46f2-4d75-a1a8-522e42d441d4.jpg');
INSERT INTO `post` VALUES (11, 4, 1, '想用Django+React做个技术交流平台', '我是计算机学院大二的学生，最近想搭建一个校园内部的IT技术交流论坛，主要面向我们学校的同学交流编程、项目经验、技术分享等。目前有一些想法，但技术栈选择上有点迷茫，想请教一下有经验的同学。\n我的需求：\n\n用户系统：学号/邮箱注册登录，个人资料修改\n帖子功能：发布、分类、评论、点赞\n资源分享：上传学习资料、项目代码\n私信系统：用户间私信交流\n\n    通知中心：评论、点赞等消息提醒\n\n技术选型考虑：\n\n后端：Django（Python）或 Spring Boot（Java）\n前端：React 或 Vue.js\n数据库：MySQL 或 PostgreSQL\n\n    部署：学校服务器或云服务（阿里云学生机）\n\n遇到的问题：\n\nDjango REST Framework 和 Spring Boot 哪个更适合校园项目？\n前端用 React 还是 Vue 更容易上手？\n用户认证系统怎么设计比较安全？\n如何实现文件上传和存储？\n\n    有没有现成的开源项目可以参考？\n\n我的背景：\n\n学过 Python 基础，Django 刚入门\n了解一些前端三件套（HTML/CSS/JS）\n\n    数据库学过 MySQL 基础\n\n求助方向：\n\n有没有做过类似项目的学长学姐可以分享经验？\n推荐一些适合的学习资料或教程？\n学校有没有相关的技术支持或服务器资源？\n\n    如果有同学感兴趣，也可以一起组队开发！\n\n联系方式：可以私信我或回复帖子，我们可以约个时间详细聊。\n感谢各位！期待大家的建议和指导！', 23, '2025-12-22 08:35:29', '/profile/post/202512/a1e747e2-fe28-4ba9-930e-0df6fe1e535b.jpg');
INSERT INTO `post` VALUES (12, 1, 1, '期末复习求组队', '有没有一起复习高数的同学？图书馆三楼老位置，带上你的笔记本！', 12, '2026-01-15 10:30:00', NULL);
INSERT INTO `post` VALUES (13, 2, 1, '食堂新菜品测评', '今天试了西区食堂的新出的黄焖鸡，味道还不错，推荐大家去尝尝！', 28, '2026-01-18 12:15:00', NULL);
INSERT INTO `post` VALUES (14, 3, 1, '求助！笔记本电脑开不了机', '今天早上电脑突然黑屏，按电源键没反应，有懂的大佬吗？', 5, '2026-01-20 09:00:00', NULL);
INSERT INTO `post` VALUES (15, 4, 1, '校园跑步打卡Day30', '坚持一个月了！每天绕操场5圈，感觉身体状态好多了', 45, '2026-01-22 07:30:00', NULL);
INSERT INTO `post` VALUES (16, 5, 2, '北大图书馆占座指南', '分享一下我的占座经验：早上7点去东门排队，亲测有效', 67, '2026-01-19 08:00:00', NULL);
INSERT INTO `post` VALUES (17, 6, 2, '今日份的落日', '傍晚在未名湖边拍的，太美了！分享给大家', 89, '2026-01-21 17:45:00', NULL);
INSERT INTO `post` VALUES (18, 3, 1, 'Java期末项目求助', '有没有大佬带带我，SpringBoot项目跑不起来', 8, '2026-01-25 14:20:00', NULL);
INSERT INTO `post` VALUES (19, 8, 2, '失物招领：蓝色保温杯', '在理教302捡到一个蓝色保温杯，失主请联系我', 3, '2026-01-26 16:00:00', NULL);
INSERT INTO `post` VALUES (20, 3, 1, '推荐一个宝藏自习室', '学校东边创业园区三楼有个共享自习室，人少安静', 34, '2026-01-27 11:00:00', NULL);
INSERT INTO `post` VALUES (21, 5, 2, '考研还是就业？', '大三了开始焦虑了，有经验的学长学姐能分享一下吗', 56, '2026-01-28 20:30:00', NULL);
INSERT INTO `post` VALUES (22, 17, 1, '广理食堂哪家强', '个人觉得二饭的麻辣香锅最好吃，三饭的奶茶也不错', 23, '2026-01-20 12:00:00', NULL);
INSERT INTO `post` VALUES (23, 19, 1, '计算机网络期末重点', '整理了一份计网重点，需要的同学私信我', 56, '2026-01-22 15:00:00', NULL);
INSERT INTO `post` VALUES (24, 18, 1, '求租电动车', '有没有人闲置的小电驴出租，代步用，价格好商量', 8, '2026-01-21 09:30:00', NULL);
INSERT INTO `post` VALUES (25, 20, 1, '校园歌手大赛报名啦', '一年一度的校园歌手大赛开始报名了，有才艺的快来', 34, '2026-01-23 10:00:00', NULL);
INSERT INTO `post` VALUES (26, 21, 1, '图书馆空调太冷了', '每次去图书馆都要带件外套，冻死了，有同感的吗', 42, '2026-01-24 14:20:00', NULL);
INSERT INTO `post` VALUES (27, 22, 1, '寻找羽毛球搭子', '每周三晚上体育馆约球，目前三缺一，速来', 15, '2026-01-25 18:00:00', NULL);
INSERT INTO `post` VALUES (28, 17, 1, '快递站排队太久了', '双十一的快递到现在还没取完，排队排了半小时', 67, '2026-01-26 16:30:00', NULL);
INSERT INTO `post` VALUES (29, 18, 1, '推荐校门口奶茶店', '新开了家茶百道，杨枝甘露超好喝', 29, '2026-01-27 11:00:00', NULL);
INSERT INTO `post` VALUES (30, 20, 1, '晚霞好美', '今天傍晚的天空太好看了，随手一拍都是壁纸', 88, '2026-01-29 17:45:00', NULL);
INSERT INTO `post` VALUES (31, 4, 1, '最全的微软msdn原版Windows系统镜像和Office Visio Project下载地址集锦', '随着windows的发展，越来越多的人都热衷于微软的原版系统下载了，相比之前的版本比如winxp版本，windows vista/win7/win8/win8.1/win10/win11后来的版本在安装方面也比较简单了，所以ghost系统正在渐渐的消失市场，即便如此，很多同学还是找不到微软原版的系统和office下载，所以亦是美网络特意归结了一下微软msdn原版系统和原版office各个版本的下载，希望对正在苦苦找寻原版系统的同学有所帮助。\r\n\r\n说在前面的话：\r\n\r\n1、本文提供的镜像包括：Windows、Server、Office、Visio、Project等\r\n\r\n2、选装Windows系统或Office、Visio、Project版本，一般来说专业版较适合我们！\r\n\r\n3、Windows / Server、Office / Visio / Project激活请：点击此处\r\n\r\n4、以下地址建议使用迅雷下载工具进行下载\r\n\r\n5、如需帮助，请不吝发件至邮箱：yishimeicn@qq.com\r\n\r\n推荐相关阅读：\r\n\r\n专业U盘格式化与系统安装启动盘制作工具 - rufus 4.11中文版 说明介绍\r\n\r\n关于Windows服务器版本（Server2003/2008/2012/2016/2019/2022/2025）的下载、安装与激活说明\r\n\r\nwindows 11 家庭版/家庭单语言版/教育版/专业版/专业教育版/专业工作站版 简体中文\r\n\r\nmagnet:?xt=urn:btih:808632e57ba30de8f564ec8e62ffdbe495c7bcae&dn=zh-cn_windows_11_consumer_editions_version_25h2_updated_dec_2025_x64_dvd_115b2867.iso&xl=8330770432\r\n\r\nwindows 11 教育版/专业版/专业教育版/企业版/专业工作站版 简体中文\r\n\r\nmagnet:?xt=urn:btih:c46a16eb293e3386d1e4b717624c83086aae7e02&dn=zh-cn_windows_11_business_editions_version_25h2_updated_dec_2025_x64_dvd_5aa0bca1.iso&xl=8245350400\r\n\r\nwindows 11 Enterprise LTSC 2024 简体中文：\r\n\r\nmagnet:?xt=urn:btih:b84e74c1dbcc88a02c5b24a6f84383f353a2e1dd&dn=zh-cn_windows_11_enterprise_ltsc_2024_x64_dvd_cff9cd2d.iso&xl=5287520256\r\n\r\nWindows 11 Pro China Only 专业中文版\r\n\r\ned2k://|file|Win11_24H2_Pro_Chinese_Simplified_x64.iso|5606453248|1B20C6FADEF04DE45934A339AD6A6596|/\r\n\r\nwindows 11 Home China 家庭中文版\r\n\r\n随着windows的发展，越来越多的人都热衷于微软的原版系统下载了，相比之前的版本比如winxp版本，windows vista/win7/win8/win8.1/win10/win11后来的版本在安装方面也比较简单了，所以ghost系统正在渐渐的消失市场，即便如此，很多同学还是找不到微软原版的系统和office下载，所以亦是美网络特意归结了一下微软msdn原版系统和原版office各个版本的下载，希望对正在苦苦找寻原版系统的同学有所帮助。', 182, '2026-01-14 01:58:33', NULL);
INSERT INTO `post` VALUES (32, 4, 1, '图文详解彻底关闭win10、win11系统自带的windows defender杀毒功能', 'Windows Defender，简称WD，是win8、win10、win11系统自带的集成的杀毒软件，既然是杀毒软件，我们就要讨论它的查杀能力，据广大小伙伴反映，WD查杀能力太强大了，不管三七二十一，眉毛胡子一把抓，管你是正常软件还是不正常软件，只要它认定是不正常的，才不管你同意不同意，更不会询问你，统统杀掉，让你猝不及防，乱杀软件也就算了，在系统后台，WD也没有闲着，动不动就给你来个系统扫描，它不会管你是否在玩游戏，硬盘是否能承受得住，它先扫描爽了再说，于是乎，很多小伙伴的电脑硬盘经常出现占用100%的情况，然后系统直接卡顿...那就将它关闭了吧？想要关闭？难！是可忍，孰不可忍，是时候彻底关闭嚣张的WD了！\r\n\r\n首先我们右键win10、win11系统的开始菜单，选择“设置”，或者直接按下Win+i组合键，打开系统“设置”，\r\n\r\n点击“更新和安全”，\r\n\r\n点击左侧的“Windows安全中心”，\r\n\r\n点击“病毒和威胁防护”，\r\n\r\n找到“病毒和威胁防护”设置，点击“管理设置”，如上图所示，\r\n\r\n将右侧的“实时保护”、“云提供保护”、“自动提交样本”、“篡改保护”四项全部手动关掉，如上图所示，\r\n\r\nPS：如果使用的是系统自带的Edge浏览器，还会阻止我们下载，这时，我们打开浏览器，点击右上角的三个点“···”-“设置”，\r\n\r\n在左侧搜索框里输入“smartscreen”，然后在右侧将“Microsoft Defnder Smartscreen”的选项关闭掉即可。', 133, '2025-12-10 01:59:19', NULL);
INSERT INTO `post` VALUES (33, 4, 1, '全面剖析固态硬盘M.2接口与PCI-E SSD固态硬盘的关系', '经常玩硬件的小伙伴们肯定对固态硬盘的M.2接口和PCI-E SSD有所了解，但很多小伙伴都有一个疑问，那就是为什么我的固态硬盘是PCI-E接口，经过跑分测试速度却与SATA 3.0接口的固态硬盘速度差不多？到底是购买的产品质量有问题，还是搭配的平台环境有问题？还是我们对固态硬盘的接口概念一知半解？今天亦是美网络小编就给大家讲讲固态硬盘M.2接口与PCI-E SSD的关系。\r\n\r\n首先，我们来了解一下什么是固态硬盘M.2接口，M.2接口是英特尔公司推出的一种替代MSATA接口的新接口规范标准，也就是我们以前经常提到的NGFF接口，并且M.2接口有两种规格类型：Socket 2和Socket 3，其中Socket 2类型支持SATA和PCI-E 2.0双通道接口，最大读取速度为700M/S，最大写入速度550M/S；Socket 3接口则支持PCI-E 3.0四通道接口，理论速度可以达到4GB/S。\r\n\r\n其次，那什么是PCI-E固态硬盘呢？PCI-E固态硬盘就是总线采用PCI-E来实现传输的固态硬盘，PCI-E也是英特尔公司提出的最新的总线标准，PCI-E总线采用点对点串行连接的设备连接方式，每个设备都有自己的专用连接，可以把数据传输率提高到一个很高的频率10GB/S，固态硬盘的PCI-E接口是一种表现形式，可能是PCI-E传统接口，以显卡接口的形式出现，也可能以M.2接口的形式出现，关键在于固态硬盘的PCI-E原生/桥接主控，这决定它是否能走PCI-E总线。\r\n\r\n第三，PCI-E固态硬盘与M.2接口有什么关系呢？大家都知道M.2接口提供PCI-E总线通道，同样的有的采用PCI-E总线的固态硬盘也可能以M.2接口形式出现，但是要注意，不同的主板提供的M.2接口所支持的通道也是不一样的，有的主板仅支持PCI-E和SATA通道中的一种，有的主板则同时兼容这两种通道，后者的主板既可以支持PCI-E通道的固态硬盘，也可以支持SATA 3.0通道的固态硬盘。总结：有M.2接口的主板不一定支持PCI-E固态硬盘。\r\n\r\n第四，为什么PCI-E接口的固态硬盘达不到官方标称的速度？上面已经讲到，并不是所有的PCI-E固态硬盘都采用M.2主板接口，同样的并不是所有支持M.2主板接口的固态硬盘都是PCI-E总线固态硬盘，是不是有点绕？绕就对 了，这些概念需要反复揣摩去理解才行，只有当固态硬盘的主控是PCI-E控制器时，它才是真正的PCI-E固态硬盘，另外，即使是真正的PCI-E固态硬盘，如果安装到了仅支持SATA总线的M.2接口的主板上，PCI-E接口的固态硬盘也不能完全发挥性能，其只能达到SATA 3.0固态硬盘的表现，只有当采用PCI-E总线的固态硬盘安装到了支持PCI-E总线的M.2接口的主板上，PCI-E固态硬盘才能发挥其最大性能。', 167, '2025-12-10 02:00:05', NULL);
INSERT INTO `post` VALUES (34, 4, 1, '系统安装教程大汇总：win系统版本下载 + 系统安装/重装/升级/封装教程', '本文关于系统下载、重装、激活的文章很多，很多同学反映教程简单易懂并且很适合新手学习，但也有很多同学反映虽然关于系统方面的介绍有很多，但是篇幅比较混乱，不够系统，要是能整合到一起就好了，虽然笔者之前给大家整理过一次，但还是不够详尽，今天刚好有空，亦是美网络小编就把关于win7/win8/win10等系统的下载地址、安装/重装/升级教程、系统封装教程、系统激活方法等再给大家归结一下吧。', 241, '2026-01-05 15:00:30', NULL);
INSERT INTO `post` VALUES (35, 4, 1, '实战绝招分享：半个月变身计算机大神就是这样练成的', '提起“计算机大神”这个词，其实笔者是挺不喜欢的，何谓大神？笔者认为在某一领域有深刻研讨、资历比较深的人可以称之为“大神”。但是在网络用语中，尤其在计算机领域，大神往往不是这个样子的，起码不需要深资历，当然了，能深入研讨是非常难能可贵的，那么计算机大神到底是什么样子呢？如何在短时间内变身计算机大神呢？计算机大神在不同的人群眼里有不同的定义：\r\n\r\n第一阶段、在计算机小白们的眼里：会装系统、会分区、会使用各种软件、了解各种计算机资源的人就是计算机大神。\r\n\r\n第二阶段、在普通计算机使用者眼里：能解决计算机常见问题、软硬件故障的人就是计算机大神。\r\n\r\n第三阶段、在喜欢摆弄、折腾计算机的”骚年“眼里：不仅会以上两种技能，还对计算机有深入了解和操作的人就是计算机大神。\r\n\r\n第四阶段、让许多人都望尘莫及的：各种高级职称的软件开发工程师、系统架构师、云计算设计师、大数据工程师等。', 144, '2025-12-11 11:01:05', NULL);

-- ----------------------------
-- Table structure for remark
-- ----------------------------
DROP TABLE IF EXISTS `remark`;
CREATE TABLE `remark`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评价id',
  `star` int(11) NULL DEFAULT NULL COMMENT '星级',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评价内容',
  `task_id` int(11) NOT NULL COMMENT '任务id',
  `accept_id` int(11) NOT NULL COMMENT '送货人id',
  `publish_id` int(11) NOT NULL COMMENT '评价人id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `task_id`(`task_id`) USING BTREE,
  INDEX `accept_id`(`accept_id`) USING BTREE,
  INDEX `publish_id`(`publish_id`) USING BTREE,
  CONSTRAINT `accept_id` FOREIGN KEY (`accept_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `publish_id` FOREIGN KEY (`publish_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `task_id` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of remark
-- ----------------------------
INSERT INTO `remark` VALUES (1, 5, '好', 2, 6, 5);
INSERT INTO `remark` VALUES (2, 5, '好', 3, 1, 10);
INSERT INTO `remark` VALUES (3, 5, '123123', 4, 1, 10);
INSERT INTO `remark` VALUES (4, 5, '1231231', 4, 1, 10);
INSERT INTO `remark` VALUES (5, 3, '勉勉强强', 17, 2, 4);

-- ----------------------------
-- Table structure for school
-- ----------------------------
DROP TABLE IF EXISTS `school`;
CREATE TABLE `school`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '学校id',
  `name` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '学校名称',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of school
-- ----------------------------
INSERT INTO `school` VALUES (2, '北京大学');
INSERT INTO `school` VALUES (3, '华南理工');
INSERT INTO `school` VALUES (1, '广州理工');

-- ----------------------------
-- Table structure for student.bak
-- ----------------------------
DROP TABLE IF EXISTS `student.bak`;
CREATE TABLE `student.bak`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '学生编号',
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `age` int(11) NULL DEFAULT NULL COMMENT '年龄',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of student.bak
-- ----------------------------

-- ----------------------------
-- Table structure for task
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `publish_user_id` int(11) NOT NULL COMMENT '用户发布id',
  `accept_user_id` int(11) NULL DEFAULT NULL COMMENT '接受任务用户id',
  `user_school_id` int(11) NOT NULL COMMENT '用户所在的学校id',
  `reward` double NULL DEFAULT 0 COMMENT '任务奖励',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `order_time` timestamp NULL DEFAULT NULL COMMENT '接单时间',
  `end_time` timestamp NULL DEFAULT NULL COMMENT '结束时间',
  `task_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务标题',
  `task_context` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `state` int(11) NOT NULL DEFAULT 0 COMMENT '状态',
  `img_url` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '求助图片，多图逗号分隔',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_TASK_PUBLISH_USER`(`publish_user_id`) USING BTREE,
  INDEX `FK_TASK_ACCEPT_USER`(`accept_user_id`) USING BTREE,
  INDEX `FK_TASK_USER_SCHOOL`(`user_school_id`) USING BTREE,
  CONSTRAINT `FK_TASK_ACCEPT_USER` FOREIGN KEY (`accept_user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_TASK_PUBLISH_USER` FOREIGN KEY (`publish_user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_TASK_USER_SCHOOL` FOREIGN KEY (`user_school_id`) REFERENCES `school` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of task
-- ----------------------------
INSERT INTO `task` VALUES (2, 5, 6, 1, 0, '2025-12-15 19:09:54', '2025-12-15 19:10:29', '2025-12-15 19:11:54', '123', '123', 2, NULL);
INSERT INTO `task` VALUES (3, 10, 1, 1, 0, '2025-12-15 19:32:48', '2025-12-15 19:33:02', '2025-12-15 19:33:14', '求助', '巴巴博一', 2, NULL);
INSERT INTO `task` VALUES (4, 10, 1, 1, 0, '2025-12-16 10:55:20', '2025-12-16 10:56:27', '2025-12-16 10:57:08', '123', '123', 2, NULL);
INSERT INTO `task` VALUES (6, 10, 2, 1, 0, '2025-12-17 21:26:58', '2026-01-01 01:47:21', NULL, '电脑进不去Bios怎么办', '这好像是个常见问题，但我找不到其他人有同样的症状。这基本上是从我清理内存条开始的；我把它取出来，除尘，然后放回同一个DIMM插槽。清理的时候，我注意到它的额定速度和运行速度不一样，这才意识到我肯定从来没在BIOS里启用XMP。', 1, NULL);
INSERT INTO `task` VALUES (7, 1, NULL, 1, 0, '2025-12-16 13:29:30', NULL, NULL, '谁能教我笔记本清下灰', '笔记本用了快3年,最近一直发热,应该是需要清灰了,但是我不懂这些也不敢自己操作', 0, NULL);
INSERT INTO `task` VALUES (16, 2, NULL, 1, 0, '2025-12-22 06:56:07', NULL, NULL, '1', '1', 0, '/profile/common/202512/7dbe452e-c310-40ab-8468-8eb197e3c836.png');
INSERT INTO `task` VALUES (17, 4, 2, 1, 0, '2025-12-22 07:52:16', '2025-12-22 08:39:08', '2025-12-22 09:03:07', '买了 M2 硬盘但不敢自己安装，求大佬帮忙', '最近想给笔记本升级一下存储空间，趁着双十一入手了一块三星 980 Pro 1TB M.2 NVMe 固态硬盘。今天收到货后兴致勃勃地拆开后盖，结果看到里面密密麻麻的主板和排线，瞬间怂了...怕自己手残把笔记本搞坏了。\n所以想在这里求助一下：\n\n有没有懂电脑的大佬愿意帮忙安装？​ 我在海淀区中关村附近，可以请吃饭或者支付合理的辛苦费\n或者求推荐中关村附近靠谱的电脑维修店？​ 希望是技术好、不乱收费的那种\n\n    如果有详细的安装教程也求分享！​ 实在找不到人的话，我也可以硬着头皮自己试试\n\n我的笔记本信息：\n\n型号：联想小新 Pro 14 2021款\n现有硬盘：512GB 固态\n新硬盘：三星 980 Pro 1TB M.2 NVMe\n', 2, '/profile/common/202512/8b41355a-6728-4afc-843f-33f464627a7e.jpg,/profile/common/202512/76d00e90-21d2-4da8-83ef-06a0aea8d41d.jpg');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `student_id` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '学号',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `school_id` int(11) NOT NULL COMMENT '学校id',
  `dept_id` int(11) NULL DEFAULT NULL COMMENT '系别id',
  `class_id` int(11) NULL DEFAULT NULL COMMENT '班级id',
  `sex` int(11) NULL DEFAULT 0 COMMENT '性别',
  `username` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `signature` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '个人简介',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电子邮箱',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `state` int(11) NOT NULL DEFAULT 0 COMMENT '状态',
  `balance` double NULL DEFAULT 0 COMMENT '余额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_USER_SCHOOL`(`school_id`) USING BTREE,
  INDEX `FK_USER_DEPT`(`dept_id`) USING BTREE,
  INDEX `FK_USER_CLASS`(`class_id`) USING BTREE,
  CONSTRAINT `FK_USER_CLASS` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_USER_DEPT` FOREIGN KEY (`dept_id`) REFERENCES `dept` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_USER_SCHOOL` FOREIGN KEY (`school_id`) REFERENCES `school` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '20250101', 'e10adc3949ba59abbe56e057f20f883e', '18999999991', 1, 1, 1, 1, '1more小汉堡', '/profile/avatar/202512/873bb609-45be-45d1-b282-0090aef03cc6.jpg', '巴巴博一', 'ming@qh.edu.com', '2025-12-15 18:27:27', 0, 99);
INSERT INTO `user` VALUES (2, '20250102', 'e10adc3949ba59abbe56e057f20f883e', '18999999992', 1, 1, 3, 1, '氓の蚩', '/profile/avatar/202512/83d03f2b-adb9-4a7c-9658-968a1d57e19e.jpg', '不见复关，泣涕涟涟.', 'leivmox@gmail.com', '2025-12-15 18:27:48', 0, 32);
INSERT INTO `user` VALUES (3, '20250103', 'e10adc3949ba59abbe56e057f20f883e', '18999999993', 1, 2, 2, 0, '不吃香菜', '', NULL, NULL, '2025-12-15 18:28:01', 0, 99);
INSERT INTO `user` VALUES (4, '20250104', 'e10adc3949ba59abbe56e057f20f883e', '18999999994', 1, 2, 2, 1, '龙龙打go', '/profile/avatar/202512/4ad9f7ea-2ad6-44b2-be42-c24b08733165.png', '梦', NULL, '2025-12-15 18:28:11', 0, 69);
INSERT INTO `user` VALUES (5, '20250105', 'e10adc3949ba59abbe56e057f20f883e', '18999999995', 1, 2, 2, 0, '巴巴博一', '', NULL, NULL, '2025-12-15 18:35:15', 0, 99);
INSERT INTO `user` VALUES (6, '20250106', 'e10adc3949ba59abbe56e057f20f883e', '18999999996', 1, 1, 3, 1, '番茄炒蛋', '', NULL, NULL, '2025-12-15 18:36:29', 0, 99);
INSERT INTO `user` VALUES (10, '20250110', 'e10adc3949ba59abbe56e057f20f883e', '18999933333', 1, 1, 3, 0, '张伟1', '', NULL, NULL, '2025-12-15 19:32:18', 0, 10);
INSERT INTO `user` VALUES (11, '000003', 'e10adc3949ba59abbe56e057f20f883e', '13800000001', 1, 2, 2, 1, '林小雨', '', NULL, NULL, '2026-01-30 01:30:01', 0, 500);
INSERT INTO `user` VALUES (12, '000004', 'e10adc3949ba59abbe56e057f20f883e', '13800000002', 1, 2, 2, 0, '张明远', '', NULL, NULL, '2026-01-30 01:31:44', 0, 800);
INSERT INTO `user` VALUES (13, '000005', 'e10adc3949ba59abbe56e057f20f883e', '13800000003', 2, 1, 1, 0, '王子轩', '', NULL, NULL, '2026-01-30 01:31:44', 0, 600);
INSERT INTO `user` VALUES (14, '000006', 'e10adc3949ba59abbe56e057f20f883e', '13800000004', 2, 1, 1, 1, '陈思琪', '', NULL, NULL, '2026-01-30 01:31:44', 0, 750);
INSERT INTO `user` VALUES (15, '000007', 'e10adc3949ba59abbe56e057f20f883e', '13800000005', 1, 2, 2, 0, '李浩然', '', NULL, NULL, '2026-01-30 01:31:44', 0, 300);
INSERT INTO `user` VALUES (16, '000008', 'e10adc3949ba59abbe56e057f20f883e', '13800000006', 2, 1, 1, 1, '周雨晴', '', NULL, NULL, '2026-01-30 01:31:44', 0, 450);
INSERT INTO `user` VALUES (17, '200001', 'e10adc3949ba59abbe56e057f20f883e', '13700000001', 1, 1, 1, 0, '陈俊豪', '', NULL, NULL, '2026-01-30 01:39:16', 0, 500);
INSERT INTO `user` VALUES (18, '200002', 'e10adc3949ba59abbe56e057f20f883e', '13700000002', 1, 1, 3, 1, '林晓燕', '', NULL, NULL, '2026-01-30 01:39:54', 0, 600);
INSERT INTO `user` VALUES (19, '200003', 'e10adc3949ba59abbe56e057f20f883e', '13700000003', 1, 2, 2, 0, '黄志伟', '', NULL, NULL, '2026-01-30 01:39:57', 0, 450);
INSERT INTO `user` VALUES (20, '200004', 'e10adc3949ba59abbe56e057f20f883e', '13700000004', 1, 1, 4, 1, '杨思敏', '', NULL, NULL, '2026-01-30 01:40:07', 0, 700);
INSERT INTO `user` VALUES (21, '200005', 'e10adc3949ba59abbe56e057f20f883e', '13700000005', 1, 2, 2, 0, '吴嘉豪', '', NULL, NULL, '2026-01-30 01:40:11', 0, 380);
INSERT INTO `user` VALUES (22, '200006', 'e10adc3949ba59abbe56e057f20f883e', '13700000006', 1, 1, 1, 1, '郑雅婷', '', NULL, NULL, '2026-01-30 01:40:16', 0, 520);

-- ----------------------------
-- Table structure for user_like
-- ----------------------------
DROP TABLE IF EXISTS `user_like`;
CREATE TABLE `user_like`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `target_id` bigint(20) NOT NULL,
  `target_type` int(11) NOT NULL COMMENT '1-帖子，2-评论',
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_like
-- ----------------------------
INSERT INTO `user_like` VALUES (33, 2, 9, 1, '2025-12-24 02:35:12');
INSERT INTO `user_like` VALUES (49, 2, 11, 1, '2025-12-24 02:52:00');

SET FOREIGN_KEY_CHECKS = 1;
