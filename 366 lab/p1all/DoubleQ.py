import blackjack
from pylab import *

Q1 = ... # NumPy array of correct size
Q2 = ... # NumPy array of correct size

def learn(alpha, eps, numTrainingEpisodes):
    ... # Fill in Q1 and Q2

def evaluate(numEvaluationEpisodes):
    returnSum = 0.0
    for episodeNum in range(numEvaluationEpisodes):
        G = 0
        ...
        returnSum = returnSum + G
    return returnSum/numEvaluationEpisodes
