prompt Question1-ehsueh

SELECT DISTINCT t.writer
FROM tweets t, follows f
WHERE t.writer = f.flwee;
