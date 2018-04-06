%This is the forward substitution function that will take inputs L, b and
%then recursivly solves the function
function y = fwdSubst(L,b,k)

  [m,n]=size(L);
  if ~exist('k')  % If first call no k param given, but k=1
    k=1;
  end
  
  y=b(k)/L(k,k);
  if k < n % Recursion step
    l = [zeros(k,1);L(k+1:m,k)];
    new = b-y*l;
    y = [y;fwdSubst(L,new,k+1)];
  end