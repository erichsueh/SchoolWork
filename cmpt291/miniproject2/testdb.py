from bsddb3 import db
DATABASE = 'fruits.db'
database = db.DB()
database.open(DATABASE,None, db.DB_BTREE, db.DB_CREATE)

curs = database.cursor()

curs.put(b'apple', "red", db.DB_KEYFIRST)

database.put(b'pear', "green")

iter= curs.first()
while iter:
    print(iter)
    iter= curs.next()

result = database.get(b'pear')
print(result)
