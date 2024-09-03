
/****************************************************/
/* 노드 관련 함수                                                                             */
/****************************************************/

-- SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS `mm_node__delete`;
DELIMITER $$
CREATE FUNCTION `mm_node__delete`(p_id BIGINT UNSIGNED, p_map_id BIGINT UNSIGNED) RETURNS INT(11)
    DETERMINISTIC
BEGIN
  DECLARE v_lft, v_rgt  INT;
  
        SELECT lft, rgt INTO v_lft, v_rgt FROM mm_node
        WHERE map_id = p_map_id
          AND id = p_id;
          
        DELETE FROM mm_node
        WHERE map_id = p_map_id
          AND lft BETWEEN v_lft AND v_rgt;
          
        UPDATE mm_node SET lft = CASE WHEN lft > v_lft THEN lft - (v_rgt - v_lft + 1) ELSE lft END,
                                    rgt = CASE WHEN rgt > v_lft THEN rgt - (v_rgt - v_lft + 1) ELSE rgt END
        WHERE map_id = p_map_id
          AND (lft > v_lft OR rgt > v_lft);
          
        RETURN 1;
END $$
DELIMITER ;

DROP FUNCTION IF EXISTS `mm_node__move`;
DELIMITER $$
CREATE FUNCTION `mm_node__move`(p_id BIGINT UNSIGNED, p_new_parent_id BIGINT UNSIGNED, p_map_id BIGINT UNSIGNED) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE v_origin_lft, v_origin_rgt, v_new_parent_rgt INT;
        SELECT lft, rgt
          INTO v_origin_lft, v_origin_rgt
        FROM mm_node
        WHERE id = p_id
          AND map_id = p_map_id;
        SELECT rgt
          INTO v_new_parent_rgt
        FROM mm_node
        WHERE id = p_new_parent_id
          AND map_id = p_map_id;
        UPDATE mm_node
           SET lft = lft + CASE WHEN v_new_parent_rgt < v_origin_lft
                                THEN CASE WHEN lft BETWEEN v_origin_lft AND v_origin_rgt
                                          THEN v_new_parent_rgt - v_origin_lft
                                          WHEN lft BETWEEN v_new_parent_rgt AND v_origin_lft - 1
                                          THEN v_origin_rgt - v_origin_lft + 1
                                          ELSE 0 END
                                WHEN v_new_parent_rgt > v_origin_rgt
                                THEN CASE WHEN lft BETWEEN v_origin_lft AND v_origin_rgt
                                          THEN v_new_parent_rgt - v_origin_rgt - 1
                                          WHEN lft BETWEEN v_origin_rgt + 1 AND v_new_parent_rgt - 1
                                          THEN v_origin_lft - v_origin_rgt - 1
                                          ELSE 0 END
                                ELSE 0 END,
               rgt = rgt + CASE WHEN v_new_parent_rgt < v_origin_lft
                                THEN CASE WHEN rgt BETWEEN v_origin_lft AND v_origin_rgt
                                          THEN v_new_parent_rgt - v_origin_lft
                                          WHEN rgt BETWEEN v_new_parent_rgt AND v_origin_lft - 1
                                          THEN v_origin_rgt - v_origin_lft + 1
                                          ELSE 0 END
                                WHEN v_new_parent_rgt > v_origin_rgt
                                THEN CASE WHEN rgt BETWEEN v_origin_lft AND v_origin_rgt
                                          THEN v_new_parent_rgt - v_origin_rgt - 1
                                          WHEN rgt BETWEEN v_origin_rgt + 1 AND v_new_parent_rgt - 1
                                          THEN v_origin_lft - v_origin_rgt - 1
                                          ELSE 0 END
                                ELSE 0 END
        WHERE map_id = p_map_id;
        UPDATE mm_node
           SET parent_id = p_new_parent_id
        WHERE id = p_id
            AND map_id = p_map_id;
        RETURN 1;
END $$
DELIMITER ;

