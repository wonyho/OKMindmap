INSERT INTO mm_categories (NAME, lft, rgt, parentid) VALUES ('/', 1, 2, 0);


INSERT INTO mm_user (id, username, email, firstname, lastname, PASSWORD, auth, confirmed, deleted, created, last_access) VALUES (1, 'admin', 'jinhoon@jinotech.com', 'Administrator', 'User', '3610b3985b358ff5680e0e6f37b9fdb4ae95fd81a2de9cb1d03412a25ab9860a', 'manual', 1, 0, 0, 0);
INSERT INTO mm_user (id, username, email, firstname, lastname, PASSWORD, auth, confirmed, deleted, created, last_access) VALUES (2, 'guest', 'guest@jinotech.com', 'Guest', 'User', '3610b3985b358ff5680e0e6f37b9fdb4ae95fd81a2de9cb1d03412a25ab9860a', 'manual', 1, 0, 0, 0);
-- password: OKMM!234

INSERT INTO mm_role (id, NAME, shortname) VALUES (1, 'Administrator', 'admin');
INSERT INTO mm_role (id, NAME, shortname) VALUES (2, 'User', 'user');
INSERT INTO mm_role (id, NAME, shortname) VALUES (3, 'Guest', 'guest');


INSERT INTO mm_role_assignments (roleid, userid) VALUES (1, 1);
INSERT INTO mm_role_assignments (roleid, userid) VALUES (3, 2);


INSERT INTO mm_role_capabilities (roleid, capability, permission) VALUES (1, 'site:administration', 1);


INSERT INTO mm_group_member_status_type (NAME, shortname) VALUES ('Approved', 'approved');
INSERT INTO mm_group_member_status_type (NAME, shortname) VALUES ('Waiting Approval', 'waiting');


INSERT INTO mm_group_policy_type (NAME, shortname) VALUES ('Opened', 'open');
INSERT INTO mm_group_policy_type (NAME, shortname) VALUES ('Need Password', 'password');
INSERT INTO mm_group_policy_type (NAME, shortname) VALUES ('Need Approval', 'approval');
INSERT INTO mm_group_policy_type (NAME, shortname) VALUES ('Closed', 'closed');


INSERT INTO mm_share_type (NAME, shortname) VALUES ('Open', 'open');   -- 전체 공개
INSERT INTO mm_share_type (NAME, shortname) VALUES ('Group', 'group'); -- 그룹 공개
INSERT INTO mm_share_type (NAME, shortname) VALUES ('Password', 'password'); -- 비번 공개


INSERT INTO mm_share_permission_type (NAME, shortname, sortorder) VALUES ('View', 'view', 1);
INSERT INTO mm_share_permission_type (NAME, shortname, sortorder) VALUES ('Copy node', 'copynode', 2);
INSERT INTO mm_share_permission_type (NAME, shortname, sortorder) VALUES ('Edit', 'edit', 3);
-- INSERT INTO mm_share_permission_type (name, shortname) VALUES ('Delete', 'delete');


INSERT INTO mm_map (id, NAME, VERSION, created, map_key, viewcount) VALUES (1, 'OK Mindmap KO', '0.9.0', 0, 'ZWQzOGFkZDgtNjNjOS00MzY5LWE2NzMtNTNhYWYwOTU1Mzc5', 0);
INSERT INTO mm_map_owner (id, mapid, userid) VALUES(1, 1, 1);
INSERT INTO mm_node (id, map_id, TEXT, created, creator, modified, MODIFIER, lft, rgt, parent_id) VALUES (1, 1, 'OK Mindmap KO', 0, 1, 0, 1, 1, 2, 0);
INSERT INTO mm_map (id, NAME, VERSION, created, map_key, viewcount) VALUES (2, 'OK Mindmap EN', '0.9.0', 0, 'ZThlZjMzMDQtOGFhOC00N2Y1LTliMWMtZWI5NTg0MjJmZTAx', 0);
INSERT INTO mm_map_owner (id, mapid, userid) VALUES(2, 2, 1);
INSERT INTO mm_node (id, map_id, TEXT, created, creator, modified, MODIFIER, lft, rgt, parent_id) VALUES (2, 2, 'OK Mindmap EN', 0, 1, 0, 1, 1, 2, 0);

