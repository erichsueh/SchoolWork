%ScriptRunning polynomial for (0:0.1:2^(1/n)*m*pi)
n = 6;
m = 2;
X_new = (0:0.1:2^(1/n)*m*pi);
y = sin(0:0.5:m*pi);
x = (0:0.5:m*pi);
Y_new = polynomialinterpol(x,y,X_new,n)
norm(Y_new - sin(X_new))
plot(X_new,Y_new,X_new,sin(X_new))

%for m = .5 4 = 3.5619
%for m = 1 4 = 4.4860
%for m = 1.5 6 = 5.6417
%for m = 2 6 = 5.3783