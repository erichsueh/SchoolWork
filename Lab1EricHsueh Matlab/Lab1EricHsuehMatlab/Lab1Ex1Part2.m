%This uses the lenna image that's included with the files, and does the
%script details to it. Click on run to run the entire thing
% Sample script  that shows how to automate running problem solutions
close all;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% a) Load an image using the imread command 
x = imread('Lenna.jpg');
figure (1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% b) Display original image in the first spot of a 2 x 3 a grid layout
%    Check the imshow and subplot commands.
subplot(2,3,1);
figure1 = imshow(x)


pause();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% c) Display a gray scale version of the image in position 2 of the grid.
%    help rgb2gray
subplot(2,3,2);
grey = rgb2gray(x);
imshow(grey)
pause();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% d) Generate a new figure and ask user to manually select a region of the
%    image. Display the subimage in position 3 of the grid.
%    Hint--> getrect()

figure (2);
y = imread('Lenna.jpg');
imshow(y);
rect = getrect
smaller = y(rect(1):rect(4)+rect(1),rect(2):(rect(2)+rect(3)),:);
% Get user input on a newly dislayed image

% Make grid the current figure

% Display selected region. Note the last : which applies the cut
% over all 3 channels.
figure(1)
subplot(2,3,3)
imshow(smaller);

pause();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% e) Create a function J = luminance_change(I, option, value) such that:
%   * When given the option 'c', image I's contrast will be modified by
%     the given value. Simple multiplication will achieve this.
%   * When given the option 'b', image I's brightness will be modified by
%     the given value. Simple addition will achieve this.
%  
%   Showcase your function by filling positions 4 and 5 in the grid

% Contrast change
subplot(2,3,4);
lumi = 5*x;
imshow(lumi)
pause();

% Brightness change
subplot(2,3,5);
b = ones(400,400,3,'uint8');
bright = x+(b*200);
imshow(bright)
pause();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% f) BONUS: Display a version of the image after it's been blurred using a
%    Gaussian filter. Hint: imgaussfilt()
subplot(2,3,6)
gauss = imgaussfilt(x,5);
imshow(gauss)