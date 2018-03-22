/* A small data set*/

DELETE FROM follows;
DELETE FROM mentions;
DELETE FROM hashtags;
DELETE FROM retweets;
DELETE FROM tweets;
DELETE FROM users;

INSERT INTO users VALUES(0,'pike','Mona','mona@email.uk','London',0);
INSERT INTO users VALUES(1,'cod','Barney','barney@email.uk','York',0);
INSERT INTO users VALUES(2,'bird','Ariane','ariane@email.de','Berlin',+1);
INSERT INTO users VALUES(3,'tree','Marvin','marvin@email.de','Munich',+1);
INSERT INTO users VALUES(4,'snow','Pavel','pavel@email.ru','Moscow',+3);

INSERT INTO follows VALUES(0,1,'11-NOV-2014');
INSERT INTO follows VALUES(0,2,'17-JAN-2015');
INSERT INTO follows VALUES(3,2,'21-MAY-2004');
INSERT INTO follows VALUES(2,3,'10-JUN-2011');
INSERT INTO follows VALUES(1,2,'10-JUN-2013');

INSERT INTO hashtags VALUES('cold');
INSERT INTO hashtags VALUES('yummy');

INSERT INTO tweets VALUES(0,1,'10-FEB-2017','Good catch in the North Sea this morning. A bit cold but it''s worth it.', 0);
INSERT INTO tweets VALUES(1,0,'11-FEB-2017','Looking forward to heading up there for a trip of my own! #cold',0);
INSERT INTO tweets VALUES(2,1,'10-DEC-2016','My name has so many alternate spellings. I quite like Bjarne',2);
INSERT INTO tweets VALUES(3,1,'11-JAN-2017','No luck today, too cold to stay out long :/ #cold',3);
INSERT INTO tweets VALUES(4,2,'12-JAN-2017','Want a cracker? #yummy',4);
INSERT INTO tweets VALUES(5,1,'13-JAN-2017','When you lowkey want York to be called Jorvik again. #cold',5);
INSERT INTO tweets VALUES(6,2,'14-JAN-2017','YEAH! #yummy',6);
INSERT INTO tweets VALUES(7,3,'14-JAN-2017','You can tell it''s an apsen by the way it is.',7);
INSERT INTO tweets VALUES(8,1,'15-JAN-2017','u1tweet5',8);
INSERT INTO tweets VALUES(9,1,'15-JAN-2017','u1tweet6',9);

INSERT INTO mentions VALUES(3,'cold');
INSERT INTO mentions VALUES(4,'yummy');
INSERT INTO mentions VALUES(6,'yummy');

INSERT INTO retweets VALUES(2,5,'14-MAR-2017');
INSERT INTO retweets VALUES(2,7,'14-MAR-2017');
INSERT INTO retweets VALUES(3,7,'14-MAR-2017');

commit;