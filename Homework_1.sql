USE vk;

SET FOREIGN_KEY_CHECKS=1;

/* ������������ ������� ��������� */
SELECT * FROM messages;
UPDATE messages SET from_user_id = ROUND(RAND()*100) WHERE id > 0;
UPDATE messages SET to_user_id = ROUND(RAND()*100) WHERE id > 0;
UPDATE messages SET sent_flag = ROUND(RAND()) WHERE id > 0;
UPDATE messages SET recieved_flag = ROUND(RAND()*sent_flag) WHERE id > 0;
UPDATE messages SET edited_flag = ROUND(RAND()*sent_flag) WHERE id > 0;
UPDATE messages SET to_user_id = 1 WHERE id < 15;
UPDATE messages SET from_user_id = 1 WHERE id > 70 AND to_user_id < 20;

/* ������������ ������� ������ */
SELECT * FROM friendship;
UPDATE friendship SET user_id = 1 WHERE user_id < 10;
UPDATE friendship SET friend_id = 1 WHERE user_id > 10 AND user_id <= 20;
UPDATE friendship SET friend_id = 10 WHERE user_id = 1 AND friend_id = 1;

/* ������������ ������� �������� */
SELECT * FROM profiles;
UPDATE profiles SET gender = ROUND(RAND()+1) WHERE id > 0;

/* ������������ ������� ������ ��������� � ������������� */
SELECT * FROM communities_users;
SELECT * FROM communities_users WHERE user_id = 1;
UPDATE communities_users SET user_id = 1 WHERE community_id < 30;

/* ������������ ���������� ��������� */
DESC visibility;
SELECT * FROM visibility;

DROP TABLE IF EXISTS visibility;
CREATE TABLE visibility (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    value VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO visibility (value) VALUES ('ALL');
INSERT INTO visibility (value) VALUES ('USERS_ONLY');
INSERT INTO visibility (value) VALUES ('NOBODY');
INSERT INTO visibility (value) VALUES ('FRIENDS_ONLY');

/* ������������ ������� ������ */
SELECT * FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA ='vk' AND CONSTRAINT_NAME <>'PRIMARY' AND REFERENCED_TABLE_NAME IS NOT NULL;

ALTER TABLE posts DROP CONSTRAINT fk_posts_visibility;
ALTER TABLE posts DROP COLUMN visibility;
ALTER TABLE posts ADD COLUMN visibility_id INT UNSIGNED NOT NULL;

DESC posts;
SELECT * FROM posts;
UPDATE posts SET id = user_id WHERE id > 0;
UPDATE posts SET user_id = ROUND(RAND()*100) WHERE id > 0;
UPDATE posts SET community_id = ROUND(RAND()*100) WHERE id > 0;
UPDATE posts SET visibility_id = (
	SELECT
		id
	FROM
		visibility
	WHERE
		id > RAND()*4
	LIMIT 1
	)
WHERE id > 0;
UPDATE posts SET user_id = 1 WHERE id > 90;

ALTER TABLE posts ADD CONSTRAINT fk_posts_visibility_id FOREIGN KEY (visibility_id) REFERENCES visibility(`id`);

/* ������������ ������� ����� ����� */
SELECT * FROM media_types;
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    media_type_name VARCHAR(100) NOT NULL
);

INSERT INTO media_types (media_type_name) VALUES ('VIDEO');
INSERT INTO media_types (media_type_name) VALUES ('AUDIO');
INSERT INTO media_types (media_type_name) VALUES ('IMAGE');
INSERT INTO media_types (media_type_name) VALUES ('GIF');

ALTER TABLE media_files DROP COLUMN media_type;
ALTER TABLE media_files ADD COLUMN media_type INT UNSIGNED NOT NULL;
ALTER TABLE media_files ADD CONSTRAINT fk_media_type_id FOREIGN KEY (media_type) REFERENCES media_types(`id`);

/* ������������ ������� ����� */
SELECT * FROM media_files;

ALTER TABLE media_files ADD COLUMN metadata JSON;

-- {"name" : "", "extention" : "", "size" : "" }

SELECT SUBSTRING(MD5(RAND()) FROM 1 FOR 10);

INSERT INTO media_files (media_type) VALUES (ROUND(RAND()*3+1));

UPDATE media_files SET media_type = ROUND(RAND()*3+1) WHERE id > 0;
UPDATE media_files SET link = "http://my-server/dir/" WHERE id > 0;
UPDATE media_files SET user_id = ROUND(RAND()*100) WHERE id > 0;
UPDATE media_files SET metadata = concat(
	'{"name" : "',
	SUBSTRING(MD5(RAND()) FROM 1 FOR 10),
	'", "extention" : "',
	CASE media_type
		WHEN 1 THEN 'avi'
		WHEN 2 THEN 'wav'
		WHEN 3 THEN 'png'
		ELSE 'gif'
	END,
	'", "size" : "',
	ROUND(RAND()*1000000),
	'KB" }'
	) WHERE id > 0;

SELECT
	concat_ws('.', metadata->>"$.name", metadata->>"$.extention")
FROM
	media_files
LIMIT 1;

UPDATE media_files SET link = concat(
	link,
	metadata->>"$.name",
	'.',
	metadata->>"$.extention"
);


/* ������� ������������� ��������� �� ������ */

SELECT * FROM users WHERE id = 1;
SELECT * FROM friendship WHERE id < 10 ORDER BY user_id;

-- ������� ������ ������������

-- �������� ������������� ������� �� ������ �� 1
SELECT 
	*
FROM
	friendship
