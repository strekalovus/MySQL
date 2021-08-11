USE vk;

SHOW TABLES;

/* корректируем таблицу типов сущностей */
DESC entity_types;
SELECT * FROM entity_types;

DROP TABLE IF EXISTS entity_types;
CREATE TABLE entity_types (
    name VARCHAR(128) NOT NULL PRIMARY KEY,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO entity_types (name) VALUES ('PROFILE');
INSERT INTO entity_types (name) VALUES ('COMMUNITY');
INSERT INTO entity_types (name) VALUES ('MEDIA');
INSERT INTO entity_types (name) VALUES ('POST');


/* корректируем таблицу лайков */
DESC likes;
SELECT * FROM likes;

ALTER TABLE likes DROP COLUMN entity_id;
ALTER TABLE likes ADD COLUMN entity_id INT UNSIGNED NOT NULL;

UPDATE likes SET from_user_id = ROUND(RAND()*100) WHERE id > 0;
UPDATE likes SET entity_id = ROUND(RAND()*99+1) WHERE id > 0;
/*UPDATE
	likes AS l
SET
	entity_name = (
	SELECT
		name 
	FROM 
		entity_types AS et
	WHERE
		l.entity_id = et.id
	)
WHERE
	id > 0;*/
UPDATE likes SET entity_id = 14 WHERE entity_name = 'PROFILE' AND id < 10;
UPDATE likes SET entity_id = 39 WHERE entity_name = 'PROFILE' AND id >= 20 AND id < 30;
UPDATE likes SET entity_id = 70 WHERE entity_name = 'PROFILE' AND id >= 40 AND id < 50;
UPDATE likes SET entity_id = 95 WHERE entity_name = 'PROFILE' AND id >= 60 AND id < 70;
UPDATE likes SET entity_id = 95 WHERE entity_name = 'PROFILE' AND id = 67;

ALTER TABLE likes DROP CONSTRAINT fk_likes_entity_types_id;
ALTER TABLE likes ADD CONSTRAINT fk_likes_entity_types_name FOREIGN KEY (entity_name) REFERENCES entity_types(`name`);


SELECT * FROM profiles;

-- выбираем самых молодых пользователей
SELECT 
	user_id,
	CONCAT_WS(' ', first_name, last_name),
	b_date
FROM 
	profiles
WHERE 
	user_id > 0
ORDER BY 
	b_date DESC 
LIMIT 10;


SELECT * FROM likes;
SELECT * FROM likes WHERE entity_name = 'PROFILE';

-- проверяем сколько лайков у профилей
SELECT
	entity_id,
	COUNT(1) AS counter
FROM
	likes
WHERE
	entity_name = 'PROFILE'
GROUP BY
	entity_id;


-- проверяем лайки 10ти самых молодых пользователей 
SELECT 
	entity_id,
	COUNT(1) AS counter,
	(
	SELECT 
		b_date 
	FROM 
		profiles p
	WHERE 
		p.id = l.entity_id AND 
		l.entity_name = 'PROFILE'
	) AS birthday
FROM likes l
GROUP BY birthday
ORDER BY birthday DESC
LIMIT 10
;


-- считаем общее количество лайков, которые получили 10 самых молодых пользователей
SELECT sum(counter)
FROM 
	(
	SELECT
		entity_id,
		COUNT(entity_id) AS counter,
		(
		SELECT
			b_date
		FROM 
			profiles p
		WHERE 
			p.id = l.entity_id AND
			l.entity_name = 'PROFILE'
		) AS birthday
	FROM likes l
	GROUP BY birthday
	ORDER BY birthday DESC
	LIMIT 10
	) AS a
;



