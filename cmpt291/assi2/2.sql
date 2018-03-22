prompt Question2-ehsueh
SELECT f1.flwer
FROM follows f1, follows f2, users u
WHERE sysdate - f1.start_date >= 180
AND f1.flwee = f2.flwee 
AND f2.flwer = u.usr
AND u.name = 'john doe';
