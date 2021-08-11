SELECT * FROM messages;

-- 10 пользователей, которые проявляют наименьшую активность (от них получено наименьшее количество лайков и сообщений)
SELECT 
	CONCAT_WS(' ', first_name, last_name) AS username
FROM 
	profiles
WHERE 
	id IN  
	(
	SELECT 
		username
	FROM (
		SELECT 
			counter,
			username
		FROM
			(
			SELECT 
				COUNT(1) AS counter,
				(
				SELECT 
					p.id 
				FROM 
					profiles p
				WHERE 
					p.id = l.from_user_id 
				) AS username
			FROM 
				likes l
			GROUP BY 
				username
			) AS lc
		UNION
		SELECT 
			counter,
			username
		FROM
			(
			SELECT 
				COUNT(1) AS counter,
				(
				SELECT 
					p.id 
				FROM 
					profiles p
				WHERE 
					p.id = m.from_user_id 
				) AS username
			FROM 
				messages m
			GROUP BY 
				username
			) AS mc
		) AS ac
	GROUP BY 
		username
	ORDER BY 
		counter
)
LIMIT 10;


-- пользователи, которые не проявляют никакой активности (от них нет лайков и сообщений)
SELECT 
	CONCAT_WS(' ', first_name, last_name) AS username
FROM 
	profiles
WHERE 
	id NOT IN  
	(
	SELECT 
		username
	FROM
		(
		SELECT 
			COUNT(1) AS counter,
			(
			SELECT 
				p.id 
			FROM 
				profiles p
			WHERE 
				p.id = l.from_user_id 
			) AS username
		FROM 
			likes l
		GROUP BY 
			username
		) AS lc
	UNION
	SELECT 
		username
	FROM
		(
		SELECT 
			COUNT(1) AS counter,
			(
			SELECT 
				p.id 
			FROM 
				profiles p
			WHERE 
				p.id = m.from_user_id 
			) AS username
		FROM 
			messages m
		GROUP BY 
			username
		) AS mc
	)
;