DROP FUNCTION IF EXISTS `mm_node__move_after_sibling`;
DELIMITER $$
CREATE FUNCTION `mm_node__move_after_sibling`(
    move_id BIGINT,
    sibling_id BIGINT,
    parent_id BIGINT,
    p_map_id BIGINT UNSIGNED) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE move_lft INT;
    DECLARE move_rgt INT;
    DECLARE parent_lft INT;
    DECLARE parent_rgt INT;
    DECLARE sibling_lft INT;
    DECLARE sibling_rgt INT;

    SET move_lft = (SELECT lft FROM mm_node WHERE id = move_id AND map_id = p_map_id);
    SET move_rgt = (SELECT rgt FROM mm_node WHERE id = move_id AND map_id = p_map_id);
    SET parent_lft = (SELECT lft FROM mm_node WHERE id = parent_id AND map_id = p_map_id);
    SET parent_rgt = (SELECT rgt FROM mm_node WHERE id = parent_id AND map_id = p_map_id);
    SET sibling_lft = (SELECT lft FROM mm_node WHERE id = sibling_id AND map_id = p_map_id);
    SET sibling_rgt = (SELECT rgt FROM mm_node WHERE id = sibling_id AND map_id = p_map_id);

    UPDATE mm_node
        SET
            lft =
                CASE
                    WHEN sibling_id = parent_id THEN
                        CASE
                            WHEN lft BETWEEN parent_lft+1 AND move_lft-1 THEN
                                lft + (move_rgt - move_lft) + 1
                            WHEN lft BETWEEN move_lft AND move_rgt THEN
                                lft - (move_lft - (parent_lft + 1))
                            ELSE
                                lft
                        END
                    ELSE
                        CASE
                            WHEN move_lft > sibling_lft THEN
                                CASE
                                    WHEN lft BETWEEN sibling_rgt AND move_lft-1 THEN
                                        lft + (move_rgt - move_lft) + 1
                                    WHEN lft BETWEEN move_lft AND move_rgt THEN
                                        lft - (move_lft - (sibling_rgt + 1))
                                    ELSE
                                        lft
                                END
                            ELSE
                                CASE
                                    WHEN lft BETWEEN move_rgt+1 AND sibling_rgt THEN
                                        lft - ((move_rgt - move_lft) + 1)
                                    WHEN lft BETWEEN move_lft AND move_rgt THEN
                                        lft + (sibling_rgt - move_rgt)
                                    ELSE
                                        lft
                                END
                        END
                END,
            rgt =
                CASE
                    WHEN sibling_id = parent_id THEN
                        CASE
                            WHEN rgt BETWEEN parent_lft+1 AND move_lft-1 THEN
                                rgt + (move_rgt - move_lft) + 1
                            WHEN rgt BETWEEN move_lft AND move_rgt THEN
                                rgt - (move_lft - (parent_lft + 1))
                            ELSE
                                rgt
                        END
                    ELSE
                        CASE
                            WHEN move_rgt > sibling_lft THEN
                                CASE
                                    WHEN rgt BETWEEN sibling_rgt+1 AND move_lft-1 THEN
                                        rgt + (move_rgt - move_lft) + 1
                                    WHEN rgt BETWEEN move_lft AND move_rgt THEN
                                        rgt - (move_lft - (sibling_rgt + 1))
                                    ELSE
                                        rgt
                                END
                            ELSE
                                CASE
                                    WHEN rgt BETWEEN move_rgt+1 AND sibling_rgt+1 THEN
                                        rgt - ((move_rgt - move_lft) + 1)
                                    WHEN rgt BETWEEN move_lft AND move_rgt THEN
                                        rgt + (sibling_rgt - move_rgt)
                                    ELSE
                                        rgt
                                END
                        END
                END
        WHERE lft BETWEEN parent_lft+1 AND parent_rgt
          AND map_id = p_map_id;

    RETURN 1;
END $$
DELIMITER ;

