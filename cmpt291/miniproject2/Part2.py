from bsddb3 import db

DATABASE = 'tw.db'
database = db.DB()
database.set_flags(db.DB_DUP)
database.open(DATABASE,None,db.DB_HASH,db.DB_CREATE)
filename = "tweets.txt"
infile=open(filename,'r')
curs = database.cursor()
for line in infile:
    
    split = line.split(":")
    #print(split[1]+split[2])
    curs.put(bytes(split[0], encoding="UTF-8"),split[1]+split[2],db.DB_KEYFIRST)
curs.close()
database.close()

DATABASE = 'te.db'
database = db.DB()
database.set_flags(db.DB_DUP)
database.open(DATABASE,None,db.DB_BTREE,db.DB_CREATE)
filename = "terms.txt"
infile=open(filename,'r')
curs = database.cursor()
for line in infile:
    key,value = line.split(":")
    curs.put(bytes(key, encoding="UTF-8"),value,db.DB_KEYFIRST)
curs.close()
database.close()

DATABASE = 'da.db'
database = db.DB()
database.set_flags(db.DB_DUP)
database.open(DATABASE,None,db.DB_BTREE,db.DB_CREATE)
filename = "dates.txt"
infile=open(filename,'r')
curs = database.cursor()
for line in infile:
    key,value = line.split(":")
    curs.put(bytes(key, encoding="UTF-8"),value,db.DB_KEYFIRST)
curs.close()
database.close()
