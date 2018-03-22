endprogram = False
try:
    filename=("accounts.txt")
    infile=open(filename,'r')
except IOError:
    print("Error reading file!. End of program.")
    endprogram = True
    
thedic = {}
if endprogram == False:
    for line in infile:
        isfloat = True
        line=line.strip("\n")
        name,money=line.split(":")
        try:
            money = float(money)
            
        except ValueError:
            print("Account for "+name+" not added: illegal value for balance")
            isfloat = False
        if isfloat == True:    
            thedic[name]=money

while endprogram == False:
    user= input("Enter account name, or 'Stop' to exit: ")
    if user == "Stop":
        endprogram = True
    if endprogram == False:
        theaccount = thedic.get(user,"Account does not exist, transaction canceled")
        validaccount = True
        try:
            theaccount = float(theaccount)
        except ValueError:
            print(theaccount)
            validaccount = False
        if validaccount == True:
            try:
                trans = float(input("Enter transaction amount: "))
            except ValueError:
                print("Illegal value for transaction, transaction canceled")
            else:
                print("New balance for account "+user+": "+str('%.2f'%(theaccount+trans)))
                thedic[user]=(theaccount+trans)