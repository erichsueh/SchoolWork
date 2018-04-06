import mountaincar
from Tilecoder import numTilings, numTiles, tilecode
from pylab import *  # includes numpy
 
numRuns = 50
n = numTiles * 3
avgrlist = [0]*200
avgslist = [0]*200

def Total(state, action, theta):
    tileIndices = [-1] * numTilings
    tileIndices = tilecode(state[0], state[1],tileIndices)
    total = 0
    for i in range(0,numTilings):
        total += theta[tileIndices[i] + (action*numTiles)]
    return total

def chooseaction(state,theta1,theta2):
    ac1 = Total(state, 0, theta1) + Total(state, 0, theta2)
    ac2 = Total(state, 1, theta1) + Total(state, 1, theta2)
    ac3 = Total(state, 2, theta1) + Total(state, 2, theta2)
    action = argmax([ac1,ac2,ac3])      
    return(action)

def learn(alpha=0.1 / numTilings, epsilon=0.0, numEpisodes=200):
    theta1 = -0.001 * rand(n)
    theta2 = -0.001 * rand(n)
    returnSum = 0.0
    for episodeNum in range(numEpisodes):
        G = 0.0
        tileIndices = [-1] * numTilings
        pos, vel = mountaincar.init()
        state = (pos, vel)
        step = 0
        while state != None:
            tilecode(pos, vel, tileIndices)
            action = chooseaction(state,theta1,theta2)
            r, nstate = mountaincar.sample(state, action)
            tileIndices = [-1] * numTilings
            if nstate != None:
                if randint(0,2) == 0:
                    naction = chooseaction(nstate,theta1,theta2)
                    tileIndices = tilecode(state[0], state[1],tileIndices)
                    for i in range(numTilings):
                        theta1[tileIndices[i] + (action*numTiles)] += alpha * (r + Total(nstate,naction,theta2) - Total(state,action,theta1))
                else:
                    naction = chooseaction(nstate,theta1,theta2)
                    tileIndices = tilecode(state[0], state[1],tileIndices)
                    for i in range(numTilings):
                        theta2[tileIndices[i] + (action*numTiles)] += alpha * (r + Total(nstate,naction,theta1) - Total(state,action,theta2))
            else:
                if randint(0, 2) == 0:
                    tileIndices = tilecode(state[0], state[1],tileIndices)
                    for i in range(numTilings):
                        theta1[tileIndices[i] + (action * numTiles)] += alpha * (r - Total(state,action,theta1))
                else:
                    tileIndices = tilecode(state[0], state[1],tileIndices)
                    for i in range(numTilings):
                        theta2[tileIndices[i] + (action * numTiles)] += alpha * (r - Total(state,action,theta2))
            state = nstate
            G += r
            step += 1
        #print("Episode:", episodeNum, "Steps:", step, "Return: ", G)
        avgrlist[episodeNum] += G
        avgslist[episodeNum] += step
        returnSum += G
    #print("Average return:", returnSum / numEpisodes)
    
    return returnSum, theta1, theta2, step
 
 
#Additional code here to write average performance data to files for plotting...
#You will first need to add an array in which to collect the data
 
def writeF(theta1, theta2):
    fout = open('value', 'w')
    steps = 50
    for i in range(steps):
        for j in range(steps):
            F = [-1] * numTilings
            tilecode(-1.2 + (i * 1.7 / steps), -0.07 + (j * 0.14 / steps), F)
            height = -max(Qs(F, theta1 + theta2 / 2))
            fout.write(repr(height) + ' ')
        fout.write('\n')
    fout.close()

def writeAverage():
    f1 = open('avgr.txt','w')
    f2 = open('avgs.txt','w')
    for i in range(200):
        f1.write(str(avgrlist[i])+'\n')
        f2.write(str(avgslist[i])+'\n')
    f1.close()
    f2.close()
        
def Qs(tileIndices, theta):
    sumThetaA = 0
    sumThetaB = 0
    sumThetaC = 0
    for i in tileIndices:
        sumThetaA += theta[i]
        sumThetaB += theta[i+numTiles]
        sumThetaC += theta[i+numTiles*2]
    return(sumThetaA,sumThetaB,sumThetaC)
 
if __name__ == '__main__':
    runSum = 0.0
    for run in range(numRuns):
        returnSum, theta1, theta2,step = learn()
        runSum += returnSum
    #print("Overall performance: Average sum of return per run:", end="")
    #print(runSum / numRuns)

    #writeF(theta1,theta2)
    writeAverage()