INSERT INTO mm_user_config_field (id, FIELD, descript) VALUES (1, 'default_img_size', 'image Default Size');
INSERT INTO mm_user_config_field (id, FIELD, descript) VALUES (2, 'default_video_size', 'image Video Size');
INSERT INTO mm_user_config_field (id, FIELD, descript) VALUES (3, 'default_menu_opacity', 'menu opacity check');
INSERT INTO `mm_user_config_field` (`id`, `field`, `descript`) VALUES
(4, 'menu.edit.hyperlink', 'Insert hyperlink'),
(6, 'menu.edit.imageurl', 'Insert image'),
(7, 'video.video_upload', 'Insert video'),
(8, 'menu.edit.webpage', 'Insert webpage'),
(9, 'menu.insertTextOnBranchAction', 'Insert text on brank'),
(10, 'menu.fileProviderAction', 'Insert file'),
(11, 'menu.insertNoteAction', 'Insert note'),
(12, 'menu.edit.lti', 'Insert lti'),
(13, 'menu.plugin.iot_providers', 'Insert iot provider'),
(14, 'menu.plugin.iot_control', 'Insert iot control'),
(15, 'menu.nodeTextColorAction', 'Insert node text color'),
(16, 'menu.edit.iframe', 'Insert iframe'),
(17, 'menu.emty', 'None use'),
(18, 'menu.edit.siblingnode', 'insert siblingnode'),
(19, 'menu.edit.childnode', 'insert childnode'),
(20, 'menu.view.folding', 'folding'),
(22, 'menu.edit', 'start edit node'),
(23, 'menu.edit.cut', 'cut node'),
(24, 'menu.edit.copy', 'copy node'),
(25, 'menu.edit.paste', 'paste'),
(26, 'menu.decreaseFontSizeAction', 'font down'),
(27, 'menu.increaseFontSizeAction', 'font up'),
(28, 'menu.edgeMenu', 'node edge'),
(29, 'menu.nodeBGColorAction', 'map background'),
(30, 'menu.edit.delete', 'delete node'),
(31, 'menu.nodeEdgeColorAction', 'edge color'),
(32, 'default_node_size', 'Minimum node width'),
(33, 'avatar', 'Avatar'),
(34, 'school_name', 'School name'),
(35, 'user.rMaps', 'User recent maps'),
(36, 'default_rMaps_number', 'number of recent maps'),
(37, 'menu.xmlimportexport.export', 'export to XML'),
(38, 'menu.xmlimportexport.import', 'import from XML'),
(39, 'menu.textimportexport.export', 'export to TEXT'),
(40, 'menu.textimportexport.import', 'import from TEXT');
INSERT INTO `mm_user_config_field` (`id`, `field`, `descript`) VALUES (NULL, 'menu.mindmap.newnodemap', 'Brank map');
INSERT INTO `mm_user_config_field` (`id`, `field`, `descript`) VALUES (NULL, 'userNmenuOrder', 'User node menu order');
INSERT INTO `mm_user_config_field` (`id`, `field`, `descript`) VALUES (NULL, 'menu.fontsize', 'Node font size');
INSERT INTO `mm_user_config_field` (`id`, `field`, `descript`) VALUES (NULL, 'user.slideMaster', 'User slide master');
INSERT INTO `mm_user_config_field` (`id`, `field`, `descript`) VALUES (NULL, 'user.slideMaster.thumb', 'User slide master thumb');
INSERT INTO `mm_user_config_field` (`id`, `field`, `descript`) VALUES (NULL, 'menu.nodeToNodeAction', 'Node to node');
INSERT INTO `mm_user_config_field` (`id`, `field`, `descript`) VALUES (NULL, 'menu.removeArrowLink', 'Remove Arrow');
INSERT INTO `mm_user_config_field` (`id`, `field`, `descript`) VALUES (NULL, 'menu.settingArrowLink', 'Arrow setting');

INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (1, 'notice_updated', 0);
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (2, 'guest_map_allow', 0);
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (3, 'create_max_map', 999);
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (4, 'moodle_connections', '');
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (5, 'nodejs_url', 'http://211.43.13.227:3000');
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (6, 'nodered_connections', '[]');
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (7, 'ga_trackingId', '');
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (8, 'default_account_level_student', 1);
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (9, 'default_account_level_teacher', 1);
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (10, 'translate_api', '');
INSERT INTO `mm_account_type` (`id`, `name`) VALUES (1, 'Google'), (2, 'Moodle'), (3, 'Facebook'), (4, 'Kakao');
