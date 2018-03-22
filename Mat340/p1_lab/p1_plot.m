n = 25;
x = 0:1/n:3;
y = sin (5*x);
plot(x,y);
hold;
f = cos(5*x);
plot(x,f,'r*');

%print -depsc sin.eps;

