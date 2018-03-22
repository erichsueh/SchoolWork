from stack import Stack
endprogram = False

try:
    filename= input("Enter the file name: ")
    infile=open(filename,'r')
except IOError:
    print("Error reading file!. End of program.")
    endprogram = True

stack1 = Stack()

roundbracketc = 0
sqrbracketc = 0
squigbracketc=0
match_round = True
match_square = True
match_squig = True

if endprogram == False:
    for line in infile:
        thelist = []
        line=line.strip("\n")
        thelist.extend(line)
        for words in thelist:
            if words =="(" or words == "{" or words == "[": 
                stack1.push(words)
            elif words == ")":
                if stack1.peek() == "(":
                    stack1.pop()
                    roundbracketc = roundbracketc +1
                else:
                    match_round = False
            elif words == "]":
                if stack1.peek() == "[":
                    stack1.pop()
                    sqrbracketc = sqrbracketc +1
                else:
                    match_square = False
            elif words == "}":
                if stack1.peek() == "{":
                    stack1.pop()
                    squigbracketc = squigbracketc+1
                else:
                    match_squig = False
#print(stack1.size())
print ("() pairs: "+str(roundbracketc))
print ("{} pairs: "+str(squigbracketc))
print ("[] pairs: "+str(sqrbracketc))
if match_round == True:
    print("All () matched.")
else:
    print("Not all () matched.")
if match_squig == True:
    print("All {} matched.")
else:
    print("Not all {} matched.")
if match_square == True:
    print("All [] matched.")
else:
    print("Not all [] matched.")

