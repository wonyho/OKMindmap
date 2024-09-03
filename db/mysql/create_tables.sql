/*
SQLyog Community v11.31 (64 bit)
MySQL - 5.6.16 : Database - okmindmap
*********************************************************************
*/

/*Table structure for table `mm_arrowlink` */

DROP TABLE IF EXISTS `mm_arrowlink`;

CREATE TABLE `mm_arrowlink` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) unsigned NOT NULL,
  `color` varchar(10) DEFAULT NULL,
  `destination` varchar(50) DEFAULT NULL,
  `endarrow` varchar(20) DEFAULT NULL,
  `endinclination` varchar(20) DEFAULT NULL,
  `identity` varchar(50) DEFAULT NULL,
  `startarrow` varchar(20) DEFAULT NULL,
  `startinclination` varchar(20) DEFAULT NULL,
  `map_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `mm_attribute` */

DROP TABLE IF EXISTS `mm_attribute`;

CREATE TABLE `mm_attribute` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` text COLLATE utf8_unicode_ci,
  `map_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_attribute_registry` */

DROP TABLE IF EXISTS `mm_attribute_registry`;

CREATE TABLE `mm_attribute_registry` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `map_revision_id` bigint(20) unsigned NOT NULL,
  `show_attributes` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_board` */

DROP TABLE IF EXISTS `mm_board`;

CREATE TABLE `mm_board` (
  `boardId` int(11) NOT NULL AUTO_INCREMENT,
  `boardType` int(11) DEFAULT NULL,
  `title` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recom` int(11) DEFAULT NULL,
  `visited` int(11) DEFAULT NULL,
  `insertdate` datetime DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `userid` int(11) DEFAULT NULL,
  `username2` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userpassword` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userip` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lang` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`boardId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_board_memo` */

DROP TABLE IF EXISTS `mm_board_memo`;

CREATE TABLE `mm_board_memo` (
  `memoId` int(11) NOT NULL AUTO_INCREMENT,
  `boardId` int(11) DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `insertdate` datetime DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `username2` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userpassword` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userip` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`memoId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_categories` */

DROP TABLE IF EXISTS `mm_categories`;

CREATE TABLE `mm_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
  `lft` int(10) unsigned DEFAULT NULL,
  `rgt` int(10) unsigned DEFAULT NULL,
  `parentid` bigint(20) unsigned DEFAULT NULL,
  `depth` bigint(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `parentid` (`parentid`),
  KEY `lft` (`lft`),
  KEY `rgt` (`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_categories_view` */

DROP TABLE IF EXISTS `mm_categories_view`;

CREATE VIEW mm_categories_view AS
SELECT c.id AS id
     , c.name AS NAME
     , c.lft AS lft
     , c.rgt AS rgt
     , c.parentid AS parentid
     , c.depth AS depth
     , ((c.rgt - c.lft) = 1) AS is_leaf
FROM mm_categories c;

/*Table structure for table `mm_chatting` */

DROP TABLE IF EXISTS `mm_chatting`;

CREATE TABLE `mm_chatting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `roomnumber` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `timecreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_cloud` */

DROP TABLE IF EXISTS `mm_cloud`;

CREATE TABLE `mm_cloud` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) unsigned NOT NULL,
  `color` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `map_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_edge` */

DROP TABLE IF EXISTS `mm_edge`;

CREATE TABLE `mm_edge` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) unsigned NOT NULL,
  `color` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `style` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `map_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_facebook_login` */

DROP TABLE IF EXISTS `mm_facebook_login`;

CREATE TABLE `mm_facebook_login` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) unsigned NOT NULL,
  `access_token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `lastlogin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_font` */

DROP TABLE IF EXISTS `mm_font`;

CREATE TABLE `mm_font` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) unsigned NOT NULL,
  `bold` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `italic` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `map_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_foreignobject` */

DROP TABLE IF EXISTS `mm_foreignobject`;

CREATE TABLE `mm_foreignobject` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) unsigned NOT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `width` bigint(20) unsigned DEFAULT '0',
  `height` bigint(20) unsigned DEFAULT '0',
  `map_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_group` */

