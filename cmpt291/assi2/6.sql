prompt Question6-ehsueh

SELECT tw.writer, tw.tdate, tw.text
FROM(
	SELECT wt.writer,wt.tdate, rank() over (order by rtweet desc) as rnk
	FROM (
	     SELECT rt.tdate, rt.writer, count(rt.writer) as rtweet 
	     FROM retweets rt 
	     GROUP BY rt.writer, rt.tdate)wt
	     )nt, tweets tw
WHERE rnk <= 3 
AND tw.writer = nt.writer 
AND tw.tdate = nt.tdate;