DROP FUNCTION IF EXISTS `mm_node__move_before_sibling`;
DELIMITER $$
CREATE FUNCTION `mm_node__move_before_sibling`(
	move_id BIGINT,
	sibling_id BIGINT,
	parent_id BIGINT,
	p_map_id BIGINT UNSIGNED) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE move_lft INT;
    DECLARE move_rgt INT;
    DECLARE parent_lft INT;
    DECLARE parent_rgt INT;
    DECLARE sibling_lft INT;
    DECLARE sibling_rgt INT;
    SET move_lft = (SELECT lft FROM mm_node WHERE id = move_id AND map_id = p_map_id);
    SET move_rgt = (SELECT rgt FROM mm_node WHERE id = move_id AND map_id = p_map_id);
    SET parent_lft = (SELECT lft FROM mm_node WHERE id = parent_id AND map_id = p_map_id);
    SET parent_rgt = (SELECT rgt FROM mm_node WHERE id = parent_id AND map_id = p_map_id);
    SET sibling_lft = (SELECT lft FROM mm_node WHERE id = sibling_id AND map_id = p_map_id);
    SET sibling_rgt = (SELECT rgt FROM mm_node WHERE id = sibling_id AND map_id = p_map_id);
    UPDATE mm_node
        SET
            lft =
                CASE
                    WHEN sibling_id = parent_id THEN
                        CASE
                            WHEN lft BETWEEN move_rgt+1 AND parent_rgt-1 THEN
                                lft - (move_rgt - move_lft) - 1
                            WHEN lft BETWEEN move_lft AND move_rgt THEN
                                lft + (parent_rgt - (move_rgt + 1))
                            ELSE
                                lft
                        END
                    ELSE
                        CASE
                            WHEN move_lft > sibling_lft THEN
                                CASE
                                    WHEN lft BETWEEN sibling_lft AND move_lft-1 THEN
                                        lft + ((move_rgt - move_lft) + 1)
                                    WHEN lft BETWEEN move_lft AND move_rgt THEN
                                        lft - (move_lft - sibling_lft)
                                    ELSE
                                        lft
                                END
                            ELSE
                                CASE
                                    WHEN lft BETWEEN move_rgt+1 AND sibling_lft-1 THEN
                                        lft - ((move_rgt - move_lft) + 1)
                                    WHEN lft BETWEEN move_lft AND move_rgt THEN
                                        lft + (sibling_lft - (move_rgt + 1))
                                    ELSE
                                        lft
                                END
                        END
                END,
            rgt =
                CASE
                    WHEN sibling_id = parent_id THEN
                        CASE
                            WHEN rgt BETWEEN move_rgt+1 AND parent_rgt-1 THEN
                                rgt - ((move_rgt - move_lft) + 1)
                            WHEN rgt BETWEEN move_lft AND move_rgt THEN
                                rgt - (parent_rgt - (move_rgt + 1))
                            ELSE
                                rgt
                        END
                    ELSE
                        CASE
                            WHEN move_rgt > sibling_lft THEN
                                CASE
                                    WHEN rgt BETWEEN sibling_lft AND move_lft THEN
                                        rgt + (move_rgt - move_lft) + 1
                                    WHEN rgt BETWEEN move_lft AND move_rgt THEN
                                        rgt - (move_lft - sibling_lft)
                                    ELSE
                                        rgt
                                END
                            ELSE
                                CASE
                                    WHEN rgt BETWEEN move_rgt+1 AND sibling_lft-1 THEN
                                        rgt - ((move_rgt - move_lft) + 1)
                                    WHEN rgt BETWEEN move_lft AND move_rgt THEN
                                        rgt + (sibling_lft - (move_rgt + 1))
                                    ELSE
                                        rgt
                                END
                        END
                END
        WHERE lft BETWEEN parent_lft+1 AND parent_rgt
          AND map_id = p_map_id;

	RETURN 1;
END $$
DELIMITER ;

