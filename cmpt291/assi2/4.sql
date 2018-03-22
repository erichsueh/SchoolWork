prompt Question4-ehsueh

SELECT DISTINCT t1.writer
FROM tweets t1, tweets t2
WHERE t1.writer = t2.writer 
AND t1.text LIKE '%edmonton%' 
AND t2.text LIKE '%edmonton%' 
AND t1.text != t2.text 
AND NOT EXISTS (
    SELECT *
    FROM follows 
    WHERE flwee = t1.writer);
