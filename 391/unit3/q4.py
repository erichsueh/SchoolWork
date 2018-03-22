import time
import sqlite3 as lite
import sys
import random

def opensql(database):
    con = lite.connect(database)
    cur = con.cursor()
    return(con,cur)

def getminmax(cur):
    cur.execute("SELECT MAX(x) FROM nodeCartesian")
    showresult = cur.fetchall()
    maxx = float(showresult[0][0])
    cur.execute("SELECT MAX(y) FROM nodeCartesian")
    showresult = cur.fetchall()
    maxy = float(showresult[0][0])
    return(maxx,maxy)

def doquery(cur,l,tmaxx,tmaxy):
    looped = True
    #while looped == true(makes sur ethere's actually not 0)
    if looped == True:
        width = l * random.uniform(1,10)
        length = l * random.uniform(1,10)
        minx = random.uniform(0,tmaxx - width)
        miny = random.uniform(0,tmaxy - width)
        maxx = minx+width
        maxy = miny+length
        #print(tmaxx,tmaxy,maxx,maxy,minx,miny)
        startime = time.time()
        #print("SELECT COUNT(*) FROM indexTree WHERE minX >="+str(minx)+" AND maxX<="+str(maxx)+" AND minY>="+str(miny)+" AND maxY<="+str(maxy))
        cur.execute("SELECT COUNT(*) FROM indexTree WHERE minX >="+str(minx)+" AND maxX<="+str(maxx)+" AND minY>="+str(miny)+" AND maxY<="+str(maxy))
        #showresult = cur.fetchall()
        timetaken = time.time() - startime
        showresult = cur.fetchall()
        #print(showresult[0][0])
        if showresult[0][0] != 0:
            #if return not = null
            #set looped to false
            looped = False
    return(timetaken)

def main():
    database = sys.argv[1]
    l = int(sys.argv[2])
    k = int(sys.argv[3])
    #startime = time.time()
    #print(random.uniform(1,10))
    #print(time.time()-startime)
    con,cur = opensql(database)
    maxx,maxy = getminmax(cur)
    #print(maxx,maxy)
    totaltime = 0
    for i in range(k):
        #width = l * random.uniform(1,10)
        #length = l * random.uniform(1,10)
        #print(i,width,length)
        #initialx = random.uniform(0,maxx - width)
        #initialy = random.uniform(0,maxy - width)
        #print(initialx,initialy)
        totaltime = totaltime +doquery(cur,l,maxx,maxy)
        print("iter: ",i," current total time: " ,totaltime)
    print(totaltime/k)
    con.close()
    return()

main()
