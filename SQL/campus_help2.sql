/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50724 (5.7.24)
 Source Host           : localhost:3306
 Source Schema         : campus_help

 Target Server Type    : MySQL
 Target Server Version : 50724 (5.7.24)
 File Encoding         : 65001

 Date: 10/04/2026 22:18:18
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
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `chat_message` VALUES (29, 2, 1, '321942587.gif', '2026-03-04 06:24:02', 2, 1);
INSERT INTO `chat_message` VALUES (30, 1, 2, '321942607.gif', '2026-03-04 06:47:33', 2, 1);
INSERT INTO `chat_message` VALUES (31, 1, 2, '321942586.gif', '2026-03-04 06:47:41', 2, 1);
INSERT INTO `chat_message` VALUES (32, 1, 2, '321942597.gif', '2026-03-04 06:52:37', 2, 1);
INSERT INTO `chat_message` VALUES (33, 1, 2, '321942587.gif', '2026-03-04 06:52:38', 2, 1);
INSERT INTO `chat_message` VALUES (34, 1, 2, '321942587.gif', '2026-03-04 06:52:39', 2, 1);
INSERT INTO `chat_message` VALUES (35, 1, 2, '321942587.gif', '2026-03-04 06:52:40', 2, 1);
INSERT INTO `chat_message` VALUES (36, 1, 2, '321942587.gif', '2026-03-04 06:52:41', 2, 1);
INSERT INTO `chat_message` VALUES (37, 10, 1, '321942607.gif', '2026-03-11 19:08:07', 2, 1);
INSERT INTO `chat_message` VALUES (38, 10, 1, '你好同学,我可以帮你看看电脑', '2026-03-11 19:08:36', 0, 1);
INSERT INTO `chat_message` VALUES (39, 1, 15, '111', '2026-03-11 19:24:37', 0, 0);
INSERT INTO `chat_message` VALUES (40, 1, 10, '你好', '2026-03-11 19:25:13', 0, 1);
INSERT INTO `chat_message` VALUES (41, 10, 1, '如果可以,方便远程看看吗', '2026-03-11 19:25:15', 0, 1);
INSERT INTO `chat_message` VALUES (42, 1, 10, '731724196.gif', '2026-03-17 02:25:14', 2, 1);
INSERT INTO `chat_message` VALUES (43, 10, 1, '怎么了?', '2026-03-17 03:01:55', 0, 1);
INSERT INTO `chat_message` VALUES (44, 10, 1, '321942586.gif', '2026-03-17 03:02:05', 2, 1);
INSERT INTO `chat_message` VALUES (45, 11, 1, '你好', '2026-04-09 23:57:59', 0, 0);
INSERT INTO `chat_message` VALUES (46, 11, 1, '我接取了你的求助', '2026-04-09 23:58:15', 0, 0);
INSERT INTO `chat_message` VALUES (47, 11, 1, '请问方便帮忙吗', '2026-04-09 23:58:28', 0, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 78 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `comment` VALUES (77, 30, 1, '好看', '2026-03-11 19:23:55');

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
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '测试公告', 0xE7B3BBE7BB9FE6B58BE8AF95E68890E58A9FEFBC8CE6ADA3E5BC8FE4B88AE7BABFEFBC8CE6ACA2E8BF8EE4BDBFE794A8EFBC81, '管理员', '2025-10-18 17:31:50', '无');
INSERT INTO `notice` VALUES (4, '平台正式上线公告', 0xE4BAB2E788B1E79A84E5908CE5ADA6E4BBACEFBC8CE6A0A1E59BAD4954E68A80E69CAFE694AFE68C81E4B88EE8B584E6BA90E585B1E4BAABE5B9B3E58FB0E6ADA3E5BC8FE4B88AE7BABFE595A6EFBC81E69CACE5B9B3E58FB0E887B4E58A9BE4BA8EE4B8BAE585A8E6A0A1E5B888E7949FE68F90E4BE9BE4BEBFE68DB7E79A84E68A80E69CAFE4BA92E58AA9E69C8DE58AA1EFBC8CE6ACA2E8BF8EE5A4A7E5AEB6E7A7AFE69E81E4BDBFE794A8E38082E5A682E69C89E997AEE9A298E8AFB7E58F8AE697B6E58F8DE9A688E38082, 'admin', '2026-01-05 09:00:00', '上线公告');
INSERT INTO `notice` VALUES (5, '寒假期间服务安排', 0xE5AF92E58187E69C9FE997B4EFBC8832303236E5B9B431E69C883135E697A52D32E69C883230E697A5EFBC89EFBC8CE5B9B3E58FB0E5B086E4BF9DE68C81E6ADA3E5B8B8E8BF90E8A18CE38082E5A682E98187E7B4A7E680A5E68A80E69CAFE997AEE9A298EFBC8CE58FAFE9809AE8BF87E699BAE883BDE58AA9E6898BE88EB7E58F96E5B8AEE58AA9E38082E7A59DE5A4A7E5AEB6E58187E69C9FE68489E5BFABEFBC81, 'admin', '2026-01-12 14:30:00', '假期通知');
INSERT INTO `notice` VALUES (6, '新功能上线通知', 0xE5B9B3E58FB0E696B0E5A29E4149E699BAE883BDE58AA9E6898BE58A9FE883BDEFBC8CE694AFE68C813234E5B08FE697B6E59CA8E7BABFE997AEE7AD94EFBC8CE5B8AEE58AA9E5A4A7E5AEB6E5BFABE9809FE8A7A3E586B3E68A80E69CAFE99ABEE9A298E38082E5BFABE69DA5E4BD93E9AA8CE590A7EFBC81, 'admin', '2026-01-18 10:00:00', '功能更新');
INSERT INTO `notice` VALUES (7, '春节放假通知', 0xE580BCE6ADA4E696B0E698A5E4BDB3E88A82E69DA5E4B8B4E4B98BE99985EFBC8CE7A59DE585A8E4BD93E5B888E7949FE696B0E698A5E5BFABE4B990E38081E4B887E4BA8BE5A682E6848FEFBC81E5B9B3E58FB0E698A5E88A82E69C9FE997B4E6ADA3E5B8B8E5BC80E694BEEFBC8CE6ACA2E8BF8EE99A8FE697B6E4BDBFE794A8E38082, 'admin', '2026-01-25 16:00:00', '节日祝福');
INSERT INTO `notice` VALUES (8, '开学温馨提示', 0xE696B0E5ADA6E69C9FE58DB3E5B086E5BC80E5A78BEFBC8CE8AFB7E5908CE5ADA6E4BBACE58F8AE697B6E69BB4E696B0E4B8AAE4BABAE4BFA1E681AFEFBC8CE5AE8CE59684E4B8AAE4BABAE8B584E69699E38082E7A59DE5A4A7E5AEB6E696B0E5ADA6E69C9FE5ADA6E4B89AE8BF9BE6ADA5EFBC81, 'admin', '2026-02-15 09:00:00', '开学通知');
INSERT INTO `notice` VALUES (9, '求助功能优化公告', 0xE6B182E58AA9E4B8ADE5BF83E58A9FE883BDE5B7B2E4BC98E58C96E58D87E7BAA7EFBC8CE696B0E5A29EE4BBBBE58AA1E8BF9BE5BAA6E8BFBDE8B8AAE58A9FE883BDEFBC8CE58F91E5B883E5928CE68EA5E58F97E6B182E58AA9E69BB4E58AA0E4BEBFE68DB7E9AB98E69588E38082, 'admin', '2026-02-22 11:00:00', '功能优化');
INSERT INTO `notice` VALUES (10, '论坛版规公告', 0xE4B8BAE890A5E980A0E889AFE5A5BDE79A84E4BAA4E6B581E6B09BE59BB4EFBC8CE8AFB7E5A4A7E5AEB6E59CA8E8AEBAE59D9BE58F91E8A880E697B6E981B5E5AE88E78988E8A784EFBC8CE69687E6988EE4BAA4E6B581EFBC8CE585B1E5908CE7BBB4E68AA4E5928CE8B090E79A84E6A0A1E59BADE7A4BEE58CBAE78EAFE5A283E38082, 'admin', '2026-03-01 10:00:00', '版规提醒');
INSERT INTO `notice` VALUES (11, '积分规则说明', 0xE5B9B3E58FB0E7A7AFE58886E8A784E58899E5B7B2E69BB4E696B0EFBC9AE58F91E5B883E6B182E58AA9E6B688E88097E7A7AFE58886EFBC8CE68890E58A9FE5B8AEE58AA9E4BB96E4BABAE58FAFE88EB7E5BE97E7A7AFE58886E5A596E58AB1E38082E8AFA6E7BB86E8A784E58899E8AFB7E69FA5E79C8BE5B8AEE58AA9E4B8ADE5BF83E38082, 'admin', '2026-03-08 14:00:00', '规则说明');
INSERT INTO `notice` VALUES (12, '网络安全提醒', 0xE8AFB7E5908CE5ADA6E4BBACE6B3A8E6848FE4BF9DE68AA4E4B8AAE4BABAE99A90E7A781E4BFA1E681AFEFBC8CE4B88DE8A681E59CA8E5B9B3E58FB0E6B384E99CB2E5AF86E7A081E38081E993B6E8A18CE58DA1E7AD89E6958FE6849FE4BFA1E681AFE38082E5A682E58F91E78EB0E58FAFE79691E8A18CE4B8BAE8AFB7E58F8AE697B6E4B8BEE68AA5E38082, 'admin', '2026-03-15 09:30:00', '安全提醒');
INSERT INTO `notice` VALUES (13, '三月活动预告', 0xE4B889E69C88E5B086E4B8BEE58A9E22E6A0A1E59BADE68A80E69CAFE8BEBEE4BABA22E8AF84E98089E6B4BBE58AA8EFBC8CE7A7AFE69E81E58F82E4B88EE6B182E58AA9E4BA92E58AA9E79A84E5908CE5ADA6E69C89E69CBAE4BC9AE88EB7E5BE97E88DA3E8AA89E7A7B0E58FB7E5928CE7A7AFE58886E5A596E58AB1EFBC8CE695ACE8AFB7E69C9FE5BE85EFBC81, 'admin', '2026-03-20 15:00:00', '活动预告');

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
  `is_top` int(11) NULL DEFAULT 0 COMMENT '是否置顶 0-否 1-是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of post
