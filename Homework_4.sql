USE test;

ALTER TABLE users ADD COLUMN birthday DATE NOT NULL;

SELECT * FROM users;

UPDATE users SET birthday = (
SELECT DATE(FROM_UNIXTIME(ROUND((RAND() * (UNIX_TIMESTAMP('2000-01-01')-UNIX_TIMESTAMP('1980-01-01')))+UNIX_TIMESTAMP('1980-01-01'))))
) WHERE id > 0;


-- решение (считаем средний возраст пользователей в таблице users)
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday, NOW())), 0) AS AVG_Age FROM users;
