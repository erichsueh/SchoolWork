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