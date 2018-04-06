function im_new = renderim(Y_new,B,imsize,NrB)

if(nargin<4)
  NrB = size(B,2);
end

if imsize(1)*imsize(2)~=size(B,1)
  fprintf('Incompatible image size\n');
  return;
end

im_new = reshape(B(:,1:NrB)*Y_new(1:NrB),imsize(1),imsize(2));
