prompt Question2-ehsueh

SELECT DISTINCT s.name
FROM c291.services s, c291.clients c1, c291.clients c2, c291.orders o1, c291.orders o2
WHERE o1.sr_id = o2.sr_id
AND c1.client_id = o1.cl_id
AND c2.client_id = o2.cl_id
AND c1.gender <> c2.gender
AND s.service_id = o2.sr_id;
