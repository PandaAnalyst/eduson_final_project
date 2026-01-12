SELECT d.name, count(s.session_id)
FROM sessions s 
LEFT JOIN domain d 
ON d.id = s.mentor_domain_id 
WHERE s.session_status = 'canceled'
GROUP BY d.name
ORDER BY 2 DESC