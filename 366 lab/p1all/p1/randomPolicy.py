import blackjack
from pylab import *

#def run(numEpisodes):
#    returnSum = 0.0
#    for episodeNum in range(numEpisodes):
#        G = 0
#        s = blackjack.init()
#        while (s is not False):
#            a = np.random.randint(0,2)
#            r,s = blackjack.sample(s,a)
#            G+=r
#        print("Episode: ", episodeNum, "Return: ", G)
#        returnSum = returnSum + G
#    return returnSum/numEpisodes

def run(numEvaluationEpisodes):
    returnSum = 0.0
    for episodeNum in range(numEvaluationEpisodes):
        G = 0
        s = blackjack.init()
        while (s is not False):
            a = np.random.randint(0,2)
            r,s = blackjack.sample(s,a)
            G+=r
        print("Episode: ", episodeNum, "Return: ", G)
        returnSum = returnSum + G
    return returnSum / numEvaluationEpisodes

#print(run(2000))