DROP FUNCTION IF EXISTS `mm_node__new`;
DELIMITER $$
CREATE FUNCTION `mm_node__new`(p_map_id BIGINT UNSIGNED,
        p_background_color VARCHAR(10),
        p_color VARCHAR(10),
        p_folded VARCHAR(5),
        p_identity VARCHAR(50),
        p_link VARCHAR(2000),
        p_file VARCHAR(2000),
        p_note VARCHAR(2000),
        p_position VARCHAR(10),
        p_style VARCHAR(10),
        p_text TEXT,
        p_created BIGINT(15),
        p_creator BIGINT UNSIGNED,
        p_creator_ip VARCHAR(40),
        p_modified BIGINT(15),
        p_modifier BIGINT UNSIGNED,
        p_modifier_ip VARCHAR(40),
        p_hgap INT,
        p_vgap INT,
        p_vshift INT,
        p_encrypted_content TEXT,
        p_extra_data TEXT,
        p_type VARCHAR(40),
        p_parent_id BIGINT UNSIGNED,
        p_client_id VARCHAR(40)) RETURNS bigint(20)
    DETERMINISTIC
BEGIN
  DECLARE v_id INT;
  DECLARE v_lft INT DEFAULT 0;
  DECLARE v_rgt INT DEFAULT 1;
        
        SELECT lft, rgt INTO v_lft, v_rgt
        FROM mm_node
        WHERE id = p_parent_id
          AND map_id = p_map_id;
          
        UPDATE mm_node SET lft = CASE WHEN lft > v_rgt THEN lft + 2 ELSE lft END,
                                    rgt = CASE WHEN rgt >= v_rgt THEN rgt + 2 ELSE rgt END
        WHERE rgt >= v_rgt
          AND map_id = p_map_id;
          
        INSERT INTO mm_node ( 
                             map_id,
                             background_color,
                             color,
                             folded,
                             identity,
                             link,
                             file,
                             note,
                             POSITION,
                             style,
                             TEXT,
                             created,
                             creator,
                             creator_ip,
                             modified,
                             MODIFIER,
                             modifier_ip,
                             hgap,
                             vgap,
                             vshift,
                             encrypted_content,
                             extra_data,
                             node_type,
                             lft,
                             rgt,
                             parent_id,
                             client_id)
        VALUES( 
                p_map_id,
                p_background_color,
                p_color,
                p_folded,
                p_identity,
                p_link,
                p_file,
                p_note,
                p_position,
                p_style,
                p_text,
                p_created,
                p_creator,
                p_creator_ip,
                p_modified,
                p_modifier,
                p_modifier_ip,
                p_hgap,
                p_vgap,
                p_vshift,
                p_encrypted_content,
                p_extra_data,
                p_type,
                v_rgt,
                v_rgt + 1,
                p_parent_id,
                p_client_id);
        SELECT LAST_INSERT_ID() INTO v_id;
        
        RETURN v_id;
END $$
DELIMITER ;

DROP FUNCTION IF EXISTS `mm_node__swap`;
DELIMITER $$
CREATE FUNCTION `mm_node__swap`(p_id_1 BIGINT UNSIGNED, p_id_2 BIGINT UNSIGNED, p_map_id BIGINT UNSIGNED) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE v_lft_1, v_rgt_1, v_lft_2, v_rgt_2 INT;
        SELECT lft, rgt INTO v_lft_1, v_rgt_1
        FROM mm_node
        WHERE id = p_id_1;
        SELECT lft, rgt INTO v_lft_2, v_rgt_2
        FROM mm_node
        WHERE id = p_id_2;
        UPDATE mm_node
           SET lft = CASE WHEN lft BETWEEN v_lft_1 AND v_rgt_1
                           THEN v_rgt_2 + lft - v_rgt_1
                           WHEN lft BETWEEN v_lft_2 AND v_rgt_2
                           THEN v_lft_1 + lft - v_lft_2
                           ELSE v_lft_1 + v_rgt_2 + lft - v_rgt_1 - v_lft_2 END,
               rgt = CASE WHEN rgt BETWEEN v_lft_1 AND v_rgt_1
                           THEN v_rgt_2 + rgt - v_rgt_1
                           WHEN rgt BETWEEN v_lft_2 AND v_rgt_2
                           THEN v_lft_1 + rgt - v_lft_2
                           ELSE v_lft_1 + v_rgt_2 + rgt - v_rgt_1 - v_lft_2 END
        WHERE lft BETWEEN v_lft_1 AND v_rgt_2
          AND v_lft_1 < v_rgt_1
          AND v_rgt_1 < v_lft_2
          AND v_lft_2 < v_rgt_2
          AND map_id = p_map_id;
        RETURN 1;
