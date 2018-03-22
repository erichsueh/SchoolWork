prompt Question9-ehsueh

CREATE VIEW tStat(writer, tdate, text, rep_cnt, ret_cnt, sim_cnt)
AS SELECT t.writer, t.tdate, t.text,
FROM(
	Select rt.tdate, rt.writer, COUNT(rt.writer) as rtweet
	From retweets rt
	Group by rt.writer, rt.tdate)st, tweets
