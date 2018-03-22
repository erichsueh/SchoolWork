prompt Question7-ehsueh
SELECT i.lname
FROM includes i, follows f
WHERE flwee = 'john doe' AND f.flwer = i.member
GROUP BY lname
HAVING COUNT(i.members) / (SELECT COUNT(*) FROM WHERE flwer = member GROUP BY lname)>=.5;