END $$
DELIMITER ;



/****************************************************/
/* 카테고리 관련 함수                                                                      */
/****************************************************/

-- SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS `mm_categories__delete`;
DELIMITER $$
CREATE FUNCTION `mm_categories__delete`(
		p_id BIGINT UNSIGNED) RETURNS INT(11)
    DETERMINISTIC
BEGIN
  DECLARE v_lft, v_rgt  INT;
        SELECT lft, rgt INTO v_lft, v_rgt FROM mm_categories
        WHERE id = p_id;
        DELETE FROM mm_categories
        WHERE lft BETWEEN v_lft AND v_rgt;
        UPDATE mm_categories SET lft = CASE WHEN lft > v_lft THEN lft - (v_rgt - v_lft + 1) ELSE lft END,
                                    rgt = CASE WHEN rgt > v_lft THEN rgt - (v_rgt - v_lft + 1) ELSE rgt END
        WHERE (lft > v_lft OR rgt > v_lft);
        RETURN 1;
END $$
DELIMITER ;


DROP FUNCTION IF EXISTS `mm_categories__move`;
DELIMITER $$
CREATE FUNCTION `mm_categories__move`(
		p_id BIGINT UNSIGNED,
		p_new_parentid BIGINT UNSIGNED) RETURNS INT(11)
    DETERMINISTIC
BEGIN
  DECLARE v_origin_lft, v_origin_rgt, v_new_parent_rgt INT;
        SELECT lft, rgt
          INTO v_origin_lft, v_origin_rgt
        FROM mm_categories
        WHERE id = p_id;
        SELECT rgt 
          INTO v_new_parent_rgt
        FROM mm_categories
        WHERE id = p_new_parentid;
        UPDATE mm_categories
           SET lft = lft + CASE WHEN v_new_parent_rgt < v_origin_lft
                                THEN CASE WHEN lft BETWEEN v_origin_lft AND v_origin_rgt
                                          THEN v_new_parent_rgt - v_origin_lft
                                          WHEN lft BETWEEN v_new_parent_rgt AND v_origin_lft - 1
                                          THEN v_origin_rgt - v_origin_lft + 1
                                          ELSE 0 END
                                WHEN v_new_parent_rgt > v_origin_rgt
                                THEN CASE WHEN lft BETWEEN v_origin_lft AND v_origin_rgt
                                          THEN v_new_parent_rgt - v_origin_rgt - 1
                                          WHEN lft BETWEEN v_origin_rgt + 1 AND v_new_parent_rgt - 1
                                          THEN v_origin_lft - v_origin_rgt - 1 
                                          ELSE 0 END 
                                ELSE 0 END,
               rgt = rgt + CASE WHEN v_new_parent_rgt < v_origin_lft
                                THEN CASE WHEN rgt BETWEEN v_origin_lft AND v_origin_rgt
                                          THEN v_new_parent_rgt - v_origin_lft
                                          WHEN rgt BETWEEN v_new_parent_rgt AND v_origin_lft - 1
                                          THEN v_origin_rgt - v_origin_lft + 1
                                          ELSE 0 END
                                WHEN v_new_parent_rgt > v_origin_rgt
                                THEN CASE WHEN rgt BETWEEN v_origin_lft AND v_origin_rgt
                                          THEN v_new_parent_rgt - v_origin_rgt - 1
                                          WHEN rgt BETWEEN v_origin_rgt + 1 AND v_new_parent_rgt - 1
                                          THEN v_origin_lft - v_origin_rgt - 1
                                          ELSE 0 END
                                ELSE 0 END;
        UPDATE mm_categories
           SET parentid = p_new_parentid
        WHERE id = p_id;
        RETURN 1;
