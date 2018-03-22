import re
from bsddb3 import db


def doDates(term,query):
    """Returns the ID of the tweets which contain the date in the tweet
    if its greater then, find the date, then keep going until the end
    if its less than, find the date and keep going backwards until the beginning
    else, find the matching dates and stop there
    """
    database = db.DB()
    database.open("da.idx")
    curs = database.cursor()
    retSet = set()
    
    if ">" in query:
        result = curs.set(bytes(term, encoding="UTF-8"))
        while True:
            if result == None:
                break
            retSet.add(str(result[1],  encoding="UTF-8"))
            result = curs.next()
            
    elif "<" in query:
        result = curs.set(bytes(term, encoding="UTF-8"))
        while True:
            if result == None or result[0] != bytes(pterm, encoding="UTF-8"):
                break
            retSet.add(str(result[1],  encoding="UTF-8"))
            result = curs.next()        
        
        result = curs.set(bytes(term, encoding="UTF-8"))
        while True:
            if result == None:
                break
            retSet.add(str(result[1],  encoding="UTF-8"))
            result = curs.prev()
            
    else:
        result = curs.set(bytes(term, encoding="UTF-8"))
        while True:
            if result == None or result[0] != bytes(pterm, encoding="UTF-8"):
                break
            retSet.add(str(result[1],  encoding="UTF-8"))
            result = curs.next()
            
    curs.close()
    database.close()
    return retSet    

def _showAll(term):
    """Prints everything in the database"""
    s=set()
    database = db.DB()
    database.set_flags(db.DB_DUP)
    database.open("te.idx", None, db.DB_BTREE)
    curs = database.cursor()
    res = curs.first()
    while res:
        print(res)
        res = curs.next()
    curs.close()
    database.close()   

def fullSearch(term, prefixes='lnt'):
    """TODO Write Docstring"""
    database = db.DB()
    database.open("te.idx")
    curs = database.cursor()
    retSet = set()
    for prefix in prefixes:
        pterm = prefix+'-'+term
        if "%" in term:
            pterm = pterm[:-1]            
            percent = True
        else:
            percent = False
        result = curs.set_range(bytes(pterm, encoding="UTF-8"))
        while True:
            if result == None or result[0] != bytes(pterm, encoding="UTF-8"):
                break
            print(str(result[1],  encoding="UTF-8"))
            retSet.add(str(result[1],  encoding="UTF-8"))
            result = curs.next()
        if percent == True:
            while True:
                print(pterm,str(result[0], encoding="UTF-8"), str(result[0], encoding="UTF-8").startswith(pterm))
                if result == None or not str(result[0], encoding="UTF-8").startswith(pterm):
                    break
                retSet.add(str(result[1],  encoding="UTF-8"))
                result = curs.next()
    curs.close()
    database.close()
    return retSet




def isAtTag(line, index, tag, isReading):
    """Returns true if we have encountered an xml tag"""
    if isReading:
        tag = '</'+tag+'>'
    else:
        tag = '<'+tag+'>'
    counter = 0
    while counter < len(tag):
        if tag[counter] != line[index+counter]:
            return False
        counter += 1
    return True
        

def findAtTag(line, tag):
    """Returns the data location within the given tag in the given string"""
    string = ''
    i = 0
    isReading = False
    while i < len(line):
        if isReading and isAtTag(line, i, tag, isReading):
            break
        
        if isReading:
            string += line[i]

        if isAtTag(line, i, tag, isReading):
            isReading = True
            i += len(tag)+2
            continue
        i += 1
    return string

def xmlToReadable(string):
    """Returns a readable reformat of a given xml string"""
    readable = "Tweet ID: "+findAtTag(string, 'id')
    readable += '\n"'+findAtTag(string, 'text')+'"'
    readable += "\nCreated On: "+findAtTag(string, 'created_at')+" by user:"
    readable += "\n\tName: "+findAtTag(string, 'name')
    readable += "\n\tLocation: "+findAtTag(string, 'location')
    readable += "\n\tDescription: "+findAtTag(string, 'description')
    readable += "\n\tURL: "+findAtTag(string, 'url')
    return readable

#print(xmlToReadable("<status> <id>000000019</id> <created_at>2012/03/04</created_at> <text>@fitbit Why is the iPhone app not available on the iTunes store in Germany? Want it.</text> <retweet_count>0</retweet_count> <user> <name>Siggi Eggertsson</name> <location>Berlin, Germany</location> <description></description> <url>http://www.siggieggertsson.com</url> </user> </status>"))

def main():
    """Provides an interface for the user to query the database"""
    delimiters = [':','<','>']
    regexPattern = '|'.join(map(re.escape, delimiters))
    
    while True:
        # Get queries
        queries = input("Please enter your query: (or 'exit' to exit)\n").lower()
        if queries == 'exit' or queries == 'close':
            break

        # Process queries
        queries = queries.split() # TODO Remember to handle cases of invalid input
        IDs = set()
        for query in queries:
            sides = re.split(regexPattern, query)
            if len(sides) < 2: # We can find the term in name text or location
                if len(IDs) == 0:
                    IDs.update(fullSearch(sides[0]))
                else:
                    IDs = IDs.intersection(fullSearch(sides[0]))
            else: # We can find the term in given field only (left side of query, sides[0])
                if sides[0] == 'date':
                    
                elif sides[0] == 'text':
                    if len(IDs) == 0:
                        IDs.update(fullSearch(sides[1], 't'))
                    else:
                        IDs.intersection(fullSearch(sides[1], 't'))
                elif sides[0] == 'name':
                    if len(IDs) == 0:
                        IDs.update(fullSearch(sides[1], 'n'))
                    else:
                        IDs.intersection(fullSearch(sides[1], 'n'))
                elif sides[0] == 'location':
                    if len(IDs) == 0:
                        IDs.update(fullSearch(sides[1], 'l'))
                    else:
                        IDs.intersection(fullSearch(sides[1], 'l'))
                else:
                    print("Invalid query:"+query)
                
        # Get tweets from ID
        # For now, we'll just print out the IDs
        print("FINAL: "+str(IDs))

        # For each tweet got, print the readable format
        # @TODO
main()
