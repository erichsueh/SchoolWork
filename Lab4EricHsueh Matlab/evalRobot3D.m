function [pos,J] = evalRobot3D(M,theta)
alpha = 0.001;
pos = EvalPos(M,theta);

J1 = (EvalPos(M,theta+[alpha;0;0;0]) - EvalPos(M,theta-[alpha;0;0;0]))/(alpha*2);
J2 = (EvalPos(M,theta+[0;alpha;0;0]) - EvalPos(M,theta-[0;alpha;0;0]))/(alpha*2);
J3 = (EvalPos(M,theta+[0;0;alpha;0]) - EvalPos(M,theta-[0;0;alpha;0]))/(alpha*2);
J4 = (EvalPos(M,theta+[0;0;0;alpha]) - EvalPos(M,theta-[0;0;0;alpha]))/(alpha*2);
J = [J1 J2 J3 J4];

%J = J(1:3,1:4);
end
