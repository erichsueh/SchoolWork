import sqlite3 as lite
import sys
#opens the sql connection
def opensql(database):
    #database = input('Please enter database name: ')
    con = lite.connect(database)
    cur = con.cursor()
    return(con,cur)

#creates the nodeCartesian table
def createtable(cur):
    print('CREATE TABLE nodeCartesian (id integer PRIMARY KEY, x float, y float);')
    #cur.execute('CREATE TABLE nodeCartesian (id integer PRIMARY KEY, x float, y float)')
    
    return()

#return min of both lat and lon
def queryminmax(cur):
    cur.execute("SELECT MIN(lat) FROM node")
    showresult = cur.fetchall()
    #print(showresult)
    minx = float(showresult[0][0])
    cur.execute("SELECT MIN(lon) FROM node")
    showresult = cur.fetchall()
    #print(showresult)
    miny=float(showresult[0][0])
    #print("min x:",minx,"min y:",miny)
    return(minx,miny)

def addstuff(minx,miny,cur):
    cur.execute("SELECT * FROM node")
    showresult = cur.fetchall()
    for a in showresult:
        mult = 111.325 *1000
        d = str((float(a[1])-minx)*mult)
        #print(d)
        c = str((float(a[2])-miny)*mult)
        #print(a[2],c)
        print('INSERT INTO nodeCartesian VALUES('+str(a[0])+','+d+','+c+');')
        #cur.execute('INSERT INTO nodeCartesian VALUES('+str(a[0])+','+d+','+c+')')
    return()

def main():
    print("BEGIN TRANSACTION;")
    database = sys.argv[1]
    con,cur = opensql(database)
    createtable(cur)
    minx,miny =queryminmax(cur)
    addstuff(minx,miny,cur)
    #con.commit()
    print("END TRANSACTION;")
    con.close()
    return()

main()
