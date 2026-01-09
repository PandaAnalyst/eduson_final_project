SELECT *
FROM (SELECT s.mentee_id,
            s.session_id,           
            row_number() over (partition by s.mentee_id order by (s.session_date_time)) as number_session,
            s.session_date_time::date as first_date,
            lag(s.session_date_time) over (partition by s.mentee_id order by (s.session_date_time))::date as next_date,
            s.session_date_time::date - lag(s.session_date_time) over (partition by s.mentee_id order by (s.session_date_time))::date as difference_dates
           FROM sessions s) as result
  WHERE result.number_session = 2
       