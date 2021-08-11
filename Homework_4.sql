-- определяем кто больше поставил лайков (всего) - мужчины или женщины
SELECT 
	gender 
FROM 
	(
	SELECT 
		entity_id,
		COUNT(1) AS counter,
		(
		SELECT 
			gender 
		FROM 
			profiles p
		WHERE 
			p.id = l.entity_id 
		) AS gender
	FROM likes l
	GROUP BY gender
	ORDER BY counter DESC
	LIMIT 1
	) AS g;