-- ----------------------------
INSERT INTO `post` VALUES (2, 3, 1, '怎么卸载智能看图啊', '今日某度盘软件更新了之后附带了一个流氓软件-“智能看图”，会把默认的看图软件覆盖掉，由于其风格模仿了Windows自带的看图软件，让我一度以为是Windows自带看图软件...', 3, '2025-12-15 18:33:21', NULL, 0);
INSERT INTO `post` VALUES (3, 1, 1, '分享一个好用的翻译工具', '英文音效看不懂、不会搜？别再一个个猜单词了！用出片音效素材批量翻译工具，简单好用！', 5, '2025-12-15 18:41:05', '', 0);
INSERT INTO `post` VALUES (8, 2, 1, '测试111', '测试1111', 1, '2025-12-22 05:04:00', '/profile/post/202512/24acb8f7-e0c6-4635-96c0-a5002fe195c5.jpg,/profile/post/202512/697cf8cd-89fe-4b01-82bd-aa9b1cc97b76.jpg', 0);
INSERT INTO `post` VALUES (9, 2, 1, '测试字数123', '达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊达萨罗激发感觉阿是劳动工具啊受力钢筋拉上个;啦司空见惯,阿萨德两个空间阿萨德高科技, 阿萨德刚颗粒剂,\n阿萨德公交卡萨迪克感觉, 大概时间撒大哥,阿萨德刚阿萨德噶是的可根据, 奥古斯丁阿萨德高科技阿斯利康感觉,阿萨德刚卡卡怪咖狮吼功看,阿三哥,阿斯利康攻击力凯撒立卡时间管理会计阿三哥,阿是楷林国际啊', 18, '2025-12-22 05:35:50', '/profile/post/202512/362e95ef-aa92-44b2-8314-dc3e9d405ffe.jpg,/profile/post/202512/564e4209-46f2-4d75-a1a8-522e42d441d4.jpg', 0);
INSERT INTO `post` VALUES (11, 4, 1, '想用Django+React做个技术交流平台', '我是计算机学院大二的学生，最近想搭建一个校园内部的IT技术交流论坛，主要面向我们学校的同学交流编程、项目经验、技术分享等。目前有一些想法，但技术栈选择上有点迷茫，想请教一下有经验的同学。\n我的需求：\n\n用户系统：学号/邮箱注册登录，个人资料修改\n帖子功能：发布、分类、评论、点赞\n资源分享：上传学习资料、项目代码\n私信系统：用户间私信交流\n\n    通知中心：评论、点赞等消息提醒\n\n技术选型考虑：\n\n后端：Django（Python）或 Spring Boot（Java）\n前端：React 或 Vue.js\n数据库：MySQL 或 PostgreSQL\n\n    部署：学校服务器或云服务（阿里云学生机）\n\n遇到的问题：\n\nDjango REST Framework 和 Spring Boot 哪个更适合校园项目？\n前端用 React 还是 Vue 更容易上手？\n用户认证系统怎么设计比较安全？\n如何实现文件上传和存储？\n\n    有没有现成的开源项目可以参考？\n\n我的背景：\n\n学过 Python 基础，Django 刚入门\n了解一些前端三件套（HTML/CSS/JS）\n\n    数据库学过 MySQL 基础\n\n求助方向：\n\n有没有做过类似项目的学长学姐可以分享经验？\n推荐一些适合的学习资料或教程？\n学校有没有相关的技术支持或服务器资源？\n\n    如果有同学感兴趣，也可以一起组队开发！\n\n联系方式：可以私信我或回复帖子，我们可以约个时间详细聊。\n感谢各位！期待大家的建议和指导！', 23, '2025-12-22 08:35:29', '/profile/post/202512/a1e747e2-fe28-4ba9-930e-0df6fe1e535b.jpg', 0);
INSERT INTO `post` VALUES (12, 1, 1, '期末复习求组队', '有没有一起复习高数的同学？图书馆三楼老位置，带上你的笔记本！', 12, '2026-01-15 10:30:00', '/profile/post/202603/c90225e2-d09c-46d2-b1cb-c21d2a5d8e4b.jpg', 0);
INSERT INTO `post` VALUES (13, 2, 1, '食堂新菜品测评', '今天试了西区食堂的新出的黄焖鸡，味道还不错，推荐大家去尝尝！', 28, '2026-01-18 12:15:00', NULL, 0);
INSERT INTO `post` VALUES (14, 3, 1, '求助！笔记本电脑开不了机', '今天早上电脑突然黑屏，按电源键没反应，有懂的大佬吗？', 5, '2026-01-20 09:00:00', '/profile/post/202603/090fd57e-fa2e-4167-a43b-fbde303a5463.jpg', 0);
INSERT INTO `post` VALUES (15, 4, 1, '校园跑步打卡Day30', '坚持一个月了！每天绕操场5圈，感觉身体状态好多了', 45, '2026-01-22 07:30:00', '/profile/post/202603/8b430761-8712-429b-856d-8625d0ae7aac.jpg', 0);
INSERT INTO `post` VALUES (16, 5, 2, '北大图书馆占座指南', '分享一下我的占座经验：早上7点去东门排队，亲测有效', 67, '2026-01-19 08:00:00', NULL, 0);
INSERT INTO `post` VALUES (17, 6, 2, '今日份的落日', '傍晚在未名湖边拍的，太美了！分享给大家', 89, '2026-01-21 17:45:00', '/profile/post/202603/9b8f0aa5-0c99-4272-a35c-bd3e972411d1.png', 0);
INSERT INTO `post` VALUES (18, 3, 1, 'Java期末项目求助', '有没有大佬带带我，SpringBoot项目跑不起来', 8, '2026-01-25 14:20:00', '/profile/post/202603/a99e51a0-b779-49d3-9c28-56b34fae234d.jpg', 0);
INSERT INTO `post` VALUES (19, 13, 2, '失物招领：蓝色保温杯', '在理教302捡到一个蓝色保温杯，失主请联系我', 3, '2026-01-26 16:00:00', NULL, 0);
INSERT INTO `post` VALUES (20, 3, 1, '推荐一个宝藏自习室', '学校东边创业园区三楼有个共享自习室，人少安静', 34, '2026-01-27 11:00:00', NULL, 0);
INSERT INTO `post` VALUES (21, 5, 2, '考研还是就业？', '大三了开始焦虑了，有经验的学长学姐能分享一下吗', 56, '2026-01-28 20:30:00', '/profile/post/202603/77962782-7d3b-4c15-bda5-bc6adf8d9b39.jpg', 0);
INSERT INTO `post` VALUES (22, 17, 1, '广理食堂哪家强', '个人觉得二饭的麻辣香锅最好吃，三饭的奶茶也不错', 23, '2026-01-20 12:00:00', '/profile/post/202603/4bd26f9d-5f38-4704-91fd-b1b35dbab7ce.jpg', 0);
INSERT INTO `post` VALUES (23, 19, 1, '计算机网络期末重点', '整理了一份计网重点，需要的同学私信我', 56, '2026-01-22 15:00:00', NULL, 0);
INSERT INTO `post` VALUES (24, 18, 1, '求租电动车', '有没有人闲置的小电驴出租，代步用，价格好商量', 8, '2026-01-21 09:30:00', NULL, 0);
INSERT INTO `post` VALUES (25, 20, 1, '校园歌手大赛报名啦', '一年一度的校园歌手大赛开始报名了，有才艺的快来', 34, '2026-01-23 10:00:00', NULL, 0);
INSERT INTO `post` VALUES (26, 21, 1, '图书馆空调太冷了', '每次去图书馆都要带件外套，冻死了，有同感的吗', 42, '2026-01-24 14:20:00', NULL, 0);
INSERT INTO `post` VALUES (27, 22, 1, '寻找羽毛球搭子', '每周三晚上体育馆约球，目前三缺一，速来', 15, '2026-01-25 18:00:00', NULL, 0);
INSERT INTO `post` VALUES (28, 17, 1, '快递站排队太久了', '双十一的快递到现在还没取完，排队排了半小时', 67, '2026-01-26 16:30:00', '/profile/post/202603/a62662f9-167e-4a8f-8ddf-0249ee72f7b0.png', 0);
INSERT INTO `post` VALUES (29, 18, 1, '推荐校门口奶茶店', '新开了家茶百道，杨枝甘露超好喝', 29, '2026-01-27 11:00:00', '/profile/post/202603/f5d6e145-ca1d-4d54-804b-6cc5422a7e52.png', 0);
INSERT INTO `post` VALUES (30, 20, 1, '晚霞好美', '今天傍晚的天空太好看了，随手一拍都是壁纸', 89, '2026-01-29 17:45:00', '/profile/post/202603/5d540dbb-6123-4a3f-9052-265051cfb54c.png', 0);
INSERT INTO `post` VALUES (31, 4, 1, '最全的微软msdn原版Windows系统镜像和Office Visio Project下载地址集锦', '随着windows的发展，越来越多的人都热衷于微软的原版系统下载了，相比之前的版本比如winxp版本，windows vista/win7/win8/win8.1/win10/win11后来的版本在安装方面也比较简单了，所以ghost系统正在渐渐的消失市场，即便如此，很多同学还是找不到微软原版的系统和office下载，所以亦是美网络特意归结了一下微软msdn原版系统和原版office各个版本的下载，希望对正在苦苦找寻原版系统的同学有所帮助。\r\n\r\n说在前面的话：\r\n\r\n1、本文提供的镜像包括：Windows、Server、Office、Visio、Project等\r\n\r\n2、选装Windows系统或Office、Visio、Project版本，一般来说专业版较适合我们！\r\n\r\n3、Windows / Server、Office / Visio / Project激活请：点击此处\r\n\r\n4、以下地址建议使用迅雷下载工具进行下载\r\n\r\n5、如需帮助，请不吝发件至邮箱：yishimeicn@qq.com\r\n\r\n推荐相关阅读：\r\n\r\n专业U盘格式化与系统安装启动盘制作工具 - rufus 4.11中文版 说明介绍\r\n\r\n关于Windows服务器版本（Server2003/2008/2012/2016/2019/2022/2025）的下载、安装与激活说明\r\n\r\nwindows 11 家庭版/家庭单语言版/教育版/专业版/专业教育版/专业工作站版 简体中文\r\n\r\nmagnet:?xt=urn:btih:808632e57ba30de8f564ec8e62ffdbe495c7bcae&dn=zh-cn_windows_11_consumer_editions_version_25h2_updated_dec_2025_x64_dvd_115b2867.iso&xl=8330770432\r\n\r\nwindows 11 教育版/专业版/专业教育版/企业版/专业工作站版 简体中文\r\n\r\nmagnet:?xt=urn:btih:c46a16eb293e3386d1e4b717624c83086aae7e02&dn=zh-cn_windows_11_business_editions_version_25h2_updated_dec_2025_x64_dvd_5aa0bca1.iso&xl=8245350400\r\n\r\nwindows 11 Enterprise LTSC 2024 简体中文：\r\n\r\nmagnet:?xt=urn:btih:b84e74c1dbcc88a02c5b24a6f84383f353a2e1dd&dn=zh-cn_windows_11_enterprise_ltsc_2024_x64_dvd_cff9cd2d.iso&xl=5287520256\r\n\r\nWindows 11 Pro China Only 专业中文版\r\n\r\ned2k://|file|Win11_24H2_Pro_Chinese_Simplified_x64.iso|5606453248|1B20C6FADEF04DE45934A339AD6A6596|/\r\n\r\nwindows 11 Home China 家庭中文版\r\n\r\n随着windows的发展，越来越多的人都热衷于微软的原版系统下载了，相比之前的版本比如winxp版本，windows vista/win7/win8/win8.1/win10/win11后来的版本在安装方面也比较简单了，所以ghost系统正在渐渐的消失市场，即便如此，很多同学还是找不到微软原版的系统和office下载，所以亦是美网络特意归结了一下微软msdn原版系统和原版office各个版本的下载，希望对正在苦苦找寻原版系统的同学有所帮助。', 182, '2026-01-14 01:58:33', NULL, 1);
INSERT INTO `post` VALUES (32, 4, 1, '图文详解彻底关闭win10、win11系统自带的windows defender杀毒功能', 'Windows Defender，简称WD，是win8、win10、win11系统自带的集成的杀毒软件，既然是杀毒软件，我们就要讨论它的查杀能力，据广大小伙伴反映，WD查杀能力太强大了，不管三七二十一，眉毛胡子一把抓，管你是正常软件还是不正常软件，只要它认定是不正常的，才不管你同意不同意，更不会询问你，统统杀掉，让你猝不及防，乱杀软件也就算了，在系统后台，WD也没有闲着，动不动就给你来个系统扫描，它不会管你是否在玩游戏，硬盘是否能承受得住，它先扫描爽了再说，于是乎，很多小伙伴的电脑硬盘经常出现占用100%的情况，然后系统直接卡顿...那就将它关闭了吧？想要关闭？难！是可忍，孰不可忍，是时候彻底关闭嚣张的WD了！\r\n\r\n首先我们右键win10、win11系统的开始菜单，选择“设置”，或者直接按下Win+i组合键，打开系统“设置”，\r\n\r\n点击“更新和安全”，\r\n\r\n点击左侧的“Windows安全中心”，\r\n\r\n点击“病毒和威胁防护”，\r\n\r\n找到“病毒和威胁防护”设置，点击“管理设置”，如上图所示，\r\n\r\n将右侧的“实时保护”、“云提供保护”、“自动提交样本”、“篡改保护”四项全部手动关掉，如上图所示，\r\n\r\nPS：如果使用的是系统自带的Edge浏览器，还会阻止我们下载，这时，我们打开浏览器，点击右上角的三个点“···”-“设置”，\r\n\r\n在左侧搜索框里输入“smartscreen”，然后在右侧将“Microsoft Defnder Smartscreen”的选项关闭掉即可。', 133, '2025-12-10 01:59:19', NULL, 1);
INSERT INTO `post` VALUES (33, 4, 1, '全面剖析固态硬盘M.2接口与PCI-E SSD固态硬盘的关系', '经常玩硬件的小伙伴们肯定对固态硬盘的M.2接口和PCI-E SSD有所了解，但很多小伙伴都有一个疑问，那就是为什么我的固态硬盘是PCI-E接口，经过跑分测试速度却与SATA 3.0接口的固态硬盘速度差不多？到底是购买的产品质量有问题，还是搭配的平台环境有问题？还是我们对固态硬盘的接口概念一知半解？今天亦是美网络小编就给大家讲讲固态硬盘M.2接口与PCI-E SSD的关系。\r\n\r\n首先，我们来了解一下什么是固态硬盘M.2接口，M.2接口是英特尔公司推出的一种替代MSATA接口的新接口规范标准，也就是我们以前经常提到的NGFF接口，并且M.2接口有两种规格类型：Socket 2和Socket 3，其中Socket 2类型支持SATA和PCI-E 2.0双通道接口，最大读取速度为700M/S，最大写入速度550M/S；Socket 3接口则支持PCI-E 3.0四通道接口，理论速度可以达到4GB/S。\r\n\r\n其次，那什么是PCI-E固态硬盘呢？PCI-E固态硬盘就是总线采用PCI-E来实现传输的固态硬盘，PCI-E也是英特尔公司提出的最新的总线标准，PCI-E总线采用点对点串行连接的设备连接方式，每个设备都有自己的专用连接，可以把数据传输率提高到一个很高的频率10GB/S，固态硬盘的PCI-E接口是一种表现形式，可能是PCI-E传统接口，以显卡接口的形式出现，也可能以M.2接口的形式出现，关键在于固态硬盘的PCI-E原生/桥接主控，这决定它是否能走PCI-E总线。\r\n\r\n第三，PCI-E固态硬盘与M.2接口有什么关系呢？大家都知道M.2接口提供PCI-E总线通道，同样的有的采用PCI-E总线的固态硬盘也可能以M.2接口形式出现，但是要注意，不同的主板提供的M.2接口所支持的通道也是不一样的，有的主板仅支持PCI-E和SATA通道中的一种，有的主板则同时兼容这两种通道，后者的主板既可以支持PCI-E通道的固态硬盘，也可以支持SATA 3.0通道的固态硬盘。总结：有M.2接口的主板不一定支持PCI-E固态硬盘。\r\n\r\n第四，为什么PCI-E接口的固态硬盘达不到官方标称的速度？上面已经讲到，并不是所有的PCI-E固态硬盘都采用M.2主板接口，同样的并不是所有支持M.2主板接口的固态硬盘都是PCI-E总线固态硬盘，是不是有点绕？绕就对 了，这些概念需要反复揣摩去理解才行，只有当固态硬盘的主控是PCI-E控制器时，它才是真正的PCI-E固态硬盘，另外，即使是真正的PCI-E固态硬盘，如果安装到了仅支持SATA总线的M.2接口的主板上，PCI-E接口的固态硬盘也不能完全发挥性能，其只能达到SATA 3.0固态硬盘的表现，只有当采用PCI-E总线的固态硬盘安装到了支持PCI-E总线的M.2接口的主板上，PCI-E固态硬盘才能发挥其最大性能。', 167, '2025-12-10 02:00:05', NULL, 1);
INSERT INTO `post` VALUES (34, 4, 1, '系统安装教程大汇总：win系统版本下载 + 系统安装/重装/升级/封装教程', '本文关于系统下载、重装、激活的文章很多，很多同学反映教程简单易懂并且很适合新手学习，但也有很多同学反映虽然关于系统方面的介绍有很多，但是篇幅比较混乱，不够系统，要是能整合到一起就好了，虽然笔者之前给大家整理过一次，但还是不够详尽，今天刚好有空，亦是美网络小编就把关于win7/win8/win10等系统的下载地址、安装/重装/升级教程、系统封装教程、系统激活方法等再给大家归结一下吧。', 241, '2026-01-05 15:00:30', NULL, 1);
INSERT INTO `post` VALUES (35, 4, 1, '实战绝招分享：半个月变身计算机大神就是这样练成的', '提起“计算机大神”这个词，其实笔者是挺不喜欢的，何谓大神？笔者认为在某一领域有深刻研讨、资历比较深的人可以称之为“大神”。但是在网络用语中，尤其在计算机领域，大神往往不是这个样子的，起码不需要深资历，当然了，能深入研讨是非常难能可贵的，那么计算机大神到底是什么样子呢？如何在短时间内变身计算机大神呢？计算机大神在不同的人群眼里有不同的定义：\r\n\r\n第一阶段、在计算机小白们的眼里：会装系统、会分区、会使用各种软件、了解各种计算机资源的人就是计算机大神。\r\n\r\n第二阶段、在普通计算机使用者眼里：能解决计算机常见问题、软硬件故障的人就是计算机大神。\r\n\r\n第三阶段、在喜欢摆弄、折腾计算机的”骚年“眼里：不仅会以上两种技能，还对计算机有深入了解和操作的人就是计算机大神。\r\n\r\n第四阶段、让许多人都望尘莫及的：各种高级职称的软件开发工程师、系统架构师、云计算设计师、大数据工程师等。', 144, '2025-12-11 11:01:05', NULL, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of remark
-- ----------------------------
INSERT INTO `remark` VALUES (1, 5, '好', 2, 6, 5);
INSERT INTO `remark` VALUES (2, 5, '好', 3, 1, 10);
INSERT INTO `remark` VALUES (3, 5, '123123', 4, 1, 10);
INSERT INTO `remark` VALUES (4, 5, '1231231', 4, 1, 10);
INSERT INTO `remark` VALUES (5, 3, '勉勉强强', 17, 2, 4);
INSERT INTO `remark` VALUES (6, 5, '非常好', 25, 10, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of task
-- ----------------------------
INSERT INTO `task` VALUES (2, 5, 6, 1, 0, '2025-12-15 19:09:54', '2025-12-15 19:10:29', '2025-12-15 19:11:54', '123', '123', 2, NULL);
INSERT INTO `task` VALUES (3, 10, 1, 1, 0, '2025-12-15 19:32:48', '2025-12-15 19:33:02', '2025-12-15 19:33:14', '求助', '巴巴博一', 2, NULL);
INSERT INTO `task` VALUES (4, 10, 1, 1, 0, '2025-12-16 10:55:20', '2025-12-16 10:56:27', '2025-12-16 10:57:08', '123', '123', 2, NULL);
INSERT INTO `task` VALUES (6, 10, 2, 1, 0, '2025-12-17 21:26:58', '2026-01-01 01:47:21', NULL, '电脑进不去Bios怎么办', '这好像是个常见问题，但我找不到其他人有同样的症状。这基本上是从我清理内存条开始的；我把它取出来，除尘，然后放回同一个DIMM插槽。清理的时候，我注意到它的额定速度和运行速度不一样，这才意识到我肯定从来没在BIOS里启用XMP。', 1, NULL);
INSERT INTO `task` VALUES (7, 1, NULL, 1, 15, '2025-12-16 13:29:30', NULL, NULL, '谁能教我笔记本清下灰', '笔记本用了快3年,最近一直发热,应该是需要清灰了,但是我不懂这些也不敢自己操作', 0, '');
INSERT INTO `task` VALUES (17, 4, 2, 1, 0, '2025-12-22 07:52:16', '2025-12-22 08:39:08', '2025-12-22 09:03:07', '买了 M2 硬盘但不敢自己安装，求大佬帮忙', '最近想给笔记本升级一下存储空间，趁着双十一入手了一块三星 980 Pro 1TB M.2 NVMe 固态硬盘。今天收到货后兴致勃勃地拆开后盖，结果看到里面密密麻麻的主板和排线，瞬间怂了...怕自己手残把笔记本搞坏了。\n所以想在这里求助一下：\n\n有没有懂电脑的大佬愿意帮忙安装？​ 我在海淀区中关村附近，可以请吃饭或者支付合理的辛苦费\n或者求推荐中关村附近靠谱的电脑维修店？​ 希望是技术好、不乱收费的那种\n\n    如果有详细的安装教程也求分享！​ 实在找不到人的话，我也可以硬着头皮自己试试\n\n我的笔记本信息：\n\n型号：联想小新 Pro 14 2021款\n现有硬盘：512GB 固态\n新硬盘：三星 980 Pro 1TB M.2 NVMe\n', 2, '/profile/common/202512/8b41355a-6728-4afc-843f-33f464627a7e.jpg,/profile/common/202512/76d00e90-21d2-4da8-83ef-06a0aea8d41d.jpg');
INSERT INTO `task` VALUES (19, 10, NULL, 1, 15, '2026-03-11 18:50:48', NULL, NULL, '求助,电脑卡顿', '大家好，最近电脑出了点问题，想在这个 IT 互助平台求助一下。我的笔记本最近总是莫名卡顿，开机很慢，打开软件经常无响应，有时候还会自动蓝屏重启。\n我自己不太懂电脑，不敢乱删文件，也不知道是系统问题还是硬件故障。\n马上要赶作业和论文，电脑这样特别影响使用。\n想问问有没有懂电脑的同学可以帮忙看看，教教我怎么简单排查一下问题，或者推荐一下靠谱的修复方法。\n如果能远程帮忙看下就更好了，非常感谢大家！', 0, '');
INSERT INTO `task` VALUES (21, 12, NULL, 1, 10, '2026-03-07 18:01:03', NULL, NULL, 'word文档报错怎么办', '求帮忙！Word 文档突然打不开了，一打开就报错，里面是我写了好久的课程论文，现在完全打不开，也不敢乱操作。\n有没有同学懂修复文档的，救救孩子呜呜呜！', 0, '');
INSERT INTO `task` VALUES (22, 15, 1, 1, 15, '2026-03-09 10:54:39', '2026-03-11 19:24:06', NULL, '谁能教我PPT插入视频', '求助！PPT 插入视频后播放不了，只有声音没有画面，换了好几种格式还是不行，明天就要课堂展示了，现在卡在这里，有没有会弄的同学指点一下？', 1, '/profile/common/202603/8a162901-6cbc-445c-87b9-4b7a9260aecb.png');
INSERT INTO `task` VALUES (23, 17, NULL, 1, 20, '2026-03-09 17:57:54', NULL, NULL, '求助清理C盘', '电脑 C 盘爆红，内存不足，我也没装什么软件，不知道为什么占满了。\n不敢乱删文件怕删错系统，求懂电脑的同学帮忙清理一下，万分感谢！', 0, '/profile/common/202604/ab877cc4-c855-42c5-8fc1-5c29ac9bcdd6.png');
INSERT INTO `task` VALUES (24, 18, NULL, 1, 10, '2026-04-06 19:00:36', NULL, NULL, '笔记本充电慢有什么办法吗', '求助！笔记本充电特别慢，有时候还充不进去，充电器和接口都检查过了，不知道是电池坏了还是设置问题。上课经常没电，太影响使用了，求大佬帮忙看看！', 0, '/profile/common/202604/cf74f43b-c15c-4304-b2ff-cea8fe4a2423.png');
INSERT INTO `task` VALUES (25, 1, 10, 1, 15, '2026-03-11 19:06:37', '2026-03-11 19:07:49', '2026-03-11 19:25:27', '求助,笔记本卡顿', '笔记本最近运行特别卡顿，开机要好几分钟，打开浏览器、Word 这些常用软件都要等很久，多开几个页面就容易卡死。我试过用杀毒软件扫描、清理垃圾，但效果都不明显。\n因为平时要写作业、查资料、上网课，电脑这样严重影响学习效率。我对电脑系统和硬件都不太了解，不敢随便重装系统或删除文件，担心把重要资料弄丢。想问问有没有懂 IT 的同学可以帮忙看看，分析一下是配置太低、系统垃圾太多，还是启动项过多的问题。如果能告诉我一些简单安全的优化方法，或者指导我一步步操作，我真的非常感谢！', 2, '/profile/common/202603/70895d31-c780-4966-8e65-1f9846ebe73f.png');
INSERT INTO `task` VALUES (26, 2, NULL, 1, 15, '2026-04-05 23:50:10', NULL, NULL, '求助，笔记本打字卡顿', '笔记本最近打字特别卡顿，敲完键盘要等半秒才出字，打开文档、聊天软件都反应迟钝，多开几个窗口就更卡。我试过清理垃圾、关闭后台，但效果不明显。平时要写作业、记笔记、上网课，打字延迟特别影响效率。我对电脑不太懂，不敢乱删文件或重装系统，怕弄丢资料。想问问有没有懂电脑的同学帮忙分析一下，是内存不够、系统问题还是驱动问题？如果有简单安全的解决办法，一步步教我就太感谢了。', 0, '');
INSERT INTO `task` VALUES (27, 5, NULL, 1, 10, '2026-04-07 23:51:20', NULL, NULL, '笔记本连不上 WiFi怎么办', '笔记本最近经常连不上 WiFi，要么搜不到信号，要么连上就掉线，网课和查资料都受影响。我试过重启路由器、忘记网络重连，但还是不稳定。我对网络设置不太懂，不敢乱改 IP 和 DNS，怕越改越乱。想问问有没有懂 IT 的同学帮忙看看，是网卡问题、驱动问题还是路由器问题？能告诉我一些简单安全的排查方法就真的非常感谢。', 0, '/profile/common/202604/b216c9b2-8b5d-4052-af61-7623ce7a275e.png');
INSERT INTO `task` VALUES (28, 10, NULL, 1, 10, '2026-04-07 23:51:58', NULL, NULL, '电脑风扇狂转还发烫', '笔记本最近一用就发烫，风扇一直狂转噪音很大，稍微开几个软件就开始卡顿降频。我试过清理后台、垫高电脑，但温度还是下不来。平时要写论文、上网课，电脑发烫特别影响使用。我不懂拆机清灰，也不敢乱拆，怕弄坏硬件。想问问懂电脑的同学分析一下原因，有没有简单安全的降温方法可以一步步操作。', 0, '');
INSERT INTO `task` VALUES (29, 1, 11, 1, 15, '2026-04-09 23:53:59', '2026-04-09 23:57:45', NULL, '求助，电脑开机黑屏没反应', '笔记本最近经常开机黑屏，按电源键只有风扇转，屏幕不亮，有时候要重启好几次才能进系统。我试过拔电源重启，但问题还是反复出现。我对硬件故障完全不懂，不敢拆机检查，也怕资料丢失。想问问懂 IT 的同学帮忙看看可能是什么问题，有没有简单安全的排查步骤，真的很影响学习使用。', 1, '');

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
INSERT INTO `user` VALUES (1, '20250101', 'e10adc3949ba59abbe56e057f20f883e', '18999999991', 1, 1, 1, 1, '白露为霜', '/profile/avatar/202603/7fb97f67-5974-48d3-a37b-9805ab7e31b2.jpg', '巴巴博一', 'ming@qh.edu.com', '2025-12-15 18:27:27', 0, 99);
INSERT INTO `user` VALUES (2, '20250102', 'e10adc3949ba59abbe56e057f20f883e', '18999999992', 1, 1, 3, 1, '氓の蚩', '/profile/avatar/202512/83d03f2b-adb9-4a7c-9658-968a1d57e19e.jpg', '不见复关，泣涕涟涟.', 'leivmox@gmail.com', '2025-12-15 18:27:48', 0, 52);
INSERT INTO `user` VALUES (3, '20250103', 'e10adc3949ba59abbe56e057f20f883e', '18999999993', 1, 2, 2, 0, '不吃香菜', '/profile/avatar/202603/5930451e-9b63-48cb-af5d-f2b85a3f27a7.jpg', '热爱编程，热爱生活', '', '2025-12-15 18:28:01', 0, 99);
INSERT INTO `user` VALUES (4, '20250104', 'e10adc3949ba59abbe56e057f20f883e', '18999999994', 1, 2, 2, 1, '龙龙打go', '/profile/avatar/202512/4ad9f7ea-2ad6-44b2-be42-c24b08733165.png', '梦', NULL, '2025-12-15 18:28:11', 0, 69);
INSERT INTO `user` VALUES (5, '20250105', 'e10adc3949ba59abbe56e057f20f883e', '18999999995', 1, 2, 2, 0, '巴巴博一', '/profile/avatar/202603/61de63b2-fd2a-4c88-951f-50e57128ca97.jpg', '代码改变世界，技术成就梦想', NULL, '2025-12-15 18:35:15', 0, 89);
INSERT INTO `user` VALUES (6, '20250106', 'e10adc3949ba59abbe56e057f20f883e', '18999999996', 1, 1, 3, 1, '番茄炒蛋', '/profile/avatar/202603/ca4bf858-d8e6-4bf3-bd0e-359c0e5fa81a.jpg', '努力成为全栈工程师', NULL, '2025-12-15 18:36:29', 0, 99);
INSERT INTO `user` VALUES (10, '20250110', 'e10adc3949ba59abbe56e057f20f883e', '18999933333', 1, 1, 3, 0, '张伟1', '/profile/avatar/202603/ad01db59-4a41-49a1-8fed-b6aaf7bd0ba5.png', '每天进步一点点', NULL, '2025-12-15 19:32:18', 0, 30);
INSERT INTO `user` VALUES (11, '000003', 'e10adc3949ba59abbe56e057f20f883e', '13800000001', 1, 2, 2, 1, '林小雨', '/profile/avatar/202603/a49e97b1-bbcb-44ac-857e-cbcac0b66334.jpg', '学习使我快乐', NULL, '2026-01-30 01:30:01', 0, 500);
INSERT INTO `user` VALUES (12, '000004', 'e10adc3949ba59abbe56e057f20f883e', '13800000002', 1, 2, 2, 0, '张明远', '/profile/avatar/202603/7c849210-6aba-4602-99a6-8d4b056fd6cc.jpg', '人生苦短，我用Python', NULL, '2026-01-30 01:31:44', 0, 790);
INSERT INTO `user` VALUES (13, '000005', 'e10adc3949ba59abbe56e057f20f883e', '13800000003', 2, 1, 1, 0, '王子轩', '/profile/avatar/202603/e936d990-7bf5-4b47-87df-c87761d6d99e.jpg', 'Bug修复师，问题终结者', NULL, '2026-01-30 01:31:44', 0, 600);
INSERT INTO `user` VALUES (14, '000006', 'e10adc3949ba59abbe56e057f20f883e', '13800000004', 2, 1, 1, 1, '陈思琪', '/profile/avatar/202603/26f54500-6642-4423-bcaf-086cf7c86150.jpg', '前端小白，努力学习中', NULL, '2026-01-30 01:31:44', 0, 750);
INSERT INTO `user` VALUES (15, '000007', 'e10adc3949ba59abbe56e057f20f883e', '13800000005', 1, 2, 2, 0, '李浩然', '/profile/avatar/202603/60a9dd74-625f-4ee0-bcd5-fc5657716fff.jpg', 'Java是世界上最好的语言', NULL, '2026-01-30 01:31:44', 0, 290);
INSERT INTO `user` VALUES (16, '000008', 'e10adc3949ba59abbe56e057f20f883e', '13800000006', 2, 1, 1, 1, '周雨晴', '/profile/avatar/202603/46377651-2450-4e27-b990-bde75580069a.png', '代码如诗，人生如梦', NULL, '2026-01-30 01:31:44', 0, 450);
INSERT INTO `user` VALUES (17, '200001', 'e10adc3949ba59abbe56e057f20f883e', '13700000001', 1, 1, 1, 0, '陈俊豪', '/profile/avatar/202603/97f559f5-5d4b-4a11-bd74-631a129ac639.jpg', '技术宅，拯救世界', NULL, '2026-01-30 01:39:16', 0, 490);
INSERT INTO `user` VALUES (18, '200002', 'e10adc3949ba59abbe56e057f20f883e', '13700000002', 1, 1, 3, 1, '林晓燕', '/profile/avatar/202603/c9859ac6-4649-4be8-9d87-c5f6a0d71793.jpg', '热爱开源，分享快乐', NULL, '2026-01-30 01:39:54', 0, 590);
INSERT INTO `user` VALUES (19, '200003', 'e10adc3949ba59abbe56e057f20f883e', '13700000003', 1, 2, 2, 0, '黄志伟', '/profile/avatar/202603/b974c412-70a8-432d-b4ad-e443203c515d.jpg', '全栈开发，终身学习', NULL, '2026-01-30 01:39:57', 0, 450);
INSERT INTO `user` VALUES (20, '200004', 'e10adc3949ba59abbe56e057f20f883e', '13700000004', 1, 1, 4, 1, '杨思敏', '/profile/avatar/202603/0cb2131e-9860-4534-8f35-b14374486362.jpg', '用代码书写精彩人生', NULL, '2026-01-30 01:40:07', 0, 700);
INSERT INTO `user` VALUES (21, '200005', 'e10adc3949ba59abbe56e057f20f883e', '13700000005', 1, 2, 2, 0, '吴嘉豪', '/profile/avatar/202603/f70c8517-69e5-4327-b68d-7e0dd77ced5e.jpg', '程序员，改变世界的魔法师', NULL, '2026-01-30 01:40:11', 0, 380);
INSERT INTO `user` VALUES (22, '200006', 'e10adc3949ba59abbe56e057f20f883e', '13700000006', 1, 1, 1, 1, '郑雅婷', '/profile/avatar/202603/909d684d-f530-4a5a-b5e0-96bead1e80cf.jpg', '代码改变世界，从你我做起', NULL, '2026-01-30 01:40:16', 0, 520);

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
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_like
-- ----------------------------
INSERT INTO `user_like` VALUES (33, 2, 9, 1, '2025-12-24 02:35:12');
INSERT INTO `user_like` VALUES (49, 2, 11, 1, '2025-12-24 02:52:00');
INSERT INTO `user_like` VALUES (50, 24, 30, 1, '2026-03-11 19:22:02');

SET FOREIGN_KEY_CHECKS = 1;
