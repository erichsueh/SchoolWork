%My LU function calls the elimmat fuction and then creates the L and the U
function [L,U] = myLU(A)
[M,L] = elimmat(A);
U = M * A;