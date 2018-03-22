from queue12 import Queue

def main():
    exitprogram = False
    theque = Queue()

    while exitprogram == False:
        user = input("Add, Serve, or Exit: ")
        if user == "Exit":
            exitprogram = True
        elif user == "Add":
            if theque.size() >= 3:
                print("You cannot add more people, the lineup is full!")
            else:
                name = input("Enter the name of the person to add: ")
                theque.queue(name)
        elif user == "Serve":
            if theque.is_empty() == True:
                print("The lineup is already empty.")
            else:
                print(theque.dequeue() + " has been served.")
main()
            