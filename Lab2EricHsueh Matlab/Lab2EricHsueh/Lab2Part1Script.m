%ScriptRunning polynomial for (0:0.1:2^(1/n)*m*pi)
%This is part 1 of the assignemnt, it triesits best to call polynomial
%interpol in order to find the new Y
%then it plots the graphs.
n = 10;
m = 3;
X_new = (0:0.1:2^(1/n)*m*pi);
y = sin(0:0.5:m*pi);
x = (0:0.5:m*pi);
Y_new = polynomialinterpol(x,y,X_new,n);
norm(Y_new - sin(X_new));
plot(X_new,Y_new,X_new,sin(X_new))

%this is the error
%The answers for m at degree X is = 
%for m = .5 4 = 3.5619
%for m = 1 4 = 4.4860
%for m = 3 6 = 10.6578
%for m = 2 6 = 5.3783