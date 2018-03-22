prompt Question3-ehsueh

SELECT f1.flwer
FROM follows f1
WHERE f1.flwee IN(
      SELECT f2.flwee 
      FROM follows f2,users u1
      WHERE f2.flwer =u1.usr 
      AND u1.name = 'john doe')
GROUP BY f1.flwer
HAVING COUNT(*) = (
       SELECT COUNT(*) 
       FROM follows f3,users u2
       WHERE f3.flwer = u2.usr
       AND u2.name = 'john doe');
