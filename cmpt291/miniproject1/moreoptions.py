#more options after choosing which follower they want to see
def moreOptions(usr,fID):
    pageNumber = 0
    while True:
        tweets = getTweets(fID, pageNumber,3)
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
            print(currentmonth)
            currentdate = strftime("%d-"+currentmonth+"-%Y", gmtime())
            #debug currentdate here
            print(currentdate)
            
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
