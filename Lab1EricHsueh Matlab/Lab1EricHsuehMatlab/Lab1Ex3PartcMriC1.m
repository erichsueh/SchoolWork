%This is part c of the assignment
%this is for the mri_c1 matrix, where it imports the mri_c1 matrix which
%has multiple mri images in it,since i put a pause, you need to
%hit enter to see all the images
%make sure you clear the stuff from the first image.
clear;
load('mri_c1.mat');
counter = 1;
while counter <11
    scan = Bmri(:,counter);
    x= Amri\scan;
    x =reshape(x,imsize);
    x = x';
    imshow(x)
    counter = counter + 1;
    pause();
end