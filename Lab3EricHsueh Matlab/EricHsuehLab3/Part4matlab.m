load light_pca
new_x = -120:2:120;
%n=4;
new_Y = [];
for i = 1:length(Y)
    p = polyfit(X,Y(i,:),2);
    Ynew(i,:) = polyval(p, new_x);
end
for c = 1:size(Ynew,2)
  Ic = renderim(Ynew(:,c),B,imsize);
  imshow(Ic)
  drawnow
end