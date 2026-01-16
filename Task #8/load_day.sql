/*
 Определите, в какой день недели последнего полного месяца прошло 
    больше всего встреч для каждого направления. 
*/

WITH cnt_rank AS (SELECT d."name" 
		, s.session_date_time
		, count(s.session_id ) AS cnt
		, dense_rank() OVER (PARTITION BY d."name" ORDER BY count(s.session_id ) DESC) AS rank_cnt
FROM sessions s 
LEFT JOIN "domain" d 
ON d.id = s.mentor_domain_id 
WHERE s.session_status = 'finished' 
	AND s.session_date_time  BETWEEN '2022-08-01' AND '2022-08-31'
GROUP BY d."name" , s.session_date_time)

SELECT cr."name" AS "Name"
		, to_char(cr.session_date_time, 'Day') AS "Day"
		, cr.cnt AS "Count"
		, cr.rank_cnt
		,count(*) AS "Count_days" 
FROM cnt_rank cr
WHERE cr.rank_cnt = 1
GROUP BY cr."name"
		, to_char(cr.session_date_time, 'Day')
		, cr.cnt
		, cr.rank_cnt 
         