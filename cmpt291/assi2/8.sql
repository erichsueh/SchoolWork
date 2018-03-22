prompt Question8-ehsueh
SELECT rt.tdate, tr.writer, COUNT(rt.writer) as retweet
From retweets rt
Group by rt.writer, rt.tdate
