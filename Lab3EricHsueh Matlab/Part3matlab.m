img = double(imread('simple-black-and-white-earth-hi.png'));
img = rgb2gray(img);
imsize = size(img);
[Fx,Fy] = gradient(img);
img = reshape(img,[],1);
Fx = reshape(Fx,[],1);
Fy = reshape(Fy,[],1);
dothis = [img Fx Fy];
Y = [ones(1,13)
    0 3:6 zeros(1,4) 3:6
    0 zeros(1,4) 3:6 3:6];
%effect of chaning larger values of Y becomes a greater shift
i = 1;
while i < 13
Ii = renderim(Y(:,i),dothis,imsize); imshow(Ii,[]); drawnow; pause(0.1);
i = i +1;
end