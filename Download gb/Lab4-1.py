from stack import Stack

def main():
    user = input("Enter a String to reverse: ")
    stack1 = Stack()
    counter = 0
    for i in range(len(user)):
        stack1.push(user[i])
    reversedstr = ""
    for i in range(int(stack1.size())):
        reversedstr = reversedstr + stack1.pop()
        #reversedstr.append(stack1.pop())
    print("The reversed String is: "+reversedstr)
main()