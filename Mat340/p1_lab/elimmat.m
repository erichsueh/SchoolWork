function [M,L] = elimmat(A,k)

    [m,n]=size(A);
    
    Msub = %todo
    
    if k < n % Recursion step
        pass = Msub*A;
        [MassiveM,MassivInv] = elimmate(pass,k+1);
    else
        MassiveM = eye(m);
        MassivInv = 1;
    end
    
    M = Msub * MassiveM;
    
    if k ==1
        L = inv(M);
    else
        L = MassivInv;
    end
    
    
end
