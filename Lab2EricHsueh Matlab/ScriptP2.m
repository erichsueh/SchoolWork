%This is the second part of the assignment, IE Exercise 2
%it takes a bunch of ginputs(user selected) and then mapps
%it does polyfitting twice
I = imread('tumorContour.jpg');
[xtu,ytu] = find(I>250);
tumor = imread('polynomialContour.jpg');
imshow(tumor)
n = 43;
[y1,y2] = ginput(n);
x = 1:n;
y1 = y1';
y2 = y2';
p1 = polyfit(x,y1,n);
p2 = polyfit(x,y2,n);
newy1 = polyval(p1,xtu);
newy2 = polyval(p2,xtu);
plot(xtu,newy1)