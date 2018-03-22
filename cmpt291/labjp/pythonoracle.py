import cx_Oracle

from lel import ass

con = cx_Oracle.connect("ehsueh",ass(),"gwynne.cs.ualberta.ca:1521/CRS")
curs = con.cursor()
print("Connected")
#curs.execute("create table movie(title char(20), movie_number  integer, primary key(movie_number))")
print("Table Created")
#curs.execute("insert into movie values(‘Dongerin’, 2)")
print("data inserted")
query = "select title, movie_number from movie"
curs.execute(query)
rows = curs.fetchall()
for row in rows:
    print(row[0]+' , ' + str(row[1]))
#rows = curs.fetchall()
#print(rows)