WHERE 
	user_id = 1
	AND friendship_status = 1
	AND accepted_at IS NOT NULL;

-- �������� ������������� ������� �� ������ �� ������ ������������� � 1
SELECT 
	*
FROM
	friendship
WHERE 
	friend_id = 1
	AND friendship_status = 1
	AND accepted_at IS NOT NULL;

-- ��� ������ 1
SELECT 
	friend_id
FROM
	friendship
WHERE 
	user_id = 1
	AND friendship_status = 1
	AND accepted_at IS NOT NULL
UNION 
SELECT 
	user_id AS friend_id
FROM
	friendship
WHERE 
	friend_id = 1
	AND friendship_status = 1
	AND accepted_at IS NOT NULL;

-- �������� ���������
SELECT * FROM messages;
UPDATE messages SET from_user_id = (
	SELECT 
		friend_id
	FROM
		friendship
	WHERE 
		user_id = 1
		AND friendship_status = 1
		AND accepted_at IS NOT NULL
	UNION 
	SELECT 
		user_id AS friend_id
	FROM
		friendship
	WHERE 
		friend_id = 1
		AND friendship_status = 1
		AND accepted_at IS NOT NULL
	ORDER BY RAND()
	LIMIT 1
)
WHERE 
	to_user_id = 1;

SELECT 
	(
		-- ������ ��� �����������
		SELECT CONCAT_WS(' ', first_name, last_name)
		FROM profiles p 
		WHERE p.user_id = m.from_user_id
	) AS from_user_name,
	(
		-- ������ ��� ����������
		SELECT CONCAT_WS(' ', first_name, last_name)
		FROM profiles p 
		WHERE p.user_id = m.to_user_id
	) AS to_user_name,
	COUNT(1) AS counter
FROM 
	messages m
WHERE
	-- �������� ������������� ��������� ������������ 1
	m.to_user_id = 1
	AND m.sent_flag = 0
	AND m.from_user_id IN (
		-- ��� ������ 1
		SELECT 
			friend_id
		FROM
			friendship
		WHERE 
			user_id = 1
			AND friendship_status = 1
			AND accepted_at IS NOT NULL
		UNION 
		SELECT 
			user_id AS friend_id
		FROM
			friendship
		WHERE 
			friend_id = 1
			AND friendship_status = 1
			AND accepted_at IS NOT NULL
)
GROUP BY
	to_user_id, from_user_id
ORDER BY 3 DESC
;


/* �����: ����� 1, ����� ������ 1, ����� ��������� 1 */

-- ����� ��������� ������������ 1
SELECT
	(
		SELECT name
		FROM communities c 
		WHERE c.id = p.community_id
	) AS author,
	created_at,
	post_body
FROM 
	posts p 
WHERE community_id  IN (
	SELECT community_id 
	FROM communities_users
	WHERE user_id = 1
);

-- ����� ������������ 1
SELECT
	(
		-- ������ ��� �����������
		SELECT CONCAT_WS(' ', first_name, last_name)
		FROM profiles pr 
		WHERE pr.user_id = posts.user_id
	) AS author,
	created_at,
	post_body
FROM 
	posts
WHERE user_id = 1;

-- ����� ������ ������������ 1
WITH friends AS (
	-- ��� ������ 1
	SELECT 
		friend_id
	FROM
		friendship
	WHERE 
		user_id = 1
		AND friendship_status = 1
		AND accepted_at IS NOT NULL
	UNION 
	SELECT 
		user_id AS friend_id
	FROM
		friendship
	WHERE 
		friend_id = 1
		AND friendship_status = 1
		AND accepted_at IS NOT NULL
)
SELECT
	(
		-- ������ ��� �����������
		SELECT CONCAT_WS(' ', first_name, last_name)
		FROM profiles pr 
		WHERE pr.user_id = posts.user_id
	) AS author,
	created_at,
	post_body
FROM 
	posts
WHERE 
	user_id IN (
	SELECT friend_id FROM friends -- ���������� � ������������ ����������
	);

/* ��� ����� */
-- ����� ������ ������������ 1
WITH friends AS (
	-- ��� ������ 1
	SELECT 
		friend_id
	FROM
		friendship
	WHERE 
		user_id = 1
		AND friendship_status = 1
		AND accepted_at IS NOT NULL
	UNION 
	SELECT 
		user_id AS friend_id
	FROM
		friendship
	WHERE 
		friend_id = 1
		AND friendship_status = 1
		AND accepted_at IS NOT NULL
)
SELECT
	(
		-- ������ ��� �����������
		SELECT CONCAT_WS(' ', first_name, last_name)
		FROM profiles pr 
		WHERE pr.user_id = posts.user_id
	) AS author,
	created_at,
	post_body
FROM 
	posts
WHERE 
	user_id IN (
	SELECT friend_id FROM friends -- ���������� � ������������ ����������
	)
UNION
-- ����� ������������ 1
SELECT
	(
		-- ������ ��� �����������
		SELECT CONCAT_WS(' ', first_name, last_name)
		FROM profiles pr 
		WHERE pr.user_id = posts.user_id
	) AS author,
	created_at,
	post_body
FROM 
	posts
WHERE user_id = 1
UNION 
-- ����� ��������� ������������ 1
SELECT
	(
		SELECT name
		FROM communities c 
		WHERE c.id = p.community_id
	) AS author,
	created_at,
	post_body
FROM 
	posts p 
WHERE community_id  IN (
	SELECT community_id 
	FROM communities_users
	WHERE user_id = 1
)
ORDER BY created_at DESC;
