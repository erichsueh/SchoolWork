import random
thenumb = random.randint(0,20)

user = float(input("Enter a guess (1-20): "))
counter = 0
gameover = False
while gameover == False:    
    if user>= 0 and user <= 20:
        if user != thenumb:
            if user > thenumb:
                print("Too High!")
                counter= counter+1
                user = float(input("Enter a guess (1-20): "))
            elif user < thenumb:
                print("Too Low!")
                counter = counter+1
                user = float(input("Enter a guess (1-20): "))
        elif user == thenumb:
            print("Correct! The number was",thenumb)
            gameover=True
    else:
        print("That number is not between 1 and 20!")
    
    if counter ==5:
        gameover = True
        print("You are out of guesses. The number was",thenumb)