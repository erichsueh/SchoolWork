%This is the complete function to run everything, this function calls
%"myLU" which returns a L and a U in my LU, it runs a function called
%elimmat which calls itself recursivly to return back L and U
%fwdSubst is the forward substitution that gives us the y for backwards sub
%to solve
%backSubst is the backwards substitution that takes the Upper triangle and
%the y to give us back our x
%In order to run this function correctly, you need to make sure that A and
%b are commented out (because these were the test A and b's)

function [x] =Lab1Ex2LUfunction(A,b)
A = [1,2,2;4,4,2;4,6,4];
b = [3;6;10];
[L,U] = myLU(A)
y = fwdSubst(L,b)
x = backSubst(U,y);



