ALTER TABLE `mm_user` ADD `validation` VARCHAR(64) NULL AFTER `confirmed`;

DROP TABLE IF EXISTS `mm_tier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mm_tier` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `summary` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sortorder` int(10) unsigned DEFAULT NULL,
  `activated` tinyint(4) unsigned DEFAULT '0',
  `created` bigint(15) unsigned DEFAULT '0',
  `modified` bigint(15) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mm_tier`
--

LOCK TABLES `mm_tier` WRITE;
/*!40000 ALTER TABLE `mm_tier` DISABLE KEYS */;
INSERT INTO `mm_tier` VALUES (1,'Basic (free)','Free',0,1,1592928987189,1594235882167),(2,'Standard','Standard',0,0,1593503860944,1594235890727);
/*!40000 ALTER TABLE `mm_tier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mm_tier_ability`
--

DROP TABLE IF EXISTS `mm_tier_ability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mm_tier_ability` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tierid` bigint(20) unsigned DEFAULT NULL,
  `policy_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activated` tinyint(4) unsigned DEFAULT '0',
  `created` bigint(15) unsigned DEFAULT '0',
  `modified` bigint(15) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tierid` (`tierid`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mm_tier_ability`
--

LOCK TABLES `mm_tier_ability` WRITE;
/*!40000 ALTER TABLE `mm_tier_ability` DISABLE KEYS */;
INSERT INTO `mm_tier_ability` VALUES (1,1,'map.create','5',1,1592928987201,1594235882172),(2,1,'presentation.box','',1,1592928987204,1594235882183),(3,1,'presentation.dynamic','',0,1592928987208,1594235882185),(4,1,'mapstyle.sunburst','',0,1592928987219,1594235882205),(5,1,'mapstyle.padlet','',0,1592928987222,1594235882209),(6,1,'moodle','{\"only_student\":true}',1,1592928987229,1594235882239),(7,1,'iot.add','3',1,1592928987234,1594235882241),(8,2,'map.create','',0,1593503860947,1594235890733),(9,2,'presentation.box','',0,1593503860950,1594235890743),(10,2,'presentation.dynamic','',0,1593503860953,1594235890747),(11,2,'mapstyle.sunburst','',0,1593503860965,1594235890759),(12,2,'mapstyle.padlet','',0,1593503860967,1594235890765),(13,2,'moodle','{\"only_student\":false,\"course_hosting\":\"4\"}',1,1593503860970,1594235890795),(14,2,'iot.add','',0,1593503860971,1594235890796),(15,1,'map.remix','5',1,1594235882175,1594235882175),(16,1,'sharemap.creategroup','3',1,1594235882182,1594235882182),(17,1,'presentation.aero','',0,1594235882188,1594235882188),(18,1,'presentation.linear','',0,1594235882191,1594235882191),(19,1,'presentation.mindmapbasic','',0,1594235882194,1594235882194),(20,1,'presentation.mindmapzoom','',0,1594235882197,1594235882197),(21,1,'mapstyle.mindmap','',1,1594235882201,1594235882201),(22,1,'mapstyle.card','',0,1594235882204,1594235882204),(23,1,'mapstyle.tree','',0,1594235882206,1594235882206),(24,1,'mapstyle.project','',0,1594235882208,1594235882208),(25,1,'mapstyle.partition','',0,1594235882212,1594235882212),(26,1,'mapstyle.fishbone','',0,1594235882214,1594235882214),(27,1,'mapstyle.rect','',0,1594235882215,1594235882215),(28,1,'import.xml','',0,1594235882218,1594235882218),(29,1,'import.text','',0,1594235882220,1594235882220),(30,1,'import.bookmark','',0,1594235882221,1594235882221),(31,1,'import.freemind','',1,1594235882222,1594235882222),(32,1,'export.ppt','',0,1594235882224,1594235882224),(33,1,'export.html','',0,1594235882225,1594235882225),(34,1,'export.freemind','',1,1594235882227,1594235882227),(35,1,'export.svg','',0,1594235882230,1594235882230),(36,1,'export.png','',0,1594235882231,1594235882231),(37,1,'export.text','',0,1594235882233,1594235882233),(38,1,'export.xml','',0,1594235882235,1594235882235),(39,1,'export.textclipboard','',0,1594235882238,1594235882238),(40,2,'map.remix','',0,1594235890735,1594235890735),(41,2,'sharemap.creategroup','',0,1594235890737,1594235890737),(42,2,'presentation.aero','',0,1594235890749,1594235890749),(43,2,'presentation.linear','',0,1594235890752,1594235890752),(44,2,'presentation.mindmapbasic','',0,1594235890754,1594235890754),(45,2,'presentation.mindmapzoom','',0,1594235890755,1594235890755),(46,2,'mapstyle.mindmap','',0,1594235890756,1594235890756),(47,2,'mapstyle.card','',0,1594235890758,1594235890758),(48,2,'mapstyle.tree','',0,1594235890761,1594235890761),(49,2,'mapstyle.project','',0,1594235890763,1594235890763),(50,2,'mapstyle.partition','',0,1594235890767,1594235890767),(51,2,'mapstyle.fishbone','',0,1594235890768,1594235890768),(52,2,'mapstyle.rect','',0,1594235890771,1594235890771),(53,2,'import.xml','',0,1594235890773,1594235890773),(54,2,'import.text','',0,1594235890775,1594235890775),(55,2,'import.bookmark','',0,1594235890777,1594235890777),(56,2,'import.freemind','',0,1594235890778,1594235890778),(57,2,'export.ppt','',0,1594235890780,1594235890780),(58,2,'export.html','',0,1594235890782,1594235890782),(59,2,'export.freemind','',0,1594235890784,1594235890784),(60,2,'export.svg','',0,1594235890785,1594235890785),(61,2,'export.png','',0,1594235890787,1594235890787),(62,2,'export.text','',0,1594235890789,1594235890789),(63,2,'export.xml','',0,1594235890791,1594235890791),(64,2,'export.textclipboard','',0,1594235890792,1594235890792);
/*!40000 ALTER TABLE `mm_tier_ability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mm_tier_member`
--

DROP TABLE IF EXISTS `mm_tier_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mm_tier_member` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tierid` bigint(20) unsigned DEFAULT NULL,
  `userid` bigint(20) unsigned DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0',
  `created` bigint(15) unsigned DEFAULT '0',
  `expiry_date` bigint(15) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tierid` (`tierid`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mm_tier_member`
--

LOCK TABLES `mm_tier_member` WRITE;
/*!40000 ALTER TABLE `mm_tier_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `mm_tier_member` ENABLE KEYS */;
UNLOCK TABLES;

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