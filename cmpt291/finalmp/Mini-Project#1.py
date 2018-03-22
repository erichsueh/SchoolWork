"""Implements a text-based Twitter clone as per the Mini-Project #1 Specifications."""

# Seth Bergen
# Eric Hsueh
# Zhipeng Zhang

import cx_Oracle
from time import gmtime, strftime

def manageLists(usr):
    """The function is used to (a) to get a listing of his lists, (b) to see the lists that he is on, (c) to create a list, and (d) to add or delete members to hist lists."""
    # List all lists that you have
    curs.execute("SELECT lname FROM lists WHERE owner = " + usr) #List all lists that you have
    print("List of lists:")
    for elements in curs:
        print(elements)
    print("The lists that you on:")
    # List all lists that you in
    curs.execute("SELECT lname FROM includes WHERE member = " + usr) #List all lists that you in
    for elements in curs:
        print(elements)  
    # Create list part
    while True:
        create = input("Do you want to create a list? If you want, please enter yes, otherwise no.")
        if create.lower() == "yes":
            owner = usr
            lname = input("please input list name: ")
            data1 = [(lname, owner)]
            curs.bindarraysize = 1
            #curs.setinputsizes("char", 10)
            curs.executemany("INSERT INTO lists(lname, owner)" "VALUES(:1,:2)", data1)  # Insert new values(create new lists)
            print("list created")
            break
        if create.lower() == "no":
            break        
    # Delete or add member to your list part
    while True:
        changeMember = input("Do you want to add or delete members to hist lists? If you want to add member, please input add. If you want to delete, input delete, otherwise, please enter No. ")
        #add part
        if changeMember.lower() == "add":
            lname = input("Please enter list name: ")
            member = input("Please enter a member's ID: ")
            data1 = [(lname, member)]
            curs.bindarraysize = 1
            #curs.setinputsizes("char", 10)
            curs.execute("SELECT lname FROM lists WHERE lname ='" + lname+"'")  #Make sure the list is exist
            if len(curs.fetchall()) == 0:
                print("No such list")
                continue
            curs.execute("SELECT usr FROM users WHERE usr ='"+ member+"'")     # Make sure the member is exist
            if len(curs.fetchall()) == 0:
                print("No such member")
                continue
            curs.executemany("INSERT INTO includes(lname, member)" "VALUES(:1,:2)", data1)   # Add new member to your list
            print("Member added")
            break
        # delete part
        elif changeMember.lower() == "delete":
            lname = input("Please enter list name: ")
            member = input("Please enter a member's name: ")  
            statement = 'delete from includes where member = :member AND lname = :lname'   # Delete member from list

            curs.execute("SELECT lname FROM includes WHERE lname ='" + lname+"'")   #Make sure the list is exist
            if len(curs.fetchall()) == 0:
                print("No such list")
                continue
            curs.execute("SELECT member FROM includes WHERE member ='"+ member+"'")   # Make sure the member is exist
            if len(curs.fetchall()) == 0:
                print("No such member")
                continue
            curs.execute(statement, {'member':1, 'lname':1})
            print("Member deleted")
        else:
            break


def find(searchinput):
    """Displays the big query for the search page of part 2"""
    #do big query and union the two
    q1 = ("SELECT * FROM (SELECT u1.name,u1.city,u1.usr FROM users u1 WHERE u1.name LIKE '%"+ searchinput+"%' ORDER BY LENGTH(u1.name) ASC)a1")
    q2 = ("SELECT * FROM (SELECT u2.name,u2.city,u2.usr FROM users u2 WHERE u2.city LIKE '%"+ searchinput+"%' ORDER BY LENGTH(u2.city) ASC)a2")
    curs.execute(q1+" UNION " + q2)
    return (curs.fetchall())

def searchForUsers(usr):
    """Search for users, displays the query result as well as presents options to move onto more options """
    page = 0
    while True:
        #get input
        searchinput = input("Please enter your search keyword(-1 to cancel): ")
        if searchinput == "-1":
            break
        userlist = find(searchinput)
        while True:
            #do voodoo magic to display 3 and no more
            if page < 0:
                page = 0
            #print(len(userlist))
            if len(userlist) < page+3:
                b = len(userlist)-1
            else:
                b = page + 2
            print("Name                ,City        ,ID")
            while (page <= b):
                print(str(userlist[page][0]) +","+str(userlist[page][1])+","+str(userlist[page][2]))
                page +=1
            page = page -3
            
            viewfollower = input("To see more options for a specific user, type their user ID(-1 to cancel/-2 to see more)")
            #break if they dont want to see more
            if viewfollower == "-1":
                break
            elif viewfollower == "-2":
                page = page +3
                continue
            else:
                #parse input
                #call function more options
                #check if viewfollower is a digit
                if not (viewfollower.isdigit() and int(viewfollower) >= 0):
                    print('Invalid follower ID. Please enter a positive integer.')
                    continue
                #checking that the user exists here
                curs.execute("SELECT * FROM users u WHERE u.usr = "+viewfollower)
                if len(curs.fetchall()) != 0:
                    moreOptions(usr, viewfollower)
                else:
                    print("Invalid Follower")
                    continue
                break        
        break
    return

