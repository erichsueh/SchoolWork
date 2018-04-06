import numpy as np

A=np.array([[6,2,3],[4,5,6]])
#print(A[0][1])
###or
print(A[0,1])
print(np.argmax(A,0)[0])
print(np.max(A,1))
#print(A[0,-1])

#B = np.zeros((10,2))
#print(B)

#C = np.ones((15,3))
#print(C)
#print(C.shape)

#D = np.random.random((12,4))

#multipelybyscaler
#C = 5* C
#print(C)

#E = np.random.randint(1,10)
#print(E)

#print(D)
#print(np.max(D,0))
#E = np.random.randint(0,10,(10,8))
#print(E)
#print(np.argmax(E,0))
#print(np.max(E,1))
#print(np.sum(E,1))
#print(np.sum(E,1).shape)
#print(E[A,:])

#M = np.random.random((5,4))
#N = 2* np.random.random((5,4)) -1
#print(M*N)