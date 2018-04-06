%This is part 1 of exercise 3, for this exercise, I'm assuming that when it
%says "Matlab's built in LU routine" it asks us to use linsolve(A,b)
A = [0,0,0,0,0,0,1,1,1;
    0,0,0,1,1,1,0,0,0;
    1,1,1,0,0,0,0,0,0;
    0,0,0,0,0,1,0,1,1;
    0,0,1,0,1,0,1,0,0;
    1,1,0,1,0,0,0,0,0;
    0,0,1,0,0,1,0,0,1;
    0,1,0,0,1,0,0,1,0;
    1,0,0,1,0,0,1,0,0;
    0,1,1,0,0,1,0,0,0;
    1,0,0,0,1,0,0,0,1;
    0,0,0,1,0,0,1,1,0];
rank(A);
b = [13;15;8;14.79;14.31;3.81;18;12;6;10.51;16.13;7.04];
tic
slashx= A\b;
toc
cond(A);
imshow(slashx);%shows 1 line of different shades, because i didn't bother reshaping it
tic
linx=linsolve(A,b);
toc

%after a couple of runs, it looks like lin solve is faster than the \
%operator for the most part, there are a couple of times where the \
%operator is faster than linsolve
%checking the rounding, they're both the same value. It seems like linsolve
%is more consistant where as the backslash operator is very non consistant
%in its solving time.