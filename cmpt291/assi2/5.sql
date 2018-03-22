prompt Question5-ehsueh
--SELECT r.writer, r.tdate
--FROM retweets r, follows f, tweets t
--WHERE r.usr = f.flwer 
--AND f.flwee = r.writer 
--AND t.writer = r.writer 
--AND t.tdate = r.tdate
--GROUP BY f.flwee
--Having COUNT(flwer)>=3;
SELECT r.writer, r.tdate
FROM (
     SELECT f.flwee
     FROM follows f
     GROUP BY f.flwee
     HAVING COUNT(flwer)>=3), 
