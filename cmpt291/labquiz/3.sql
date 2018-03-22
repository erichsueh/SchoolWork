prompt Question3-ehsueh

SELECT a.name
FROM (SELECT c.name, (s.price_per_hour * o.hours) as spent 
     FROM c291.clients c,c291.services s,c291.orders o
     WHERE c.client_id = o.cl_id
     AND s.service_id = o.sr_id
     AND o.order_year = 2016)a
GROUP BY a.name
HAVING SUM(a.spent) >= 500;
