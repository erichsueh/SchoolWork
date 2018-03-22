mode = 1;
n = 10000;
ls=[0.5,0.5]';
t=rand(2,1); %Choose some random starting point.

clf;
plotRobot2D(ls,t);
hold off;
desired=ginput(1)'; %Get desired position from user
clf;
plot(desired(1),desired(2),'*');
hold on;
plotRobot2D(ls,t,':');
%Solve and display the position
tic
t=invKin2D(ls,t,desired,n,mode);
toc
mode = 0;
tic
t=invKin2D(ls,t,desired,n,mode);
toc

%When Comparing the two modes, most of the time Mode 1 ( the on with
%broyden's method) is faster than mode 0 (newton's method)