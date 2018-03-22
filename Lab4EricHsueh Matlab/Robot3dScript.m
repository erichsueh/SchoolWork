load('walk1.mat')
load('human_data.mat')
addpath /cshome/vis/data
robot3D('new');
i = 1;
n = 28;
theta1 = [0.1;0.1;0.1;0.1];
theta2 = [0.1;0.1;0.1;0.1];

while i < n
    theta1= invKin3D(Ml,theta1,L(:,i));
    theta2 = invKin3D(Mr,theta2,R(:,i));
    i =i +1;
    a=[theta1',theta2']
    pause(0.01);
    robot3D(humanInterp(drad,a'))
end
