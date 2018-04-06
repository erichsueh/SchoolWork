function [ynew] = polynomialinterpol(X,Y,X_new,n)
%i = 0;
A=[];
[~,arrsize] = size(X);

for i = 1:arrsize
    B = [1];
    for a = 2:n
        firstnumb = X(i);
        B = [B,power(firstnumb,a)];
    end
    A = [A;B];
end
b = Y';
A = A
ynew = A\b
ynew = ynew';
newY = [];
[~,arrsize] = size(ynew);
[~,otherarray] = size(X_new);
for i = 1:otherarray
    newvary = 0;
    for a = 1:arrsize
        newvary = newvary + ynew(a)*(X_new(i)^a-1);
    end
newY = [newY,newvary];
end

ynew = newY;
end