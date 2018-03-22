import cx_Oracle

from lel import ass

def dostuff(gender,tablename):
    curs.execute("SELECT * FROM c291.clients WHERE gender ='"+gender+"'")
    gotlist = curs.fetchall()
    #print(gotlist)
    rows = curs.description
    #print(rows)
    char30 = "char(30)"
    #', '.join(mylist)
    maketable = []
    #curs.execute("create table movie(title char(20), movie_number  integer, primary key(movie_number))")
    for i in rows:
        maketable.append(i[0] + " " + char30)
    collum ="create table " + tablename +" ("+(', '.join(maketable))+ ", primary key(" + rows[0][0] + "))"
    #print (collum)
    curs.execute(collum)
    print("tablecreated")
    #curs.execute("insert into movie values(‘Dongerin’, 2)")
    for i in gotlist:
        makei = []
        for d in i:
            makei.append(str(d))
        #print(makei)
        #print("'"+"','".join(makei)+"'")
        stringy = "insert into "+tablename+ " values("+"'"+"','".join(makei)+"'"+")"
        #print(stringy)
        curs.execute(stringy)
        print('inserted data')

con = cx_Oracle.connect("ehsueh",ass(),"gwynne.cs.ualberta.ca:1521/CRS")
curs = con.cursor()
print("Connected")
"""
maxP = (input("Please enter a maximum price per hour: "))
minP = input("Please enter a min price per hour: ")
curs.execute("SELECT s.name FROM c291.services s WHERE s.price_per_hour <="+maxP+"AND s.price_per_hour >="+minP+"ORDER BY s.price_per_hour")
print("query successful")
print("Names of services")
name = curs.fetchall()
for i in name:
    #can parse here, too lazy
    print(i)
"""

gender = (input("M or F: ")).upper()
#print(gender)
if gender == "M":
    curs.execute("drop table MaleClients")
    dostuff(gender,"MaleClients")
    
elif gender == "F":
    curs.execute("drop table FemaleClients")
    dostuff(gender,"FemaleClients")
else:
    print("wrong format exiting")

#dunno why this rollback shti dosn't work
con.commit()
con.close()
#curs.execute("create table movie(title char(20), movie_number  integer, primary key(movie_number))")
#print("Table Created")
#curs.execute("insert into movie values(‘Dongerin’, 2)")
#print("data inserted")
#query = "select title, movie_number from movie"
#curs.execute(query)
#rows = curs.fetchall()
#for row in rows:
#    print(row[0]+' , ' + str(row[1]))
#rows = curs.fetchall()
#print(rows)