def compose(usr, tweetreply=None):
    """Compose a new tweet functions, prompts user for tweet ID, and body and reply tweet id"""
    while True:  # Get a valid and unused tweetID from the user
        tweetID = input('Please Enter your desired Tweet ID(-1 to cancel): ')
        #check if it was canceled
        if tweetID == "-1":
            return
        #checking for valid tweetid here
        if not (tweetID.isdigit() and int(tweetID) > 0):
            print('Invalid tweet ID. Please enter a positive integer.')
            continue
        #checking that the tweetID is unique here
        curs.execute("SELECT * FROM tweets WHERE tid = "+tweetID)
        if len(curs.fetchall()) != 0:
            print('That tweet ID is taken. Please try again.')
            continue
        break
    #debug tweetID here
    #print("get proper tweetid",tweetID)

    #get current date
    #using a python function strftime and gmtime
    currentmonth = strftime("%b", gmtime())
    currentmonth = currentmonth.upper()
    #print(currentmonth)
    currentdate = strftime("%d-"+currentmonth+"-%Y", gmtime())
    #debug currentdate here
    #print(currentdate)
    
    #while true, get proper input for the tweet body and prepare the hastags
    while True:
        tweetbody = input('Please enter your tweet with under 80 chars(-1 to cancel): ')
        if tweetbody == "-1":
            return
        elif len(tweetbody)>= 80:
            print("Tweet too long, 80 characters or less please")
            continue
        else:
            #parse hashtags here
            parsehash = tweetbody.split("#")[1:]
            #print(parsehash)
            break
    
    #get the tweet reply ID
    while True:
        if tweetreply == None:
            tweetreply = input('Please enter the id of the tweet you are replying to(this tweets ID if nobody/ -1 to quit): ')
        else:
            tweetreply = str(tweetreply)
        if tweetreply == "-1":
            return
        elif tweetreply == tweetID:
            #print statement here can be commented out
            #print("INSERT INTO tweets(tid,writer,tdate,text) VALUES(%d, %d, '%s', '%s')" % (int(tweetID),int(usr),currentdate , tweetbody))
            curs.execute("INSERT INTO tweets(tid,writer,tdate,text) VALUES(%d, %d, '%s', '%s')" % (int(tweetID),int(usr),currentdate , tweetbody))
            print('Tweet posted successfully.\n')
            break
        else:
            #checking for proper digit
            if not (tweetreply.isdigit() and int(tweetreply) > 0):
                print('Invalid reply ID. Please enter a positive integer.')
                tweetreply = None
                continue
            #checking that the replyID exists here
            curs.execute("SELECT * FROM tweets WHERE tid = "+tweetreply)
            if len(curs.fetchall()) != 0:
                #execute here with print statement to be commented out
                #print("INSERT INTO tweets(tid,writer,tdate,text,replyto) VALUES(%d, %d, '%s', '%s',%d)" % (int(tweetID),int(usr),currentdate , tweetbody,int(tweetreply)))
                curs.execute("INSERT INTO tweets(tid,writer,tdate,text,replyto) VALUES(%d, %d, '%s', '%s',%d)" % (int(tweetID),int(usr),currentdate , tweetbody,int(tweetreply)))
                print('Tweet posted successfully.\n')
                break
            else:
                print('That reply ID does not exist. Please try again.')
                tweetreply = None
                continue
    hashtagstuff(tweetID,parsehash)
    return

#parsing hashtagstuff here
def hashtagstuff(tweetID,parsehash):
    """after parsing the hashtags, it inserts into hashtags table if it dosn't exist, and inserts into mentions"""
    for hashtag in parsehash:
        #print(hashtag)
        #check if its in 
        curs.execute("SELECT * FROM hashtags WHERE term = '"+hashtag+"'")
        if len(curs.fetchall()) == 0:
            curs.execute("INSERT INTO hashtags VALUES('"+hashtag+"')")
        curs.execute("INSERT INTO mentions VALUES (%d, '%s')"%(int(tweetID),hashtag))
    return



