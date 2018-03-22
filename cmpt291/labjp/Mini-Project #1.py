# Seth Bergen
# Eric Hsueh

import cx_Oracle
from lel import ass

def searchForTweets(usr):
    """TODO Together"""
    pass

def searchForUsers(usr):
    """TODO Together"""
    pass

def compose(usr):
    """TODO For Eric"""
    pass

def listFollowers(usr):
    """TODO For Eric"""
    pass

def mainMenu(usr):
    """Provides a hub menu for all system functionalities"""
    while True:
        # Standin for actually printing the tweets.
        print("Tweet1\nTweet2\nTweet3\nTweet4\nTweet5\n--------------------")
        
        selection = input("Options:\n"
                          "1. More tweets\n"
                          "2. Select a tweet\n"
                          "3. Search for tweets\n"
                          "4. Search for users\n"
                          "5. Compose a tweet\n"
                          "6. List followers\n"
                          "7. Logout\n")
        if selection == '1':
            pass # Increment starting point and print the next X tweets
        elif selection == '2':
            pass # Ask the user for the tweet they want to select and then take them to the page for that
        elif selection == '3':
            searchForTweets(usr)
        elif selection == '4':
            searchForUsers(usr)
        elif selection == '5':
            compose(usr)
        elif selection == '6':
            listFollowers(usr)
        elif selection == '7':
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
            if len(curs.fetchall()) > 0:
                print('Successful login attempt.\n')
                mainMenu(usr)
                break
            else:
                print("Either user ID or password are incorrect. Please try again.\n")
        except:
            print('Invalid credentials. Please try again.')


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


#with open('user_info.txt') as user_info:  # Get oracle account username and password from accompanying file
#    username, password = user_info.readline().split(':')  # Account info should be in format: username:password


con = cx_Oracle.connect("ehsueh",ass(),"gwynne.cs.ualberta.ca:1521/CRS")
curs = con.cursor()

startMenu()

con.rollback()
print('Changes made during testing have been rolled back.')
#con.commit()
con.close()
