function [x] =runall(A,b)
A = [1,2,2,5;6,4,4,2;8,4,6,4;8,6,8,9];
b = [3;6;10;2];
[L,U] = myLU(A);
y = fwdSubst(L,b)
x = backSubst(U,y);