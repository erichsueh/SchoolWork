%This is part c of the assignment
%this is for the char_c1 matrix, where it imports the char_c1 matrix which
%spells out science, since I put a pause between each letter, you need to
%hit enter to see all the images
clear;
load('char_c1.mat');
counter = 1;
while counter <8
    scan = Bchar(:,counter);
    x= Achar\scan;
    x =reshape(x,imsize);
    x = x';
    imshow(x)
    counter = counter + 1;
    pause();
end
