USE vk;


SELECT * FROM messages;

/* �� ���� ������ ������������ 1 ������� ��������, ������� ������ ���� ������� � ��� */
SELECT 
	am.best_friend,
	SUM(am.counter) AS sum_counter
FROM (
	-- ��� ������ ���� ����� ������������ 1
	SELECT 
		(
			-- ������ ��� �����������
			SELECT CONCAT_WS(' ', first_name, last_name)
			FROM profiles p 
			WHERE p.user_id = m.from_user_id
		) AS best_friend,
		COUNT(1) AS counter
	FROM 
		messages m
	WHERE
		-- ��� ��������� ������������ 1
		m.to_user_id = 1
		AND m.from_user_id IN (
			-- ��� ������ ������������ 1
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
	-- ���� ������ ���� ����� ������������ 1
	SELECT 
		(
			-- ������ ��� ����������
			SELECT CONCAT_WS(' ', first_name, last_name)
			FROM profiles p 
			WHERE p.user_id = m.to_user_id
		) AS best_friend,
		COUNT(1) AS counter
	FROM 
		messages m
	WHERE
		-- ��� ��������� ������������ 1
		m.from_user_id = 1
		AND m.to_user_id IN (
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
		best_friend
) AS am -- ��� ��������� ����� ������������� 1 � ��� ��������
GROUP BY
	am.best_friend
ORDER BY
	sum_counter DESC
LIMIT 1

;
