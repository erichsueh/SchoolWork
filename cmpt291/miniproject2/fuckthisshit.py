import re
from bsddb3 import db


def fullSearch(pterm):
    """TODO"""
    database = db.DB()
    database.open("te.idx")
    curs = database.cursor()
    result = curs.set(bytes(pterm, encoding="utf-8"))
    #result = curs.set(b'germany')
    print(result)
    curs.close()
    database.close()    
    print(result)
    #idSet = set()
    # Query to DB
    # add all returned IDs to idSet
    #idSet.update({1,2,3})
    return result

def tempSetReturn():
    # Just here so I can test features before their prereqs are done
    return ({2,4})

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
                print('DEBUG: GOTO full search')
                if len(IDs) == 0:
                    IDs.update(fullSearch(sides[0]))
                else:
                    IDs = IDs.intersection(fullSearch(sides[0]))
            else: # We can find the term in given field only (left side of query, sides[0])
                print('DEBUG: Determine where to go from here(ie if > in string go to that funct)')
                
                # TEMP CODE
                if len(IDs) == 0:
                    IDs.update(tempSetReturn())
                else:
                    IDs = IDs.intersection(tempSetReturn())
                # /TEMP CODE
                
        # Get tweets from ID
        # For now, we'll just print out the IDs
        print(IDs)

        # For each tweet got, print the readable format
        # @TODO
main()