END $$
DELIMITER ;


DROP FUNCTION IF EXISTS mm_categories__new;
DELIMITER $$
CREATE FUNCTION mm_categories__new(
        p_id BIGINT,
        p_name VARCHAR(1000),
        p_parentid BIGINT UNSIGNED) RETURNS BIGINT(20)
    DETERMINISTIC
BEGIN
  DECLARE v_lft INT DEFAULT 1;
  DECLARE v_rgt INT DEFAULT 2;
  DECLARE v_depth INT DEFAULT 0;
        SELECT lft, rgt INTO v_lft, v_rgt 
        FROM mm_categories 
        WHERE id = p_parentid;
        UPDATE mm_categories SET lft = CASE WHEN lft > v_rgt THEN lft + 2 ELSE lft END,
                                    rgt = CASE WHEN rgt >= v_rgt THEN rgt + 2 ELSE rgt END
        WHERE rgt >= v_rgt;
        INSERT INTO mm_categories (id, NAME, lft, rgt, parentid, depth)
        VALUES(p_id, p_name, v_rgt, v_rgt + 1, p_parentid, 0);
        
        SELECT (COUNT(parent.id) - 1) INTO v_depth
        FROM (mm_categories node
        JOIN mm_categories parent)
        WHERE node.id = p_id AND (node.lft BETWEEN parent.lft AND parent.rgt)
        GROUP BY node.id;
        
        UPDATE mm_categories SET depth = v_depth
        WHERE id = p_id;

        RETURN p_id;
END$$
DELIMITER ;


DROP FUNCTION IF EXISTS `mm_categories__swap`;
DELIMITER $$

CREATE FUNCTION `mm_categories__swap`(
		p_id_1 BIGINT UNSIGNED,
		p_id_2 BIGINT UNSIGNED) RETURNS INT(11)
    DETERMINISTIC
BEGIN
  DECLARE v_lft_1, v_rgt_1, v_lft_2, v_rgt_2 INT;
        SELECT lft, rgt INTO v_lft_1, v_rgt_1
        FROM mm_categories
        WHERE id = p_id_1;
        SELECT lft, rgt INTO v_lft_2, v_rgt_2
        FROM mm_categories
        WHERE id = p_id_2;
        UPDATE mm_categories
           SET lft = CASE WHEN lft BETWEEN v_lft_1 AND v_rgt_1
                           THEN v_rgt_2 + lft - v_rgt_1
                           WHEN lft BETWEEN v_lft_2 AND v_rgt_2
                           THEN v_lft_1 + lft - v_lft_2
                           ELSE v_lft_1 + v_rgt_2 + lft - v_rgt_1 - v_lft_2 END,
               rgt = CASE WHEN rgt BETWEEN v_lft_1 AND v_rgt_1
                           THEN v_rgt_2 + rgt - v_rgt_1
                           WHEN rgt BETWEEN v_lft_2 AND v_rgt_2
                           THEN v_lft_1 + rgt - v_lft_2
                           ELSE v_lft_1 + v_rgt_2 + rgt - v_rgt_1 - v_lft_2 END
        WHERE lft BETWEEN v_lft_1 AND v_rgt_2
          AND v_lft_1 < v_rgt_1
          AND v_rgt_1 < v_lft_2
          AND v_lft_2 < v_rgt_2;
        RETURN 1;
END $$
DELIMITER ;