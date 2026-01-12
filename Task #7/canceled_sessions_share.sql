WITH stutus_monthly AS
		(SELECT  (date_part('year', s.session_date_time) || '-'
		|| date_part('month', s.session_date_time) ||
		'-01' ):: date AS month,
		s.session_status AS status
		FROM sessions s )


SELECT finished.month AS Month,
		finished.count AS Finish_cnt,
		canceled.count  AS Cancel_cnt,
		(canceled.count::numeric / (finished.count + canceled.count)*100) AS Cancel_share
FROM (SELECT month, count(sm.status)
		FROM stutus_monthly sm
		WHERE sm.status = 'canceled'
		GROUP BY sm.month) canceled
LEFT JOIN (SELECT month, count(sm.status)
		FROM stutus_monthly sm
		WHERE sm.status = 'finished'
		GROUP BY sm.month) finished
ON finished.month = canceled.month
ORDER BY canceled.month