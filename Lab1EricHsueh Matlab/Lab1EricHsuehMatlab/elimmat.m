%this is the elimmat function which recursivly calls itself to fill up a L
%and a U
function [M,L] = elimmat(A,k)
    if ~exist('k')  % If first call no k param given, but k=1
      k=1;
    end
  
    [m,n]=size(A);
    counter = k+1;
    Msub = eye(m);
    
    while counter < m+1 %filing up msub
        Msub(counter,k)= -(A(counter,k)/A(k,k));
        counter = counter+1;
    end
    if k < n-1 % Recursion step
        pass = Msub*A;
        [MassiveM,MassivInv] = elimmat(pass,k+1);
    else
        MassiveM = eye(m);
        MassivInv = 1;
    end
    
    M = MassiveM*Msub;
    
    if k ==1
        L = inv(M);
    else
        L = MassivInv;
    end
    
    
end
