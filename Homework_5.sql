USE test;


SELECT * FROM users;

-- решение (Считаем количество дней рождения, которые приходятся на каждый из дней недели с учётом, что необходимы дни недели текущего года, а не года рождения.)
SELECT 
    WEEKDAY(DATE_FORMAT(birthday, '2021-%m-%d')) as `weekday`,
    COUNT(*) AS 'quantity_bday'
FROM users
GROUP BY WEEKDAY(DATE_FORMAT(birthday, '2021-%m-%d'))
ORDER BY `weekday`;
