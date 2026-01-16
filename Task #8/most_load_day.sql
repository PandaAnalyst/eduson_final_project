/*
Определите самый загруженный день недели для каждого направления 
    менторства. В результатах выведите тип направления, день недели
    и количество встреч
 */


WITH cnt_rank AS (SELECT d."name" 
		, s.session_date_time
		, count(s.session_id ) AS cnt
		, dense_rank() OVER (PARTITION BY d."name" ORDER BY count(s.session_id ) DESC) AS rank_cnt
FROM sessions s 
LEFT JOIN "domain" d 
ON d.id = s.mentor_domain_id 
WHERE s.session_status = 'finished' 
GROUP BY d."name" , s.session_date_time)

SELECT cr."name" AS "Name"
		, to_char(cr.session_date_time, 'Day') AS "Day"
		, cr.cnt AS "Count"
FROM cnt_rank cr
WHERE cr.rank_cnt = 1