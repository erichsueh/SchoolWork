def searchForUsers(usr):
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
            print(len(userlist))
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