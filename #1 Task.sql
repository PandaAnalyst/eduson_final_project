with cte_count_mentor as (
	select count(distinct(u_mentor.user_id) ) as count_mentor,
		(date_part('year', s.session_date_time) || '-'
		|| date_part('month', s.session_date_time) ||
		'-01' ):: date as month
	from sessions s                     
	join  users u_mentor                                                                                                                                             
	on u_mentor.user_id = s.mentor_id   
	group by month
	order by month  asc),
 cte_count_mentee as (
	select count(distinct(u_metee.user_id)) as count_mentee,
		(date_part('year', s.session_date_time) || '-'
		|| date_part('month', s.session_date_time) ||
		'-01' ):: date as month
	from sessions s                                                                                                                                                
	join  users u_metee                                                                                                                                                 
	on u_metee.user_id = s.mentee_id     
	group by month
	order by month  asc)
select mentor."month", mentor.count_mentor  ,
	--coalesce(LAG(mentor.count_mentor, 1) OVER (ORDER BY mentor.month),0) AS prev_count_mentor,
	mentor.count_mentor - LAG(mentor.count_mentor , 1) OVER (ORDER BY mentor.month) as diff_mentor, 
	mentee.count_mentee,
	--coalesce(LAG(mentee.count_mentee, 1) OVER (ORDER BY mentee.month),0) AS prev_count_mentee,
	mentee.count_mentee - LAG(mentee.count_mentee, 1) OVER (ORDER by mentee."month") as diff_mentee
from cte_count_mentor as mentor
join cte_count_mentee as mentee
on mentor."month" = mentee."month" 