DROP TABLE IF EXISTS `mm_group`;

CREATE TABLE `mm_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `summary` text COLLATE utf8_unicode_ci,
  `userid` bigint(20) unsigned NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `policy` bigint(20) unsigned NOT NULL,
  `categoryid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `categoryid` (`categoryid`),
  KEY `policy` (`policy`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_group_member` */

DROP TABLE IF EXISTS `mm_group_member`;

CREATE TABLE `mm_group_member` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `groupid` bigint(20) unsigned NOT NULL,
  `userid` bigint(20) unsigned NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` bigint(20) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `groupid` (`groupid`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_group_member_status_type` */

DROP TABLE IF EXISTS `mm_group_member_status_type`;

CREATE TABLE `mm_group_member_status_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `shortname` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_group_password` */

DROP TABLE IF EXISTS `mm_group_password`;

CREATE TABLE `mm_group_password` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `groupid` bigint(20) unsigned NOT NULL,
  `password` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `groupid` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_group_policy_type` */

DROP TABLE IF EXISTS `mm_group_policy_type`;

CREATE TABLE `mm_group_policy_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `shortname` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_hook` */

DROP TABLE IF EXISTS `mm_hook`;

CREATE TABLE `mm_hook` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `map_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_icon` */

DROP TABLE IF EXISTS `mm_icon`;

CREATE TABLE `mm_icon` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) unsigned NOT NULL,
  `builtin` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `map_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_map` */

DROP TABLE IF EXISTS `mm_map`;

CREATE TABLE `mm_map` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
  `version` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `created` bigint(15) unsigned NOT NULL DEFAULT '0',
  `map_key` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `viewcount` int(11) DEFAULT '0',
  `map_style` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lazyloading` tinyint(1) NOT NULL DEFAULT '0',
  `pt_sequence` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `queueing` tinyint(1) NOT NULL DEFAULT '0',
  `short_url` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recommend_point` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `map_key` (`map_key`),
  KEY `created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_map_owner` */

DROP TABLE IF EXISTS `mm_map_owner`;

CREATE TABLE `mm_map_owner` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mapid` bigint(20) unsigned NOT NULL,
  `userid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mapid` (`mapid`,`userid`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_map_owner_info` */

DROP TABLE IF EXISTS `mm_map_owner_info`;

CREATE TABLE `mm_map_owner_info` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mapid` bigint(20) unsigned NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mapidindex` (`mapid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_map_timeline` */

DROP TABLE IF EXISTS `mm_map_timeline`;

CREATE TABLE `mm_map_timeline` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `map_id` bigint(20) unsigned NOT NULL,
  `xml` longblob NOT NULL,
  `saved` bigint(15) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `map_id` (`map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_mapofmap` */

DROP TABLE IF EXISTS `mm_mapofmap`;

CREATE TABLE `mm_mapofmap` (
  `user_id` int(11) NOT NULL,
  `map_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_node` */

DROP TABLE IF EXISTS `mm_node`;

CREATE TABLE `mm_node` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `map_id` bigint(20) unsigned NOT NULL,
  `background_color` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `folded` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `identity` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `note` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `style` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `text` text COLLATE utf8_unicode_ci,
  `created` bigint(15) unsigned NOT NULL DEFAULT '0',
  `creator` bigint(20) unsigned NOT NULL,
  `creator_ip` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `modified` bigint(15) unsigned NOT NULL DEFAULT '0',
  `modifier` bigint(20) unsigned NOT NULL,
  `modifier_ip` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hgap` int(11) DEFAULT NULL,
  `vgap` int(11) DEFAULT NULL,
  `vshift` int(11) DEFAULT NULL,
  `encrypted_content` text COLLATE utf8_unicode_ci,
  `extra_data` text COLLATE utf8_unicode_ci,
  `node_type` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lft` int(10) unsigned DEFAULT NULL,
  `rgt` int(10) unsigned DEFAULT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `client_id` varchar(40) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `map_id` (`map_id`),
  KEY `parent_id` (`parent_id`),
  KEY `identity` (`identity`),
  KEY `created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_okm_notice` */

DROP TABLE IF EXISTS `mm_okm_notice`;

CREATE TABLE `mm_okm_notice` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `content_ko` text COLLATE utf8_unicode_ci,
  `content_en` text COLLATE utf8_unicode_ci,
  `link_ko` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_en` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` int(10) DEFAULT '5',
  `created` bigint(15) unsigned DEFAULT NULL,
  `hide` tinyint(1) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_okm_setting` */

DROP TABLE IF EXISTS `mm_okm_setting`;

CREATE TABLE `mm_okm_setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `setting_value` TEXT COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_parameters` */

DROP TABLE IF EXISTS `mm_parameters`;

CREATE TABLE `mm_parameters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `hook_id` bigint(20) unsigned NOT NULL,
  `reminduserat` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hook_id` (`hook_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_persistent_login` */

DROP TABLE IF EXISTS `mm_persistent_login`;

CREATE TABLE `mm_persistent_login` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) unsigned NOT NULL,
  `persistent_key` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `lastlogin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_presentation_slide` */

DROP TABLE IF EXISTS `mm_presentation_slide`;

CREATE TABLE `mm_presentation_slide` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) NOT NULL,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `scalex` double DEFAULT NULL,
  `scaley` double DEFAULT NULL,
  `rotate` double DEFAULT NULL,
  `showdepths` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_queuedata` */

DROP TABLE IF EXISTS `mm_queuedata`;

CREATE TABLE `mm_queuedata` (
  `roomnumber` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `textdata` text COLLATE utf8_unicode_ci,
  `created` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_repository` */

DROP TABLE IF EXISTS `mm_repository`;

CREATE TABLE `mm_repository` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mapid` bigint(20) unsigned NOT NULL,
  `userid` bigint(20) unsigned NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mime` longblob,
  `filesize` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_richcontent` */

DROP TABLE IF EXISTS `mm_richcontent`;

CREATE TABLE `mm_richcontent` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `node_id` bigint(20) unsigned NOT NULL,
  `type` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `map_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_role` */

DROP TABLE IF EXISTS `mm_role`;

CREATE TABLE `mm_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `shortname` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_role_assignments` */

DROP TABLE IF EXISTS `mm_role_assignments`;

CREATE TABLE `mm_role_assignments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `roleid` bigint(20) unsigned NOT NULL,
  `userid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `roleid` (`roleid`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_role_capabilities` */

DROP TABLE IF EXISTS `mm_role_capabilities`;

CREATE TABLE `mm_role_capabilities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `roleid` bigint(20) unsigned NOT NULL,
  `capability` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `permission` bigint(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `roleid` (`roleid`,`capability`,`permission`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_share` */

DROP TABLE IF EXISTS `mm_share`;

CREATE TABLE `mm_share` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mapid` bigint(20) unsigned NOT NULL,
  `sharetype` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mapid` (`mapid`,`sharetype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_share_group` */

DROP TABLE IF EXISTS `mm_share_group`;

CREATE TABLE `mm_share_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shareid` bigint(20) unsigned NOT NULL,
  `groupid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `shareid` (`shareid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_share_password` */

DROP TABLE IF EXISTS `mm_share_password`;

CREATE TABLE `mm_share_password` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shareid` bigint(20) unsigned NOT NULL,
  `password` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shareid` (`shareid`,`password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_share_permission` */

DROP TABLE IF EXISTS `mm_share_permission`;

CREATE TABLE `mm_share_permission` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shareid` bigint(20) unsigned NOT NULL,
  `permissiontype` bigint(20) unsigned NOT NULL,
  `permited` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_share_permission_type` */

DROP TABLE IF EXISTS `mm_share_permission_type`;

CREATE TABLE `mm_share_permission_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `shortname` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `sortorder` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_share_type` */

DROP TABLE IF EXISTS `mm_share_type`;

CREATE TABLE `mm_share_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `shortname` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_user` */

DROP TABLE IF EXISTS `mm_user`;

CREATE TABLE `mm_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `firstname` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `lastname` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `auth` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'manual',
  `confirmed` tinyint(1) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created` int(15) unsigned NOT NULL DEFAULT '0',
  `last_access` int(15) unsigned NOT NULL DEFAULT '0',
  `last_map` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_user_config_data` */

DROP TABLE IF EXISTS `mm_user_config_data`;

CREATE TABLE `mm_user_config_data` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) unsigned NOT NULL,
  `fieldid` bigint(20) unsigned NOT NULL,
  `data` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_user_config_field` */

DROP TABLE IF EXISTS `mm_user_config_field`;

CREATE TABLE `mm_user_config_field` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `field` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `descript` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_map_recommend` */

DROP TABLE IF EXISTS `mm_map_recommend`;

CREATE TABLE `mm_map_recommend` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `map_id` bigint(20) unsigned NOT NULL,
  `added` bigint(15) unsigned NOT NULL DEFAULT '0',
  `imagepath` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_tier` */

DROP TABLE IF EXISTS `mm_tier`;

CREATE TABLE `mm_tier`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NULL,
  `summary` varchar(1000) NULL,
  `sortorder` int(10) UNSIGNED NULL,
  `activated` tinyint(4) UNSIGNED NULL DEFAULT 0,
  `created` bigint(15) UNSIGNED NULL DEFAULT 0,
  `modified` bigint(15) UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_tier_ability` */

DROP TABLE IF EXISTS `mm_tier_ability`;

CREATE TABLE `mm_tier_ability`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tierid` bigint(20) UNSIGNED NULL,
  `policy_key` varchar(255) NULL,
  `value` varchar(1000) NULL,
  `activated` tinyint(4) UNSIGNED NULL DEFAULT 0,
  `created` bigint(15) UNSIGNED NULL DEFAULT 0,
  `modified` bigint(15) UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `tierid` (`tierid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_tier_member` */

DROP TABLE IF EXISTS `mm_tier_member`;

CREATE TABLE `mm_tier_member`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tierid` bigint(20) UNSIGNED NULL,
  `userid` bigint(20) UNSIGNED NULL,
  `status` tinyint(4) NULL DEFAULT 0,
  `created` bigint(15) UNSIGNED NULL DEFAULT 0,
  `expiry_date` bigint(15) UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `tierid` (`tierid`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_tier_group` */

DROP TABLE IF EXISTS `mm_tier_group`;

CREATE TABLE `mm_tier_group`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tierid` bigint(20) UNSIGNED NULL,
  `groupid` bigint(20) UNSIGNED NULL,
  `status` tinyint(4) NULL DEFAULT 0,
  `created` bigint(15) UNSIGNED NULL DEFAULT 0,
  `expiry_date` bigint(15) UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `tierid` (`tierid`),
  KEY `groupid` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `mm_tier_user_data` */

DROP TABLE IF EXISTS `mm_tier_user_data`;

CREATE TABLE `mm_tier_user_data`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) UNSIGNED NULL,
  `policy_key` varchar(255) NULL,
  `value` varchar(1000) NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `mm_lis_grades`;
CREATE TABLE `mm_lis_grades` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `lis_result_sourcedid` text NOT NULL,
  `userid` bigint(20) UNSIGNED NOT NULL,
  `mapid` bigint(20) UNSIGNED NOT NULL,
  `nodeid` bigint(20) UNSIGNED NOT NULL,
  `score` double NOT NULL,
  `ts` bigint(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `mm_account_connected` (
  `idc` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_user` bigint(20) NOT NULL,
  `id_account` int(11) NOT NULL,
  `time` bigint(15) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `value` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `mm_account_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
