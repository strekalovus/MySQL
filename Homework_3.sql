USE vk;

SHOW TABLES;
DESCRIBE profiles;

SELECT * FROM vk.communities;

USE INFORMATION_SCHEMA;

SHOW TABLES;

DESCRIBE TABLES;

SELECT * FROM vk.users LIMIT 10;

SELECT email FROM users WHERE email LIKE '%org';
SELECT phone FROM users WHERE phone LIKE '%%';
SELECT email FROM users WHERE REGEXP_LIKE(email, '^[A-Za-z_0-9]{6}@example\.org$');
SELECT phone FROM users WHERE REGEXP_LIKE(phone, '^\\+7[0-9]{10}$');

ALTER TABLE users ADD CONSTRAINT phone_check CHECK (REGEXP_LIKE(phone, '^\\+7[0-9]{10}$'));

ALTER TABLE users MODIFY phone VARCHAR(12);
UPDATE users SET phone = CONCAT('+7', 9000000000 + FLOOR(RAND() * 999999999)) WHERE id > 0;
SELECT CONCAT('+7', 9000000000 + FLOOR(RAND() * 999999999));

SELECT * FROM vk.profiles LIMIT 10;
ALTER TABLE profiles ADD COLUMN gender ENUM('M', 'F');


UPDATE profiles SET gender = (
SELECT
	CASE
		WHEN RAND() > 0.5 THEN 'M'
        ELSE 'F'
	END
) WHERE id > 0;


DROP TABLE IF EXISTS TEMPORARY;
CREATE TEMPORARY TABLE temp_gender (
	`value` CHAR(1)
);
INSERT INTO temp_gender (`value`) VALUE ('M');
INSERT INTO temp_gender (`value`) VALUE ('F');
SELECT * FROM temp_gender;

SELECT `value` FROM temp_gender ORDER BY RAND();

SHOW TABLES;




