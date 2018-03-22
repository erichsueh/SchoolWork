import sqlite3 as lite
import sys
#opens the sql connection
def opensql(database):
    #database = input('Please enter database name: ')
    con = lite.connect(database)
    cur = con.cursor()
    return(con,cur)
            
def createtable(cur):
    print('CREATE TABLE areaMBR(id integer PRIMARY KEY, minX float,maxX float, minY float,maxY float);')
    #cur.execute('CREATE TABLE nodeCartesian (id integer PRIMARY KEY, x float, y float)')
    return()

#find all closd ways (DEPRECATED)
def queryclosed(cur):
    cur.execute("SELECT id FROM way WHERE closed == 1")
    showresult = cur.fetchall()
    #print(showresult)
    return(showresult)

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

#find minx miny max x max y on closed way to make rect (DEPRECATED)
def querystuff(cur,wayid):
    #print("select" + str(wayid))
    cur.execute("SELECT nodeid FROM waypoint w, node n WHERE w.wayid='"+str(wayid)+"'")
    showresult = cur.fetchall()
    maxX = 0
    minX = 0
    maxY = 0
    minY = 0
    first = True
    for a in showresult:
        #print(a[0])
        cur.execute("SELECT lat,lon FROM node WHERE id='"+str(a[0])+"'")
        otherresult = cur.fetchall()
        #print(otherresult)
        if first == True:
            maxX = float(otherresult[0][0])
            minX = float(otherresult[0][0])
            maxY = float(otherresult[0][1])
            minY = float(otherresult[0][1])
            first = False
        else:
            if maxX < otherresult[0][0]:
                maxX = float(otherresult[0][0])
            if minX > otherresult[0][0]:
                minX = float(otherresult[0][0])
            if maxY < otherresult[0][1]:
                maxY = float(otherresult[0][1])
            if minY > otherresult[0][1]:
                minY = float(otherresult[0][1])
    #print(showresult)
    #print(maxX,minX,maxY,minY)
    return(minX, maxX, minY, maxY)

def doquery(cur):
    cur.execute("Select wa.id,min(n.lat), max(n.lat),min(n.lon) ,max(n.lon)FROM waypoint wp, node n, way wa WHERE wp.wayid = wa.id AND wa.closed = 1 AND n.id = nodeid GROUP BY wp.wayid;")
    result= cur.fetchall()
    return(result)

def addstuff(cur,wayid,minX,maxX,minY,maxY,totalx,totaly):
    mult = 11.325 * 1000
    minX = str((float(minX)-totalx)*mult)
    maxX = str((float(maxX)-totalx)*mult)
    minY = str((float(minY)-totaly)*mult)
    maxY = str((float(maxY)-totaly)*mult)
    #print(minX,maxX,minY,maxY)
    #print("wayid:"+str(wayid)+"min,max X Y" + str(minX),+str(maxX)+str(minY)+str(maxY))
    print('INSERT INTO areaMBR VALUES('+str(wayid)+','+minX+','+maxX+','+minY+',' + maxY+');')
    return()


def main():
    print("BEGIN TRANSACTION;")
    database = sys.argv[1]
    con,cur = opensql(database)
    createtable(cur)
    #closedways = queryclosed(cur)
    totalx,totaly= queryminmax(cur)
    '''
    for way in closedways:
        #print(way[0])
        minX,maxX,minY,maxY = querystuff(cur,way[0])
        addstuff(cur,way[0],minX,maxX,minY,maxY,totalx,totaly)
    '''
    result = doquery(cur)
    for i in result:
        addstuff(cur,i[0],i[1],i[2],i[3],i[4],totalx,totaly)
    #print(result)
    #con.commit()
    print("END TRANSACTION;")
    con.close()
    return()

main()
                                
