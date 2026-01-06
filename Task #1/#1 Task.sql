WITH cte_count_mentor AS ( -- кол-во уникальных менторов в месяце
	SELECT
		count(DISTINCT(u_mentor.user_id) ) AS count_mentor,
			(date_part('year', s.session_date_time) || '-'
			|| date_part('month', s.session_date_time) ||
			'-01' ):: date AS MONTH --месяц в виде '2021-12-31'
	FROM
		sessions s
	JOIN users u_mentor                                                                                                                                             
		ON
		u_mentor.user_id = s.mentor_id
	GROUP BY
		MONTH
	ORDER BY
		MONTH ASC),

	cte_count_mentee AS (-- кол-во уникальных подопечных в месяце
	SELECT
		count(DISTINCT(u_metee.user_id)) AS count_mentee,
			(date_part('year', s.session_date_time) || '-'
			|| date_part('month', s.session_date_time) ||
			'-01' ):: date AS MONTH
	FROM
		sessions s
	JOIN users u_metee                                                                                                                                                 
		ON
		u_metee.user_id = s.mentee_id
	GROUP BY
		MONTH
	ORDER BY
		MONTH ASC)

		SELECT
	mentor."month",
	mentor.count_mentor ,
	--coalesce(LAG(mentor.count_mentor, 1) OVER (ORDER BY mentor.month),0) AS prev_count_mentor,
	mentor.count_mentor - LAG(mentor.count_mentor , 1) OVER (
	ORDER BY mentor.month) AS diff_mentor, 
	mentee.count_mentee,
	--coalesce(LAG(mentee.count_mentee, 1) OVER (ORDER BY mentee.month),0) AS prev_count_mentee,
	mentee.count_mentee - LAG(mentee.count_mentee, 1) OVER (
	ORDER BY mentee."month") AS diff_mentee
FROM
	cte_count_mentor AS mentor
JOIN cte_count_mentee AS mentee
ON
	mentor."month" = mentee."month"
