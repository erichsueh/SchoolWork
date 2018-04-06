p = polyfit(e1.x,e1.y,10);
y1 = polyval(p,e1.xx);
norm (y1-e1.yy)
plot(e1.xx,e1.yy,e1.xx,y1);