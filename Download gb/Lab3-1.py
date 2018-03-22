class TicTacToe:
    def __init__(self):
        # "board" is a list of 10 strings representing the board (ignore index 0)
        self.board = [" "]*10
        self.board[0]="#"
#------------------------------------------------------------- 
    def drawBoard(self):
    # This method prints out the board with current plays adjacent to a board with index.
        numblist = ["#","7","8","9","4","5","6","1","2","3"]
        print(" "+self.board[7]+" | "+self.board[8]+" | "+self.board[9]+"\t"+" "+numblist[1]+" | "+numblist[2]+" | "+numblist[3])
        print(("-"*11)+"\t"+("-"*11))
        print(" "+self.board[4]+" | "+self.board[5]+" | "+self.board[6]+"\t"+" "+numblist[4]+" | "+numblist[5]+" | "+numblist[6])
        print(("-"*11)+"\t"+("-"*11))
        print(" "+self.board[1]+" | "+self.board[2]+" | "+self.board[3]+"\t"+" "+numblist[7]+" | "+numblist[8]+" | "+numblist[9])
#------------------------------------------------------------- 
    def boardFull(self):
    # This method checks if the board is already full and returns True. Returns false otherwise
        self.boardfull = False
        counter = 0
        for line in self.board:
            if line == " ":
                counter = counter +1
        if counter == 0:
            self.boardfull= True
        return self.boardfull
#------------------------------------------------------------- 
    def cellIsEmpty(self, cell):
        self.cellisempty = True
        if self.board[int(cell)] == " ":
            self.cellisempty = True
        else:
            self.cellisempty = False
        return self.cellisempty
#------------------------------------------------------------- 
    def assignMove(self, cell,ch):
    # assigns the cell of the board to the character ch
        self.board[int(cell)] = ch
        return
#------------------------------------------------------------- 
    def whoWon(self):
    # returns the symbol of the player who won if there is a winner, otherwise it returns an empty string. 
        if self.isWinner== "x":
            return "x"
        elif self.isWinner == "o":
            return "o"
        else:
            return ""
#-------------------------------------------------------------   
    def isWinner(self, ch):
    # Given a player's letter, this method returns True if that player has won.
        if self.board[1] == ch and self.board[2] == ch and self.board[3] == ch:
            self.isWinner = ch
        elif self.board[4] == ch and self.board[5] == ch and self.board[6] == ch:        
            self.isWinner = ch
        elif self.board[7] == ch and self.board[8] == ch and self.board[9] == ch:        
            self.isWinner = ch            
        elif self.board[1] == ch and self.board[4] == ch and self.board[7] == ch:        
            self.isWinner = ch            
        elif self.board[2] == ch and self.board[5] == ch and self.board[8] == ch:        
            self.isWinner = ch            
        elif self.board[3] == ch and self.board[6] == ch and self.board[9] == ch:        
            self.isWinner = ch
        elif self.board[1] == ch and self.board[5] == ch and self.board[9] == ch:        
            self.isWinner = ch        
        elif self.board[3] == ch and self.board[5] == ch and self.board[7] == ch:        
            self.isWinner = ch      
#------------------------------------------------------------- 
def main():
    gameover = False
    board1 = TicTacToe()    
    
    while gameover == False:
        board1.drawBoard()
        validinput = False
        while validinput == False:
            user = input("It is the turn for x. What is your move? ")
            try:
                int(user)
                if float(user)>0 and float(user)<10:
                    if board1.cellIsEmpty(user) == True:
                        board1.assignMove(user,"x")
                        validinput = True
            except ValueError:
                validinput = False
        
        board1.isWinner("x")
        if board1.whoWon() !="":
            board1.drawBoard()
            print("x wins. Congrats!")
            gameover = True
                
        elif board1.boardFull()== True:
            board1.drawBoard()
            gameover = True
            print("It's a tie.")
            
            
        if gameover == False:
            board1.drawBoard()
            validinput = False
            while validinput == False:
                user = input("It is the turn for o. What is your move? ")
                try:
                    int(user)
                    if float(user)>0 and float(user)<10:
                        if board1.cellIsEmpty(user) == True:
                            board1.assignMove(user,"o")
                            validinput = True
                except ValueError:
                    validinput = False
            
            board1.isWinner("o")
            if board1.whoWon() !="":
                board1.drawBoard()
                print("o wins. Congrats!")
                gameover = True
                
            elif board1.boardFull() == True:
                board1.drawBoard()
                gameover = True
                print("It's a tie.")
main()