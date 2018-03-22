function d=humanInterp(drad,thetas)
bothlegs=[7     8     9    16    10    11    12    17];
d=fitradbas(drad(bothlegs,:),drad,10,thetas);
d(bothlegs)=thetas;
d(1:3)=0;