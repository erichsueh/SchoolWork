import math
numTilings = 8
def tilecode(in1, in2, tileIndices):
    i = 0
    #tileIndices[i] = int(in1/.6) + int(in2/.6)*11
    #i =1
    while (i != numTilings):
        index = (int(((in1)+(0.075*i))/.6)+ int(((in2)+(0.075*i))/.6)*11 + i * 121)
        tileIndices[i] = int(index);
        i +=1
        
        
def printTileCoderIndices(in1, in2):
    tileIndices = [-1] * numTilings
    tilecode(in1, in2, tileIndices)
    #print('Tile indices for input (', in1, ',', in2,') are : ', tileIndices)

printTileCoderIndices(0.1, 0.1)
printTileCoderIndices(4.0, 2.0)
printTileCoderIndices(5.99, 5.99)
printTileCoderIndices(4.0, 2.1)
    
