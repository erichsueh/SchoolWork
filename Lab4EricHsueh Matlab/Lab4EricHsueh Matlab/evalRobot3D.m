function [pos,J] = evalRobot3D(M,theta)
alpha = 0.01;
pos = Evalpos(M,theta);
pos = pos(1:3,:);
J1 = (Evalpos(M,theta+[alpha;0;0;0]) - Evalpos(M,theta-[alpha;0;0;0]))/alpha*2;
J2 = (Evalpos(M,theta+[0;alpha;0;0]) - Evalpos(M,theta-[0;alpha;0;0]))/alpha*2;
J3 = (Evalpos(M,theta+[0;0;alpha;0]) - Evalpos(M,theta-[0;0;alpha;0]))/alpha*2;
J4 = (Evalpos(M,theta+[0;0;0;alpha]) - Evalpos(M,theta-[0;0;0;alpha]))/alpha*2;
J = [J1 J2 J3 J4];
J = J(1:3,1:4);
end
