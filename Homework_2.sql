USE vk;


SELECT * FROM messages;

/* Из всех друзей пользователя 1 находим человека, который больше всех общался с ним */
SELECT 
	am.best_friend,
	SUM(am.counter) AS sum_counter
FROM (
	-- кто больше всех пишет пользователю 1
	SELECT 
		(
			-- полное имя отправителя
			SELECT CONCAT_WS(' ', first_name, last_name)
			FROM profiles p 
			WHERE p.user_id = m.from_user_id
		) AS best_friend,
		COUNT(1) AS counter
	FROM 
		messages m
	WHERE
		-- все сообщения пользователю 1
		m.to_user_id = 1
		AND m.from_user_id IN (
			-- все друзья пользователя 1
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
		best_friend
	UNION ALL
	-- кому больше всех пишет пользователь 1
	SELECT 
		(
			-- полное имя получателя
			SELECT CONCAT_WS(' ', first_name, last_name)
			FROM profiles p 
			WHERE p.user_id = m.to_user_id
		) AS best_friend,
		COUNT(1) AS counter
	FROM 
		messages m
	WHERE
		-- все сообщения пользователя 1
		m.from_user_id = 1
		AND m.to_user_id IN (
			-- все друзья 1
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
		best_friend
) AS am -- все сообщения между пользователем 1 и его друзьями
GROUP BY
	am.best_friend
ORDER BY
	sum_counter DESC
LIMIT 1

;