def listFollowers(usr):
    """List follower function, will list all your followers present you with options, and thenifyou want you can see more options """
    while True:
        print("Your followers:")
        print("Name                ,ID")
        #list followers with a curs execute
        curs.execute("SELECT u.name, f.flwer FROM users u, follows f WHERE f.flwer = u.usr AND f.flwee = '"+usr+"'")
        #display followers
        followers = curs.fetchall()
        for follower in followers:
            print(str(follower[0])+','+str(follower[1]))
        viewfollower = input("To see more options for a specific user, type their user ID(-1 to cancel)")
        #break if they dont want to see more
        if viewfollower == "-1":
            break
        else:
            #parse input
            #call function more options
            #check if viewfollower is a digit
            if not (viewfollower.isdigit() and int(viewfollower) >= 0):
                print('Invalid follower ID. Please enter a positive integer.')
                continue
            #checking that the replyID exists here
            curs.execute("SELECT * FROM users u, follows f WHERE u.usr = "+viewfollower+"AND u.usr = f.flwer AND f.flwee ="+usr)
            if len(curs.fetchall()) != 0:
                moreOptions(usr, viewfollower)
            else:
                print("Invalid Follower")
                continue
            break
    return

def getOwnTweets(usr, pageNumber, numTweets):
    """Returns all of the tweets of the given user (usr)"""
    curs.execute("SELECT tid, text, rn FROM( SELECT tid, text, ROW_NUMBER() OVER (ORDER BY tdate DESC) AS rn FROM tweets WHERE writer=%d ORDER BY tdate DESC) WHERE rn>=(%d*%d)+1 AND rn<=(%d*%d)+%d" % (int(usr), pageNumber, numTweets, pageNumber, numTweets, numTweets))
    return curs.fetchall()

#more options after choosing which follower they want to see
def moreOptions(usr,fID):
    """Presents more options to the user after the inital one"""
    pageNumber = 0
    while True:
        tweets = getOwnTweets(fID, pageNumber,3)
        print("\nTweetID\tText")
        for tweet in tweets:
            print(tweet[0], '\t', tweet[1], sep='')        
        
        selection = input("Options:\n"
                          "1. See number of tweets\n"
                          "2. See number of users followed\n"
                          "3. See number of followers\n"
                          "4. See more tweets\n"
                          "5. Follow this follower\n"
                          "6. Quit\n")
        if selection == '1': #find number of tweets here
            curs.execute("SELECT COUNT(*) FROM tweets WHERE writer = "+fID)
            showresult = curs.fetchall()
            #idk if this will work, test further later
            print("This follower's # of tweets:" + str(showresult[0][0]))
        elif selection == '2':#find number of users followed here
            curs.execute("SELECT COUNT(*) FROM follows WHERE flwer = "+fID)
            showresult = curs.fetchall()
            #idk if this will work, test further later
            print("This follower's # of user followed:" + str(showresult[0][0]))            
        elif selection == '3':#find number of followers here
            curs.execute("SELECT COUNT(*) FROM follows WHERE flwee = "+fID)
            showresult = curs.fetchall()
            #idk if this will work, test further later
            print("This follower's # of followers:" + str(showresult[0][0])) 
        elif selection == '4':
            pageNumber += 1 # Increment starting point and print the next X tweets
        elif selection == '5':
            #get current date
            #using a python function strftime and gmtime
            currentmonth = strftime("%b", gmtime())
            currentmonth = currentmonth.upper()
            #print(currentmonth)
            currentdate = strftime("%d-"+currentmonth+"-%Y", gmtime())
            #debug currentdate here
            #print(currentdate)
            
            curs.execute("SELECT * FROM follows WHERE flwee ="+str(fID)+ "AND flwer ="+str(usr))
            #error check here if already exists
            if len(curs.fetchall()) != 0:
                print("Error, already followed")
            else:
                curs.execute("INSERT INTO follows VALUES(%d, %d, '%s')"%(int(usr),int(fID),currentdate))
                print("Followed!")
        elif selection == '6':
            break
        else:
            print('Invalid input, Please enter an integer between 1 and 7\n.')
    print('Logged out.\n')
    return



def getTweets(usr, pageNumber, numTweets):
    """Return all tweets by people whom the given user (usr) follows"""
    curs.execute("SELECT tid, text, rn FROM ( SELECT tid, writer, tdate, text, replyto, ROW_NUMBER() OVER (ORDER BY tdate DESC) AS rn FROM (( SELECT t.* FROM tweets t, follows f WHERE %d=f.flwer) UNION( SELECT t.* FROM retweets r, follows f, tweets t WHERE %d=f.flwer AND f.flwee=r.usr AND r.tid=t.tid)) ORDER BY tdate DESC) WHERE rn>=(%d*%d)+1 AND rn<=(%d*%d)+%d" % (int(usr), int(usr), pageNumber, numTweets, pageNumber, numTweets, numTweets))
    return curs.fetchall()

