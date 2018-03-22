import sqlite3 as lite
import sys

#global node
#global point
#global nearest neighbour


def opensql(database):
    con = lite.connect(database)
    cur = con.cursor()
    return(con,cur)

def objectDIST(point,node,branch,rect):
    #object dist do here:
    print("do stuff")

def genBranchList(point,node,branchlist):
    #generate active branch list
    print("do stuff")

def sortBranchList(branchlist):
    #sort abl based on ordering metric values

def pruneBranchList(node,point,nearest,branchlist):
    #perform downwrd pruning

def nearestneighboursearch(newnode,point,nearest):
    #recursivly do here visit child node
    
    
def main():
    print("main!")
    database = sys.argv[1]
    x = sys.argv[2]
    y = sys.argv[3]
    k = sys.argv[4]
    con,cur = opensql(database)
    #find root node
    #our point is (x,y)
    
main()
