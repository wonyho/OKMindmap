
INSERT INTO mm_user (id, username, email, firstname, lastname, PASSWORD, auth, confirmed, deleted, created, last_access) VALUES (1, 'admin', 'jinhoon@jinotech.com', 'Administrator', 'User', '3610b3985b358ff5680e0e6f37b9fdb4ae95fd81a2de9cb1d03412a25ab9860a', 'manual', 1, 0, 0, 0);
INSERT INTO mm_user (id, username, email, firstname, lastname, PASSWORD, auth, confirmed, deleted, created, last_access) VALUES (2, 'guest', 'guest@jinotech.com', 'Guest', 'User', '3610b3985b358ff5680e0e6f37b9fdb4ae95fd81a2de9cb1d03412a25ab9860a', 'manual', 1, 0, 0, 0);
-- password: OKMM!234
-- 자동증가 값을 변경해야 함.
ALTER SERIAL mm_user_ai_id START WITH 3; 


INSERT INTO mm_map (id, NAME, VERSION, created, map_key, viewcount) VALUES (1, 'OK Mindmap KO', '0.9.0', 0, 'ZWQzOGFkZDgtNjNjOS00MzY5LWE2NzMtNTNhYWYwOTU1Mzc5', 0);
INSERT INTO mm_node (id, map_id, TEXT, created, creator, modified, MODIFIER, lft, rgt, parent_id) VALUES (1, 1, 'OK Mindmap KO', 0, 1, 0, 1, 1, 2, 0);
INSERT INTO mm_map (id, NAME, VERSION, created, map_key, viewcount) VALUES (2, 'OK Mindmap EN', '0.9.0', 0, 'ZThlZjMzMDQtOGFhOC00N2Y1LTliMWMtZWI5NTg0MjJmZTAx', 0);
INSERT INTO mm_node (id, map_id, TEXT, created, creator, modified, MODIFIER, lft, rgt, parent_id) VALUES (2, 2, 'OK Mindmap EN', 0, 1, 0, 1, 1, 2, 0);ALTER SERIAL mm_map_ai_id START WITH 3; 
ALTER SERIAL mm_node_ai_id START WITH 3; 


INSERT INTO mm_user_config_field (id, FIELD, descript) VALUES (1, 'default_img_size', 'image Default Size');
INSERT INTO mm_user_config_field (id, FIELD, descript) VALUES (2, 'default_video_size', 'image Video Size');
INSERT INTO mm_user_config_field (id, FIELD, descript) VALUES (3, 'default_menu_opacity', 'menu opacity check');
ALTER SERIAL mm_user_config_field_ai_id START WITH 4; 

INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (1, 'notice_updated', '0');
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (2, 'guest_map_allow', '0');
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (3, 'create_max_map', '999');
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (4, 'moodle_connections', '');
INSERT INTO mm_okm_setting (id, setting_key, setting_value) VALUES (4, 'nodejs_url', 'http://211.43.13.227:3000');
ALTER SERIAL mm_okm_setting_ai_id START WITH 6;

COMMIT;