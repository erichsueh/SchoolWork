%i = 1
%while i < 40
%Ii = renderim(Y(:,i),B,imsize); imshow(Ii,[]); drawnow; pause(0.1);
%i = i +1;
%end
%constructing basis based off of sin(ax)cos(bt) + cos(ax)sin(bt)
% effect of changing b is changing the initial image
clear;
load('sincos_basis.mat');
sin2ax = 2 * B(:,1) .* B(:,2);
cos2ax = (2 * (B(:,2).^2))-1;
newB = [sin2ax cos2ax];
i = 1;
while i < 40
Ii = renderim(Y(:,i),newB,imsize); imshow(Ii,[]); drawnow; pause(0.1);
i = i +1;
end