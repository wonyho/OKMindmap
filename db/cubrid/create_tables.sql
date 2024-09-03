
CREATE TABLE mm_queuedata(
roomnumber character varying(100) NOT NULL,
textdata character varying(1073741823),
created datetime
) COLLATE utf8_bin  REUSE_OID ;


CREATE TABLE mm_attribute_registry(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
map_revision_id bigint NOT NULL,
show_attributes character varying(20)
) COLLATE utf8_bin  REUSE_OID ;


CREATE TABLE mm_map_timeline(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
map_id bigint NOT NULL,
xml character varying(1073741823),
saved bigint
) COLLATE utf8_bin  REUSE_OID ;


CREATE TABLE mm_parameters(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
hook_id bigint NOT NULL,
reminduserat character varying(15)
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_icon(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
builtin character varying(50),
map_id bigint NOT NULL
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_arrowlink(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
color character varying(10),
destination character varying(50),
endarrow character varying(20),
endinclination character varying(20),
[identity] character varying(50),
startarrow character varying(20),
startinclination character varying(20),
map_id bigint NOT NULL
) COLLATE utf8_bin  REUSE_OID ;


CREATE TABLE mm_edge(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
color character varying(10),
style character varying(20),
width integer,
map_id bigint NOT NULL
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_branch(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
color character varying(10),
style character varying(20),
width integer,
map_id bigint NOT NULL
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_foreignobject(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
content character varying(1073741823),
width integer,
height integer,
map_id bigint NOT NULL
) COLLATE utf8_bin  REUSE_OID ;



CREATE TABLE mm_map (
	id BIGINT AUTO_INCREMENT(1, 1) NOT NULL,
	[name] CHARACTER VARYING (1000) NOT NULL,
	[version] CHARACTER VARYING (20) NOT NULL,
	created BIGINT NOT NULL,
	map_key CHARACTER VARYING (100) NOT NULL,
	viewcount INTEGER DEFAULT 0,
	map_style CHARACTER VARYING (100),
	lazyloading SMALLINT DEFAULT 0 NOT NULL,
	pt_sequence CHARACTER VARYING (4096),
	queueing SMALLINT DEFAULT 0,
	short_url CHARACTER VARYING (100),
	recommend_point INTEGER DEFAULT 0,
	share INTEGER DEFAULT 0 NOT NULL,
	permission INTEGER DEFAULT 1 NOT NULL,
	atc_seq BIGINT DEFAULT 0 NOT NULL,
	CONSTRAINT pk PRIMARY KEY(id)
)
COLLATE utf8_bin
REUSE_OID;

CREATE TABLE mm_hook(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
[name] character varying(100),
map_id bigint NOT NULL
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_okm_setting(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
setting_key character varying(200),
setting_value character varying(1073741823)
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_presentation_slide(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
x double,
y double,
scalex double,
scaley double,
rotate double,
showdepths integer
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_map_owner(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
mapid bigint NOT NULL,
mbr_no character varying(10)
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_user_config_field(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
[field] bigint NOT NULL,
descript character varying(255)
) COLLATE utf8_bin  REUSE_OID ;



CREATE TABLE mm_repository(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
mapid bigint NOT NULL,
mbr_no character varying(10),
filename character varying(255),
path character varying(255),
mime character varying(50),
filesize integer
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_user_config_data(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
mbr_no character varying(10),
fieldid bigint NOT NULL,
[data] character varying(255) NOT NULL
) COLLATE utf8_bin  REUSE_OID ;


CREATE TABLE mm_attribute(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
[name] character varying(255),
[value] character varying(1073741823),
map_id bigint NOT NULL
) COLLATE utf8_bin  REUSE_OID ;


CREATE TABLE mm_node(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
map_id bigint NOT NULL,
background_color character varying(10),
color character varying(10),
folded character varying(5),
[identity] character varying(50),
link character varying(2000),
[file] character varying(2000),
[note] character varying(2000),
[position] character varying(10),
style character varying(10),
text character varying(1073741823),
created bigint,
creator character varying(10),
creator_ip character varying(40),
modified bigint,
modifier character varying(10),
modifier_ip character varying(40),
hgap integer,
vgap integer,
vshift integer,
encrypted_content character varying(1073741823),
extra_data character varying(1073741823),
node_type character varying(40),
lft integer,
rgt integer,
parent_id bigint,
client_id character varying(40)
) COLLATE utf8_bin  REUSE_OID ;


CREATE TABLE mm_richcontent(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
[type] character varying(5),
content character varying(1073741823),
map_id bigint NOT NULL
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE mm_font(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
bold character varying(5),
italic character varying(5),
[name] character varying(50),
[size] integer,
map_id bigint
) COLLATE utf8_bin  REUSE_OID ;


CREATE TABLE mm_cloud(
id bigint AUTO_INCREMENT(1,1) NOT NULL,
node_id bigint NOT NULL,
color character varying(10),
map_id bigint NOT NULL
) COLLATE utf8_bin  REUSE_OID ;

CREATE TABLE [mm_map_history] (
	[id] BIGINT AUTO_INCREMENT(1, 1) NOT NULL,
	[map_id] BIGINT NOT NULL,
	[saved] BIGINT,
	[action_name] CHARACTER VARYING (100),
	[action_desc] CHARACTER VARYING (4000),
	[action_type] CHARACTER VARYING (50),
	[action_user] CHARACTER VARYING (50),
	[action_node_id] CHARACTER VARYING (50),
	CONSTRAINT [pk] PRIMARY KEY([id])
)
REUSE_OID,
COLLATE utf8_bin