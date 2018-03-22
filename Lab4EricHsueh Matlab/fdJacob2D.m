function J = fdJacob2D(l,theta,alpha)
%theta = theta';
J1 = (evalRobot2D(l,theta+[alpha;0])-evalRobot2D(l,theta-[alpha;0]))/(2*alpha);
J2 = (evalRobot2D(l,theta+[0;alpha])-evalRobot2D(l,theta-[0;alpha]))/(2*alpha);
J = [J1 J2];

%the results are close enough to be useful
% you would use this finite - different approximation instead because it's
% much faster than using an analytic derivation every time.