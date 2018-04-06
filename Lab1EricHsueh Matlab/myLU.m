function [L,U] = myLU(A)
[M,L] = elimmat(A);
U = M * A;