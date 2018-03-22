#imports
import xml.etree.ElementTree as ET
import sqlite3 as lite

def gettree():
    #todo open the xml file with this fucntion
    openfiletree = input("Enter the osm file name: ")
    #openfiletree = 'quad_and_comp_sci.osm.xml'
    edmontontree = ET.parse(openfiletree)
    return(edmontontree)

def opensql():
    con = lite.connect('test.db')
    cur = con.cursor()
    #cur.execute('SELECT SQLITE_VERSION()')
    #data = cur.fetchone()
    #print(data)
    return(con,cur)

def initializetables(cur):
    cur.execute('PRAGMA foreign_keys=TRUE')
    cur.execute('CREATE TABLE node (id integer PRIMARY KEY, lat float, lon float)')
    cur.execute('CREATE TABLE way (id integer PRIMARY KEY, closed boolean)')
    cur.execute('CREATE TABLE waypoint (wayid integer, ordinal integer, nodeid integer, FOREIGN KEY(wayid) REFERENCES way(id) ON DELETE CASCADE, FOREIGN KEY(nodeid) REFERENCES node(id) ON DELETE CASCADE)')
    cur.execute('CREATE TABLE nodetag (id integer, k text, v text, FOREIGN KEY(id) REFERENCES node(id) ON DELETE CASCADE)')
    cur.execute('CREATE TABLE waytag  (id integer, k text, v text, FOREIGN KEY(id) REFERENCES way(id) ON DELETE CASCADE)')
    print("added tables")
    return()
    
def insertsql(root,cur):
    #for loop to insert ways
    #for node in root.iter('node'):
        try:
            cur.execute('INSERT INTO node VALUES('+node.get('id')+','+node.get('lat')+','+node.get('lon')+')')
            for nodetag in node.iter():
                if nodetag.tag == "tag":
                    try:
                        cur.execute('INSERT INTO nodetag(id,k,v) VALUES("'+node.get('id')+'","'+nodetag.get('k')+'","'+nodetag.get('v')+'")')
                    except:
                        print("fail adding nodetags")
        except:
            print("Error inserting node!")
    print('done inserting node and nodetag', cur.execute("Select * FROM node"))
    #print(cur.fetchall())

    for way in root.iter('way'):
        #print('INSERT INTO way VALUES')

        ordinalc = 0
        first = "none"
        try:
            cur.execute('INSERT INTO way VALUES('+way.get('id')+',0)')
            for waytag in way.iter():
                if waytag.tag == "tag":
                    try:
                        cur.execute('INSERT INTO waytag(id,k,v) VALUES("'+way.get('id')+'","'+waytag.get('k')+'","'+waytag.get('v')+'")')
                    except:
                        print("failure inserting into waytag")
                elif waytag.tag =="nd":
                    try:
                        #print('INSERT INTO waypoint(wayid,ordinal,nodeid) VALUES("'+way.get('id')+'","'+str(ordinalc)+'","'+waytag.get('ref')+'")')
                        cur.execute('INSERT INTO waypoint(wayid,ordinal,nodeid) VALUES("'+way.get('id')+'","'+str(ordinalc)+'","'+waytag.get('ref')+'")')
                        if first == "none":
                            first =waytag.get('ref')
                            
                        last = waytag.get('ref')
                        ordinalc += 1
                    except:
                        print("failed inserting into waypoint because it dosn't exist")
<<<<<<< HEAD
=======
                    
>>>>>>> 37230dba847a305966e446f5ca9e5c7c42bf5157
            if last == first:
                #print("CLOSE ME",last,"first = ",first)
                cur.execute('UPDATE way SET closed = "1" WHERE id = '+way.get('id'))
        except:
            print("fail adding into ways")
            
    print('done adding waypoint waytag')
    return()
    
def triggers(cur):
    #do the triggers here
    cur.execute('CREATE TRIGGER update_way BEFORE UPDATE ON way BEGIN SELECT RAISE(ABORT, "Ordinals violated! Not allowed to update way"); END;')
    cur.execute('CREATE TRIGGER update_waypoint BEFORE UPDATE ON waypoint BEGIN SELECT RAISE(ABORT, "Ordinals violated! Not allowed to update waypoints"); END;')
    cur.execute('CREATE TRIGGER insert_waypointlast BEFORE INSERT ON waypoint WHEN new.ordinal >= (SELECT MAX(w.ordinal) FROM waypoint w WHERE new.wayid = w.wayid) BEGIN SELECT RAISE(ABORT, "Ordinals violated! Not allowed to insert after the last ordinal"); END;')
    cur.execute('CREATE TRIGGER insert_waypointmid BEFORE INSERT ON waypoint WHEN new.ordinal = (SELECT w.ordinal FROM waypoint w WHERE new.wayid = w.wayid AND w.ordinal = new.ordinal) BEGIN SELECT RAISE(ABORT, "Ordinals violated! Ordinal already exists in table"); END;')
    cur.execute('CREATE TRIGGER delete_waypointlast BEFORE DELETE ON waypoint WHEN old.ordinal >= (SELECT MAX(w.ordinal) FROM waypoint w WHERE old.wayid = w.wayid) BEGIN SELECT RAISE(ABORT, "Ordinals violated! Not allowed to delete last ordinal"); END;')
    cur.execute('CREATE TRIGGER insert_waypointstart BEFORE INSERT ON waypoint WHEN new.ordinal <= 0 BEGIN SELECT RAISE(ABORT, "Ordinals violated! Not allowed to insert first or before first ordinal"); END;')
    cur.execute('CREATE TRIGGER delete_waypointstart BEFORE DELETE ON waypoint WHEN old.ordinal <= 0 BEGIN SELECT RAISE(ABORT, "Ordinals violated! not allowed to delete first ordinal"); END;')
    return()



def main():
    tree = gettree()
    root = tree.getroot()
    con,cur = opensql()
    initializetables(cur)
    insertsql(root,cur)
    triggers(cur)
    con.commit()
    con.close()
    return()

main();
