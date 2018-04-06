import mountaincar
from Tilecoder import numTilings, numTiles, tilecode
from pylab import *  # includes numpy

numRuns = 50
n = numTiles * 3

def qHat(state, action, theta):
    tileIndices = tilecode(state[0], state[1])
    sum = 0
    for i in range(0,numTilings):
        sum += theta[tileIndices[i] + (action*numTiles)]
    return sum

def Qs(tiles, theta1, theta2):
    maxSum = -999999999
    sum = 0
    action = 0
    for a in range(0,3):
        for i in range(numTilings):
            sum += theta1[(tiles[i] + (a * numTiles))] + theta2[(tiles[i] + (a * numTiles))]
        if sum > maxSum:
            maxSum = sum
    return maxSum


def learn(alpha=.1/numTilings, epsilon=0, numEpisodes=200):
    theta1 = -0.001*rand(n)
    theta2 = -0.001*rand(n)
    returnSum = 0.0
    runEpisodeReturns = []

    for episodeNum in range(numEpisodes):
        G = 0
        step = 0
        currentState = mountaincar.init()
        terminate = False
        while not terminate:
            ac1 = qHat(currentState, 0, theta1) + qHat(currentState, 0, theta2)
            ac2 = qHat(currentState, 1, theta1) + qHat(currentState, 1, theta2)
            ac3 = qHat(currentState, 2, theta1) + qHat(currentState, 2, theta2)
            action = argmax[ac1,ac2,ac3]
            #action = argmax([qHat(currentState, 0, theta1) + qHat(currentState, 0, theta2),
                            #qHat(currentState, 1, theta1) + qHat(currentState, 1, theta2),
                            #qHat(currentState, 2, theta1) + qHat(currentState, 2, theta2)])
            R, nextState = mountaincar.sample(currentState, action)
            if(nextState is None):

                if randint(0, 2) == 0:  # 0.5 probability
                    phi = tilecode(currentState[0], currentState[1])
                    for i in range(numTilings):
                        theta1[phi[i] + (action * numTiles)] += alpha * (R - qHat(currentState,action,theta1))

                else:  # 0.5 probability
                    phi = tilecode(currentState[0], currentState[1])
                    for i in range(numTilings):
                        theta2[phi[i] + (action * numTiles)] += alpha * (R - qHat(currentState,action,theta2))
                terminate = True

            else:

                if randint(0,2) == 0:#0.5 probability
                    nextAction = argmax([qHat(nextState, 0, theta1),
                                         qHat(nextState, 1, theta1),
                                         qHat(nextState, 2, theta1)])
                    phi = tilecode(currentState[0], currentState[1])
                    for i in range(numTilings):
                        theta1[phi[i] + (action*numTiles)] += alpha * (R + qHat(nextState,nextAction,theta2) - qHat(currentState,action,theta1))
                else:#0.5 probability
                    nextAction = argmax([qHat(nextState, 0, theta2),
                                         qHat(nextState, 1, theta2),
                                         qHat(nextState, 2, theta2)])
                    phi = tilecode(currentState[0], currentState[1])
                    for i in range(numTilings):
                        theta2[phi[i] + (action*numTiles)] += alpha * (R + qHat(nextState,nextAction,theta1) - qHat(currentState,action,theta2))
                currentState = nextState

            #print("Episode: ", episodeNum, "Return: ", G)
            G = G + R
            step += 1
        runEpisodeReturns.append(G)
       # print("Episode: ", episodeNum, "Steps:", step, "Return: ", G)
        returnSum = returnSum + G

    #print("Average return:", returnSum / numEpisodes)
    return returnSum, theta1, theta2, runEpisodeReturns

def writeAverage(runReturns):
    fout = open('averageValues', 'w')
    numEpisodes = 200
    for episode in range(numEpisodes):
        episodeReturn = 0
        for i in range(numRuns):
            currentRun = runReturns[i]
            currentEpisode = currentRun[episode]
            episodeReturn += currentEpisode
        returnOut = episodeReturn/50
        fout.write(repr(returnOut) + ', ')
    fout.close()

#Additional code here to write average performance data to files for plotting...
#You will first need to add an array in which to collect the data

def writeF(theta1, theta2):
    fout = open('value', 'w')
    steps = 50
    for i in range(steps):
        for j in range(steps):
            F = tilecode(-1.2 + i * 1.7 / steps, -0.07 + j * 0.14 / steps)
            height = -Qs(F, theta1, theta2)
            fout.write(repr(height) + ' ')
        fout.write('\n')
    fout.close()


if __name__ == '__main__':
    eReturns = []
    runReturns = []
    runSum = 0.0
    for run in range(numRuns):
        returnSum, theta1, theta2, episodeReturn = learn()
        #runSum += returnSum
       # print(len(episodeReturn))
        runReturns.append(episodeReturn)
        #print("Runs ", run, "done")
    #print(len(runReturns))
    writeAverage(runReturns)
    #print("DONE")
    #print("Overall performance: Average sum of return per run:", runSum/numRuns)

    #writeF(theta1,theta2)