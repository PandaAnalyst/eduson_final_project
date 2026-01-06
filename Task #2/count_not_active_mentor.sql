WITH cte AS(SELECT u.user_id, 
	sum(CASE s.session_status WHEN 'finished' THEN 1 WHEN 'canceled' THEN 0 END) AS sum_finished_sessions
FROM users u
JOIN sessions s
ON u.user_id = s.mentor_id
GROUP BY u.user_id)

SELECT
	count(*) AS count_not_active_mentor
FROM
	cte
WHERE
	cte.sum_finished_sessions < 1
	--having sum(case s.session_status when 'finished' then 1 when 'canceled' then 0 end) < 1
