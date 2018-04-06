% Gaussian distr, Box-Mueller method
n = 400;
U = rand(2,n);
v = 2*pi*U(2,:);
G = ones(2,1)*sqrt(-2.*log(U(1,:))).*[cos(v);sin(v)];

plot(G(1,:),G(2,:),'.')
axis equal

% Transform
A = [1 .5
     .5 0.5];
t = [8; 1];
Y = A*G+t*ones(1,n);
plot(Y(1,:),Y(2,:),'.')
axis equal
hold on
plot(Y(1,:)-mean(Y(1,:)),Y(2,:)-mean(Y(2,:)),'.')
newY(1,:) = Y(1,:)-mean(Y(1,:));
newY(2,:) = Y(2,:)-mean(Y(2,:));
covY = newY * newY'
covY = covY/(size(newY,2)-1)
[V,D] = eig(covY)
%V = a unscaled
%V as vector
plot(2*sqrt(D(1,1))*[0 V(1,1)],D(1,1)*[0 V(2,1)],'g')
plot(2*sqrt(D(2,2))*[0 V(1,2)],D(2,2)*[0 V(2,2)],'r')
