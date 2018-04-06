numTilings = 4
numTiles = 9*9*numTilings
alpha = 0.1/numTilings
positionRange = 1.7
velocityRange = .14
positionWidth = positionRange / 8
velocityWidth = velocityRange / 8
posOffset = (1 / numTilings) * positionWidth
velOffset = (1 / numTilings) * velocityWidth


def tilecode(position,velocity):
    #tileIndices = [-1]*numTilings
    for i in range(0, numTilings):
        positionIn = int((position + (posOffset * i) + 1.2) / positionWidth)
        velocityIn = int((velocity + (velOffset * i) + 0.07) / velocityWidth)
        index = (velocityIn * 9) + positionIn
        tileIndices[i] = index + ((9*9) * i)
    return tileIndices
