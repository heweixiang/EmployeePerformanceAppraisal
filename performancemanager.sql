/*
 Navicat Premium Data Transfer

 Source Server         : 阿里云服务器
 Source Server Type    : MySQL
 Source Server Version : 50733
 Source Host           : 121.196.166.114:4417
 Source Schema         : performancemanager

 Target Server Type    : MySQL
 Target Server Version : 50733
 File Encoding         : 65001

 Date: 17/07/2021 00:55:10
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `id` int(255) NOT NULL AUTO_INCREMENT COMMENT 'user表对应部门,除了admin都有对应部门',
  `departmentname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '部门名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (1, 'ROOT（管理员部门）');
INSERT INTO `department` VALUES (2, 'USER(用户归属给这个部门）');
INSERT INTO `department` VALUES (25, '后勤');
INSERT INTO `department` VALUES (26, '保卫处');
INSERT INTO `department` VALUES (27, 'aaa');
INSERT INTO `department` VALUES (29, '新增部门测试s');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登陆名',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '真实姓名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户密码',
  `departmentid` int(11) NULL DEFAULT NULL COMMENT '部门编号',
  `jurisdiction` int(255) NOT NULL COMMENT '权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结',
  `lastlogintime` datetime(0) NOT NULL COMMENT '上次登陆时间,第一次为注册时间',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱地址',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话,按道理必须有的',
  `salt` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'token',
  `sex` int(255) NOT NULL COMMENT '性别',
  `token` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'token,登陆控制',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 64 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'root', 'isAdmin', '7a6ecff6295aa1342a387056b0010669', 1, 0, '2021-04-05 19:29:19', NULL, '15150712459', 'a2f168f1afaa943dba6d9373d25f41a8', 0, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoiZWZlMWYxMzNmMjhiYzZhNzgzNTQwMWQzMDE2NDlhMTgiLCJleHAiOjE3NTQxNzkwNjB9.JnGvmsKjYnjMsSjaKlxn6qE35YworVI6EvstxzW1QKw');
INSERT INTO `user` VALUES (45, 'hqmanager', '后勤主管', '7a6ecff6295aa1342a387056b0010669', 25, 2, '2021-05-09 08:40:40', NULL, NULL, 'a2f168f1afaa943dba6d9373d25f41a8', 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoiMWIwYzU1YjU1YmNhMDM4ZWNlZTI5MTRlOWNmYzE3ZGMiLCJleHAiOjE3NTMzNjAxNjN9.QgzIwl8cNfde9NCEQOsCh0pYwJwrFJ7PVpJLfT055Nw');
INSERT INTO `user` VALUES (46, 'hquser.', '后勤', '1f51cecd19017e3f7b074b459e14cfa1', 26, 3, '2021-05-09 08:41:41', NULL, NULL, '234a545aa946dbe0fab05b06f087d468', 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoiMTIwMWQzZWRmYTNkNzVmMDY5MzJlYjg3YjA5Mjk5ZDIiLCJleHAiOjE3NTMzNTkyNTF9.U7Z4aXpBI-Jg4xsQ947FnC3vp1StSUvD8Yq4elv_o94');
INSERT INTO `user` VALUES (47, 'hqyg', '后勤员工z', '0d9556a6c3ca8a6ec2c7d33bc9fef440', 26, 3, '2021-05-09 08:46:00', NULL, NULL, '907416951dc58e6f22e187a4a46f0577', 0, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoiNWMwY2QxNmFmY2I5OTU3MjI1NTFmYTk4NjdiODlhZDMiLCJleHAiOjE3NTAxMjEyMjF9._PE_8XbIyshCTBqAW1GfAT5kikxm7mPyp4wc9-oxYZI');
INSERT INTO `user` VALUES (48, 'bwcmanager', '保卫处主管', '43bce480d7d34b7ea9be1b24df715d55', 26, 2, '2021-05-09 12:21:56', NULL, NULL, '814f9ebd150afd6505447e22fd818e5c', 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoiOTI2MTdhYjI3YTQ5MjMxM2VhZTdkZmNmZmI2Mzk0YWEiLCJleHAiOjE3NTMxODA5NDl9.r2NGMvARWp_0MrSTwg_t3cimXIkyXFJ54X-3eTU32MY');
INSERT INTO `user` VALUES (50, 'bwcuser', '保卫处用户', 'cbedfcaaadc33b0aa8b54d3d3714a21b', 26, 1, '2021-05-09 12:23:06', NULL, NULL, '62cdcde300e9e6c3afa527a902e03fc7', 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoiZWUzNzkwM2NkNGMwYmRiZGU4YTVlMDc1YTg0ZGM0ZjciLCJleHAiOjE3NTAxNDAxODZ9.AINPRSyvaLvAVDK1UKeCmZ_8F_NVKJqksiJ9wbCXTdM');
INSERT INTO `user` VALUES (55, 'dafdsaf', 'dsafdsa的', '5080c75ef00b4a8f2c056983a2ff49b9', 1, 1, '2021-06-13 14:47:27', NULL, NULL, 'a2bc57b7c5b00b15f7a9989e0ffc949b', 1, NULL);
INSERT INTO `user` VALUES (56, 'ss', 'ss', 'e054427f4e4569606f1d15f56a88d411', 1, 1, '2021-06-13 15:30:52', NULL, NULL, '56519ca740a02648e2396fd31a787057', 1, NULL);
INSERT INTO `user` VALUES (57, 'testuserx', '测试x', '92b242aa9d101ecb32367e84df1508f4', 1, 1, '2021-06-13 18:05:15', NULL, NULL, '3c01f6456c286998a322e073661e58fc', 1, NULL);
INSERT INTO `user` VALUES (58, 'aaaaada', 'dsafdsf防抖', '74e537a03767e3d630409235ca1fb99c', 26, 3, '2021-06-13 19:12:02', NULL, NULL, '50b608b14254ae4edd3f90b6e26951d8', 0, NULL);
INSERT INTO `user` VALUES (59, 'testuser', '何维想', '0c3f04dde6fbf05d7ae97e8e87eefa40', 1, 1, '2021-06-14 18:35:44', NULL, NULL, '6d05379cc430235485d3501e4d43a97e', 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoiY2ZhZWMxMGM2OTY1ODZlNTdiZjk0NDcxZjVlYjcyZWEiLCJleHAiOjE3NTMzNTk4Njl9.qz23dImjAeMxvT49Je80QzBXj45t5YXB43sgG-p74ow');
INSERT INTO `user` VALUES (63, 'hquser', '后勤测试员工', '6441bd6d24ffef8d91630c710c5bcd07', 25, 3, '2021-06-15 20:05:28', NULL, NULL, '93f4f0d7a9e43b4af48e13b4891b27e5', 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoiMWVmNTcwZjhkYTUwYTMzNTZhYjI5NDcwNWIwYWU3YzAiLCJleHAiOjE3NTMzNjA2Mzd9.MaqNmD2R9qdQa6IMaKrbW0aNV7LKurcrMa13ITHWtBs');

-- ----------------------------
-- Table structure for workorder
-- ----------------------------
DROP TABLE IF EXISTS `workorder`;
CREATE TABLE `workorder`  (
  `id` int(255) NOT NULL AUTO_INCREMENT COMMENT '工单id',
  `uid` int(255) NOT NULL COMMENT '对应用户id必须存在',
  `did` int(255) NOT NULL COMMENT '对应部门ID',
  `eid` int(255) NULL DEFAULT NULL COMMENT '对应用户id,分配后存在可以为空',
  `ctime` datetime(0) NOT NULL COMMENT '工单创建时间',
  `eideatime` datetime(0) NULL DEFAULT NULL COMMENT '员工提交工单时间',
  `intro` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工单简介,标题,必须存在',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工单内容,必须存在',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工单备注',
  `uidea` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户发布意见',
  `midea` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经理签核意见',
  `eidea` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '员工签核意见',
  `urgent` int(255) NOT NULL COMMENT '是否加急,默认为不加急',
  `wstatus` int(255) NOT NULL COMMENT '当前工单状态, 0 用户端保存,1 待经理审核分配,2 员工工作,3 用户评价 ,4 主管评价工单,5 结案',
  `ustart` int(255) NULL DEFAULT NULL COMMENT '用户评价',
  `ucontent` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户评价内容',
  `ustarttime` datetime(0) NULL DEFAULT NULL COMMENT '用户评价时间',
  `mstart` int(255) NULL DEFAULT NULL COMMENT '主管评价',
  `mcontent` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主管评价内容',
  `mstarttime` datetime(0) NULL DEFAULT NULL COMMENT '主管评价时间',
  `averagestart` float(255, 2) NULL DEFAULT NULL COMMENT '平均评价,该表单平均获取评价,方便后续评分',
  `mideatime` datetime(0) NULL DEFAULT NULL COMMENT '主管签核时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of workorder
-- ----------------------------
INSERT INTO `workorder` VALUES (32, 48, 25, 47, '2021-05-09 08:42:38', '2021-05-09 08:47:09', '你们卫生不行', '脏死了', '速度解决', '', '干的什么活，快解决', '好的老大，解决了', 0, 5, 5, '速度不错', '2021-05-09 08:47:43', 5, '下次注意', '2021-05-09 08:48:23', 5.00, '2021-05-09 08:46:22');
INSERT INTO `workorder` VALUES (33, 50, 26, 49, '2021-05-09 12:26:16', '2021-05-09 14:02:38', '保卫处', '开发一个保卫系统', '抓紧完成', '', 'ok', '此项目望您满意', 1, 5, 5, '谢谢', '2021-05-09 14:03:23', 5, '有部分功能仍可以做的更好，再接再厉', '2021-05-09 14:04:25', 5.00, '2021-05-09 14:01:11');
INSERT INTO `workorder` VALUES (34, 51, 27, NULL, '2021-05-09 16:08:12', NULL, '开发一个成绩系统', '简洁美观', '12', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder` VALUES (35, 59, 25, 63, '2021-06-14 20:33:07', '2021-06-15 20:22:28', '该工单不是很着急', '后勤部请cha', '暂无备注', '', '请速度处理', '现已处理完毕', 0, 5, 3, '后勤部请cha', '2021-06-15 20:27:42', 4, '后勤部请cha', '2021-06-15 20:29:44', 3.25, '2021-06-15 20:13:29');
INSERT INTO `workorder` VALUES (36, 59, 25, 63, '2021-06-14 20:58:44', '2021-06-15 20:22:45', '测试工单2 ', '这个后勤工单比较急', '速度解决', '', '加急处理', '该工单现已处理完毕', 1, 5, 5, '这个后勤工单比较急', '2021-06-15 20:27:25', 4, '这个后勤工单比较急', '2021-06-15 20:29:33', 4.50, '2021-06-15 20:13:41');
INSERT INTO `workorder` VALUES (37, 59, 26, NULL, '2021-06-15 20:28:35', NULL, '.0000', '大富大贵双方各第三个', '浮点数国风大赏', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for workorder_copy1
-- ----------------------------
DROP TABLE IF EXISTS `workorder_copy1`;
CREATE TABLE `workorder_copy1`  (
  `id` int(255) NOT NULL AUTO_INCREMENT COMMENT '工单id',
  `uid` int(255) NOT NULL COMMENT '对应用户id必须存在',
  `did` int(255) NOT NULL COMMENT '对应部门ID',
  `eid` int(255) NULL DEFAULT NULL COMMENT '对应用户id,分配后存在可以为空',
  `ctime` datetime(0) NOT NULL COMMENT '工单创建时间',
  `eideatime` datetime(0) NULL DEFAULT NULL COMMENT '员工提交工单时间',
  `intro` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工单简介,标题,必须存在',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工单内容,必须存在',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工单备注',
  `uidea` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户发布意见',
  `midea` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经理签核意见',
  `eidea` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '员工签核意见',
  `urgent` int(255) NOT NULL COMMENT '是否加急,默认为不加急',
  `wstatus` int(255) NOT NULL COMMENT '当前工单状态, 0 用户端保存,1 待经理审核分配,2 员工工作,3 用户评价 ,4 主管评价工单,5 结案',
  `ustart` int(255) NULL DEFAULT NULL COMMENT '用户评价',
  `ucontent` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户评价内容',
  `ustarttime` datetime(0) NULL DEFAULT NULL COMMENT '用户评价时间',
  `mstart` int(255) NULL DEFAULT NULL COMMENT '主管评价',
  `mcontent` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主管评价内容',
  `mstarttime` datetime(0) NULL DEFAULT NULL COMMENT '主管评价时间',
  `averagestart` float(255, 2) NULL DEFAULT NULL COMMENT '平均评价,该表单平均获取评价,方便后续评分',
  `mideatime` datetime(0) NULL DEFAULT NULL COMMENT '主管签核时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of workorder_copy1
-- ----------------------------
INSERT INTO `workorder_copy1` VALUES (3, 19, 16, 21, '2021-05-01 01:44:10', '2021-05-03 13:34:33', '的打发第三方打', '打发的啥范德萨', '大幅度啥', '大师傅大沙发大厦', 'fortest', '我已处理完毕请评价', 0, 5, 4, '挺好的就是收费有点贵', '2021-05-02 17:34:18', 5, '工作完成度很好但是还需要努力', '2021-05-03 17:34:00', 4.50, '2021-05-03 13:08:40');
INSERT INTO `workorder_copy1` VALUES (4, 19, 16, 21, '2021-05-03 22:37:42', '2021-05-03 23:12:12', '这是一个测试工单', '这是一个加急的测试工单', '我比较急', '', '你来处理这件事', '我处理完了', 1, 5, 5, '处理的不错', '2021-05-03 23:12:47', 5, '有待提升', '2021-05-03 23:13:25', 5.00, '2021-05-03 23:11:20');
INSERT INTO `workorder_copy1` VALUES (5, 19, 16, 24, '2021-05-04 18:05:27', '2021-05-04 18:51:25', '我是一个bate工单', '我比较急', '请部门2速度解决', '', '对对对', '我已处理完毕', 1, 5, 5, '完成度很好', '2021-05-04 18:52:16', 5, '打发', '2021-05-04 18:53:10', 5.00, '2021-05-04 18:45:17');
INSERT INTO `workorder_copy1` VALUES (6, 19, 16, NULL, '2021-05-04 18:15:05', NULL, '普通单子测试', '我是测试工单内容', 'test', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (7, 19, 16, NULL, '2021-05-04 18:19:56', NULL, '添加工单弹窗关闭测试', 'test', 'test', '', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (8, 19, 16, 21, '2021-05-04 18:20:09', '2021-05-04 18:51:37', '添加工单弹窗关闭测试', 'test', 'test', '', '大幅度发', '我已搞定', 1, 5, 5, '你是个好人', '2021-05-04 18:52:37', 5, '打发的啥啊', '2021-05-04 18:53:23', 5.00, '2021-05-04 18:50:32');
INSERT INTO `workorder_copy1` VALUES (9, 19, 16, NULL, '2021-05-04 18:20:56', NULL, '添加工单弹窗关闭测试', 'test', 'test', '', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (10, 19, 16, NULL, '2021-05-04 18:24:26', NULL, 'test', '人她说她', 'test', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (11, 19, 16, 21, '2021-05-04 18:24:30', '2021-05-08 00:14:57', 'test', '人她说她', 'test', '', '地方三房', 'aaaa', 0, 4, 5, 'dadsaf', '2021-05-08 00:15:29', NULL, NULL, NULL, NULL, '2021-05-04 18:50:41');
INSERT INTO `workorder_copy1` VALUES (12, 19, 16, NULL, '2021-05-04 18:24:32', NULL, 'test', '人她说她', 'test', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (13, 19, 16, NULL, '2021-05-04 18:25:17', NULL, '大厦范德萨', '大厦范德萨啊', '第三方的啊', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (14, 19, 16, NULL, '2021-05-04 18:25:19', NULL, '大厦范德萨', '大厦范德萨啊', '第三方的啊', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (15, 19, 18, NULL, '2021-05-04 18:36:01', NULL, '添加', 'test', 'test', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (16, 19, 18, 23, '2021-05-04 18:37:08', NULL, '对对对', '第三方', '打发', '', 's', NULL, 0, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-05-08 00:14:28');
INSERT INTO `workorder_copy1` VALUES (17, 19, 17, NULL, '2021-05-04 18:37:54', NULL, '打发打发', '打发打', '打', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (18, 19, 19, NULL, '2021-05-04 18:39:54', NULL, '都是', '33332', '23', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (19, 19, 18, NULL, '2021-05-04 18:40:41', NULL, '4444', '44444', '444', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (20, 19, 18, NULL, '2021-05-04 18:41:24', NULL, '2222', '222222', '22222', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (21, 19, 16, NULL, '2021-05-04 18:53:58', NULL, '大幅度', '打发', '打', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (22, 24, 16, NULL, '2021-05-06 21:07:35', NULL, 'testadduser', 'dafdsafdsaf', 'dafdsafdsaf', '', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (23, 19, 16, NULL, '2021-05-08 00:13:42', NULL, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'aaaaaaaaaaaaaaa', 'aaaaaaaaaaaaaaaaa', '', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (24, 32, 1, 31, '2021-05-08 17:19:21', '2021-05-08 18:22:18', '开发一款益智类游戏', '希望赶紧的完成', '加油啊！', '', '0000', '1', 1, 5, 5, 'bc', '2021-05-08 18:23:06', 5, '不错', '2021-05-08 18:24:00', 5.00, '2021-05-08 18:18:43');
INSERT INTO `workorder_copy1` VALUES (25, 32, 1, 28, '2021-05-08 18:14:26', NULL, '1111', '1010101', 'jy', '', '000', NULL, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-05-08 18:18:57');
INSERT INTO `workorder_copy1` VALUES (26, 35, 1, NULL, '2021-05-08 18:41:04', NULL, '0909090', '11111111111', '11111', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `workorder_copy1` VALUES (27, 35, 22, 36, '2021-05-08 18:43:04', '2021-05-08 18:48:49', 'oooo', 'ooooo', 'oooo', '', '123213132', 'pppp', 0, 5, 3, '不错', '2021-05-08 18:49:31', 5, '继续加油', '2021-05-08 18:50:39', 4.00, '2021-05-08 18:47:21');
INSERT INTO `workorder_copy1` VALUES (28, 37, 23, 39, '2021-05-08 20:19:55', '2021-05-08 20:25:03', '开发学生管理系统', '学生成绩管理系统', '希望加快开发的速度', '', '加快开发', '希望满意', 1, 5, 4, '还算满意', '2021-05-08 20:25:56', 5, '继续努力', '2021-05-08 20:27:06', 4.50, '2021-05-08 20:24:15');
INSERT INTO `workorder_copy1` VALUES (29, 40, 24, 42, '2021-05-08 21:22:08', '2021-05-08 21:30:04', '绩效考核系统', '希望增删改查', '加急，或者可以说希望有一个满意的结果', '', '加油！希望可以速度完工1111111111111111111', '已完成，望满意！', 1, 5, 5, 'hhh', '2021-05-08 21:30:41', 5, '望再接再厉，加油！', '2021-05-08 21:31:22', 5.00, '2021-05-08 21:27:47');
INSERT INTO `workorder_copy1` VALUES (30, 19, 16, 27, '2021-05-09 00:59:39', NULL, '我是一条测试工单啊啊啊啊啊啊啊啊啊啊啊啊啊', '啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊', '啊啊啊啊啊啊啊啊啊啊啊', '', '的点点滴滴', NULL, 0, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-05-09 01:12:40');
INSERT INTO `workorder_copy1` VALUES (31, 44, 17, NULL, '2021-05-09 01:35:17', NULL, 'sdfda as', 'dasfdsafdsa', 'dsafdsaf', '', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- View structure for userlist
-- ----------------------------
DROP VIEW IF EXISTS `userlist`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `userlist` AS select `user`.`id` AS `id`,`user`.`username` AS `username`,`user`.`name` AS `name`,`user`.`departmentid` AS `departmentid`,(select `department`.`departmentname` from `department` where (`department`.`id` = `user`.`departmentid`)) AS `departmentname`,`user`.`jurisdiction` AS `jurisdiction`,`user`.`lastlogintime` AS `lastlogintime`,`user`.`email` AS `email`,`user`.`phone` AS `phone` from `user`;

-- ----------------------------
-- View structure for workorderlist
-- ----------------------------
DROP VIEW IF EXISTS `workorderlist`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `workorderlist` AS select `workorder`.`id` AS `id`,`workorder`.`intro` AS `intro`,`workorder`.`wstatus` AS `wstatus`,`workorder`.`uid` AS `uid`,(select `user`.`name` from `user` where (`user`.`id` = `workorder`.`uid`)) AS `uname`,`workorder`.`eid` AS `eid`,(select `user`.`name` from `user` where (`user`.`id` = `workorder`.`eid`)) AS `ename`,`workorder`.`did` AS `did`,(select `department`.`departmentname` from `department` where (`department`.`id` = `workorder`.`did`)) AS `dname`,`workorder`.`ctime` AS `ctime`,`workorder`.`urgent` AS `urgent` from `workorder`;

SET FOREIGN_KEY_CHECKS = 1;
