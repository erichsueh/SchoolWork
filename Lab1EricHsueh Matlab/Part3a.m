A = [1,0,0,1,0,0,1,0,0;
    0,0,0,1,1,1,0,0,0;
    1,1,1,0,0,0,0,0,0;
    0,0,0,0,0,1,0,1,1;
    0,0,1,0,1,0,1,0,0;
    1,1,0,1,0,0,0,0,0;
    0,1,1,0,0,1,0,0,0;
    1,0,0,0,1,0,0,0,1;
    0,0,1,0,0,1,0,0,1];
rank(A)
b = [6;15;8;14.79;14.31;3.81;10.51;13.13;18];
x= A\b
cond(A)

linsolve(A,b)
%when i tried to use my own LU method, it gave the error matrix is singular
%to working precision, so in this case A\b worked better