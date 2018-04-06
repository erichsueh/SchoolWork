import blackjack
from pylab import *
size = (2,181)
Q1 = np.zeros(size) # NumPy array of correct size
Q2 = np.zeros(size) # NumPy array of correct size
alpha = 0.001
eps = .01
training = 1000000
#print((Q1[0,s] + Q2[0,s]) >= (Q1[1,s] + Q2[1,s]))

def policy(s):
    if ((Q1[0,s] + Q2[0,s]) >= (Q1[1,s] + Q2[1,s])):
        a = 0
    else:
        a = 1    
    return a

def learn(alpha, eps, numTrainingEpisodes):
    returnSum = 0.0
    for episodeNum in range(numTrainingEpisodes):
        s = blackjack.init()
        G = 0
        discount = 1
        while (s is not False):
            if np.random.randint(0,101)>= eps*100:
                if ((Q1[0,s] + Q2[0,s]) >= (Q1[1,s] + Q2[1,s])):
                    a = 0
                else:
                    a = 1
            else:
                a = np.random.randint(0,2)
            #a = 1 # Q1 + Q2 egreedy   argmax(sum Q1+Q2)
            r,s1 = blackjack.sample(s,a)
            if np.random.randint(0,2) == 1:
                c = discount*Q2[np.argmax(Q2,0)[s1],s1]
                Q1[a,s] = Q1[a,s] + alpha*(r + c - Q1[a,s])
            else:
                c = discount*Q1[np.argmax(Q1,0)[s1],s1]
                Q2[a,s] = Q2[a,s] + alpha*(r + c - Q2[a,s])
                #Q2 <- Q2 + alpha(R + discount (S', argmaxQ1(S',a)) - Q2)    
            #G+=r
            s = s1
        #print("Episode: ", episodeNum, "Return: ", G)
        #returnSum = returnSum + G
        #if numTrainingEpisodes%100000 == 0:
            #print("return = " + str(returnSum/numTrainingEpisodes))
    #return(returnSum/numTrainingEpisodes)
    #blackjack.printPolicy(policy)
    #blackjack.printPolicyToFile(policy)

def evaluate(numEvaluationEpisodes):
    returnSum = 0.0
    for episodeNum in range(numEvaluationEpisodes):
        G = 0
        s = blackjack.init()
        while (s is not False):
            if ((Q1[0,s] + Q2[0,s]) >= (Q1[1,s] + Q2[1,s])):
                a = 0
            else:
                a = 1            
            #a = np.random.randint(0,2)#Q1+Q2 (s,1) vs Q1+Q2(s,0)
            r,s = blackjack.sample(s,a)
            G+=r
        #print("Episode: ", episodeNum, "Return: ", G)
        returnSum = returnSum + G
    return returnSum/numEvaluationEpisodes

#learn(alpha,eps,training)
#print(evaluate(10000))
#print(Q1)
#print(Q2)