def retweet(usr, tid):
    """Adds a retweet of the given tweet (tid) by the given user (usr)"""
    curs.execute("INSERT INTO retweets VALUES(%d, %d, sysdate)" % (int(usr), int(tid)))
    curs.execute("SELECT * FROM retweets")
    print("Successfuly retweeted!")


def selectTweet(usr, tid):
    """Functionality to see # of retweets of a tweet, # of replies to the tweet, reply to the tweet, and retweet the tweet"""
    curs.execute("SELECT COUNT(*) FROM retweets WHERE tid=%d" % (int(tid)))
    print("\nNumber of retweets: "+str(curs.fetchall()[0][0]))
    curs.execute("SELECT COUNT(*) FROM tweets WHERE replyto=%d AND tid<>%d" % (int(tid), int(tid)))
    print("Number of replies: "+str(curs.fetchall()[0][0]))

    while True:
        selection = input("1. Reply to this tweet\n2. Retweet this tweet\n3. Go Back")
        if selection == '1':
            compose(usr, tid)
        elif selection == '2':
            retweet(usr, tid)
        elif selection == '3':
            break
        else:
            print('Invalid selection. Please try again.')

def getMatches(keywords, pageNum):
    """Returns all tweets contntaining the given word or using the given hashtag."""
    query = "SELECT o.tid, o.text, rn FROM ( SELECT c.tid, c.text, ROW_NUMBER() OVER (ORDER BY c.tdate DESC) AS rn FROM("
    for keyword in keywords: 
        if keyword[0] == '#':
            keyword = keyword[1:]
            query += "(SELECT t.tid, t.text, t.tdate FROM mentions m, tweets t WHERE m.tid=t.tid AND m.term='%s') UNION" % (keyword)
        else:
            query += "(SELECT t.tid, t.text, t.tdate FROM tweets t WHERE t.text LIKE '%"+keyword+"%') UNION"
    query = query[:-6] # Remove last UNION
    query += ") c ORDER BY tdate DESC) o WHERE rn>=(%d*5)+1 AND rn<=(%d*5)+5" % (int(pageNum), int(pageNum))
    curs.execute(query)
    return curs.fetchall()

def searchForTweets(usr):
    """Functionality from part 1. Allows the user to find tweets based in keywords and inspect them."""
    pageNumber = 0
    keywords = list()
    while True:
        newKeyword = input("Please enter a keyword (-1 to stop entering keywords)")
        if newKeyword == '-1':
            break
        else:
            keywords.append(newKeyword)
    if len(keywords) == 0:
        print("No keywords entered.  Returning to menu.")
        return
    
    while True:
        tweets = getMatches(keywords, pageNumber)
		
        print("\nTweetID\tText")
        for tweet in tweets:
            print(tweet[0], '\t', tweet[1], sep='')

        selection = input("Options:\n"
                  "1. More tweets\n"
                  "2. Select a tweet\n"
                  "3. Go Back\n")

        if selection == '1':
            pageNumber += 1 # Increment starting point and print the next X tweets
            tweets = getMatches(keywords, pageNumber)
		
            if len(tweets) == 0:
                print("\nNo more tweets to display. Returning to page 1.")
                pageNumber = 0
        elif selection == '2':
            while True: # Ask the user for the tweet they want to select and then take them to the page for that
                selection = int(input('Please enter the ID of the tweet you wish to select.'))
                
                for tweet in tweets:
                    if selection == tweet[0]:
                        selectTweet(usr, tweet[0])
                        break
                else:
                    print('Invalid tweet ID. Please try again')
                    continue
                break
        elif selection == '3':
            break
        else:
            print('Invalid input, Please enter an integer between 1 and 3\n.')

