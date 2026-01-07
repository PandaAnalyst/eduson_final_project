with count_sessions as (SELECT s.mentor_id,
        	    				s.mentor_domain_id,
        	    				
			            		(date_part('year', s.session_date_time) || '-'
								|| date_part('month', s.session_date_time) ||
								'-01' ):: date AS month,
			           			
								count(s.session_id) AS cnt
				         FROM sessions s
				         GROUP BY s.mentor_id, s.mentor_domain_id
				         			, (date_part('year', s.session_date_time) || '-'
									|| date_part('month', s.session_date_time) ||
									'-01' ):: date 
				         ORDER BY (count(s.session_id)) desc)
         
         ,rank_mentors as (select cs.mentor_id,
				         		cs.cnt,
				         		cs.month,
				         		dense_rank() OVER (ORDER BY cs.cnt DESC) AS rank,
				         		d.name
				         from count_sessions cs
				         left join domain as d
				         on d.id = cs.mentor_domain_id 
				         where cs.month = '2022-08-01')
         
         select *
         from rank_mentors as rm
         where rm.rank <= 5