numTilings = 4
numTiles = 9*9 * numTilings
     
def tilecode(in1, in2, tileIndices):
    # write your tilecoder here (5 lines or so)
    i = 0
    while (i != numTilings):
        index = (int(((in1+(0.053125*i)+1.2))/0.2125)+ int(((in2+(0.004375*i)+0.07))/0.0175)*9 + i * 81)
        tileIndices[i] = index;
        i +=1
    return tileIndices
        
#def printTileCoderIndices(in1, in2):
    #tileIndices = [-1] * numTilings
    #tilecode(in1, in2, tileIndices)
    ##print('Tile indices for input (', in1, ',', in2,') are : ', tileIndices)
 
#if __name__ == '__main__':
    #printTileCoderIndices(-1.2, -0.07)
    #printTileCoderIndices(-1.2, 0.07)    
    #printTileCoderIndices(0.5, -0.07)    
    #printTileCoderIndices(0.5, 0.07)
    #printTileCoderIndices(-0.35, 0.0)
    #printTileCoderIndices(0.0, 0.0)