def mainMenu(usr):
    """Provides a hub menu for all system functionalities"""
    pageNumber = 0
    while True:
        
        tweets = getTweets(usr, pageNumber, 5)
        print("\nTweetID\tText")
        for tweet in tweets:
            print(tweet[0], '\t', tweet[1], sep='')
        
        selection = input("Options:\n"
                          "1. More tweets\n"
                          "2. Select a tweet\n"
                          "3. Search for tweets\n"
                          "4. Search for users\n"
                          "5. Compose a tweet\n"
                          "6. List followers\n"
                          "7. Manage Lists\n"
                          "8. Logout\n")
        if selection == '1':
            pageNumber += 1 # Increment starting point and print the next X tweets
            tweets = getTweets(usr, pageNumber, 5)
		
            if len(tweets) == 0:
                print("\nNo more tweets to display. Returning to page 1.")
                pageNumber = 0
        elif selection == '2':
            while True: # Ask the user for the tweet they want to select and then take them to the page for that
                selection = int(input('Please enter the ID of the tweet you wish to select.'))
                
                for tweet in tweets:
                    if selection == tweet[0]:
                        selectTweet(usr, tweet[0])
                        break
                else:
                    print('Invalid tweet ID. Please try again')
                    continue
                break
        elif selection == '3':
            searchForTweets(usr)
        elif selection == '4':
            searchForUsers(usr)
        elif selection == '5':
            compose(usr)
        elif selection == '6':
            listFollowers(usr)
        elif selection == '7':
            manageLists(usr)
        elif selection == '8':
            break
        else:
            print('Invalid input, Please enter an integer between 1 and 7\n.')
    print('Logged out.\n')
    return

def login():
    """Sends the user to the main menu with the account they log into here."""
    while True:
        usr = input('Please enter your user ID (Enter -1 to cancel login): ')
        
        if usr == '-1':
            print('Login attempt cancelled.')
            break
        
        pwd = input('Please enter your password: ')
        
        try:
            curs.execute("SELECT * FROM users WHERE usr="+usr+" AND pwd='"+pwd+"'")
        except:
            print('Invalid credentials. Please try again.')
            
        if len(curs.fetchall()) > 0:
            print('Successful login attempt.\n')
            mainMenu(usr)
            break
        else:
            print("Either user ID or password are incorrect. Please try again.\n")


def isValidTimezone(t):
    """Returns True if the input is a valid timezone, otherwise returns False."""
    try:
        t = int(t)
        if t >= -12 and t <= 14:
            return True
        else:
            return False
    except:
        return False


def register():
    """Gathers information from the user and then creates a user in the database with this data"""
    while True:  # Get a valid and unused uid from the user
        usr = input('Please Enter your desired User ID: ')
        if not (usr.isdigit() and int(usr) >= 0):
            print('Invalid user ID. Please enter a positive integer.')
            continue
        curs.execute("SELECT * FROM users WHERE usr = "+usr)
        if len(curs.fetchall()) != 0:
            print('That user ID is taken. Please try again.')
            continue
        break
    
    while True:  # Get a valid password from the user
        pwd = input('Please enter your desired password (Must be 1-4 characters): ')
        if len(pwd) < 1 or len(pwd) > 4:
            print('Invalid password. Please make sure you are using only up to 4 characters')
            continue
        break

    while True:  # Get the user's name
        name = input('Please enter your name: ')
        if len(name) > 20:
            print('Character limit exceeded (20)')
            continue
        break

    while True:  # Get the user's email address
        email = input('Please enter your email address: ')
        if len(email) > 15:
            print('Character limit exceeded (15)')
            continue
        break

    while True:  # Get the user's city
        city = input('Please enter your city: ')
        if len(city) > 12:
            print('Character limit exceeded (12)')
            continue
        break

    while True:  # Get the user's timezone
        timezone = input('Please enter your timezone (eg. -7, +0, +4): ')  # Why is timezone a float in the database?
        if not isValidTimezone(timezone):
            print('Invalid input, please try again.')
            continue
        break
        
    curs.execute("INSERT INTO users VALUES(%d, '%s', '%s', '%s', '%s', %f)" % (int(usr), pwd, name, email, city, float(timezone)))
    print('Account successfully registered. You can now log in.\n')
    login()
    

def startMenu():
    """Provides the user with options to Login, Register, or Exit"""
    while True:
        selection = input('1. Login\n2. Sign Up\n3. Exit\n')
        if selection == '1':
            login()
        elif selection == '2':
            register()
        elif selection == '3':
            break
        else:
            print('Invalid input, Please enter an integer between 1 and 3.')


with open('user_info.txt') as user_info:  # Get oracle account username and password from accompanying file
    username, password = user_info.readline().strip('\n').split(':')  # Account info should be in format: username:password

#con = cx_Oracle.connect(username, password, 'localhost:1525/CRS')
con = cx_Oracle.connect(username, password, 'gwynne.cs.ualberta.ca:1521/CRS')
curs = con.cursor()

startMenu()

con.rollback()
print('Changes made during testing have been rolled back.')
#con.commit()
con.close()
