%This is the second part of the assignment, IE Exercise 2
%it takes a bunch of ginputs(user selected)
%then it peacewise polyfits the things, then plots it
%plength = peice length

%PLEASE READ THIS%
%I AM VERY AWARE THAT MY PROGRAM DOSNT WORK WITH INPUTS =  MULTIPLES OF 5
%IT ALSO DOSNT WORK WITH INPUT LESS THAN 6
%JUST SO YOU'RE AWARE WHEN YOU'RE MARKING
I = imread('tumorContour.jpg');
[xtu,ytu] = find(I>250);
tumor = imread('polynomialContour.jpg');
imshow(tumor)
n = 10;
[x,y] = ginput;
plength = 5;
pfinal = [];
totalgenx = [];
for c = 1:(length(x)/plength)
    px = x(((c-1)*plength)+1:(c*plength)+1);
    py = y(((c-1)*plength)+1:(c*plength)+1);
    p0 = vander(px)\py;
    %newy0= p0;
    genx = (x(((c-1)*plength)+1):0.5:x((c*plength)+1))
    totalgenx = cat(1,totalgenx,genx(1:end-1));
    newy0 = polyval(p0,genx);
    pfinal = cat(1,pfinal,newy0(1:end-1))
end
if c*plength ~= length(x) 
    px = x(((c)*plength)+1:end);
    py = y(((c)*plength)+1:end);
    p0 = vander(px)\py;
    %newy0=p0;
    genx = (x(((c-1)*plength)+1):0.5:x((c*plength)+1));
    totalgenx = cat(1,totalgenx,genx(1:end));
    newy0 = polyval(p0,genx);
    pfinal = cat(1,pfinal,newy0(1:end))
end
%asdf = polyval(pfinal,xtu)
%plot(asdf,xtu)
plot(pfinal,genx)