function [pos,J] = evalRobot2D(l,theta)
pos = [(l(1)* cos(theta(1))) + (l(2)*cos(theta(1)+theta(2)));
    l(1)*sin(theta(1)) + l(2)*sin(theta(1)+theta(2))];
J = [-l(1)*sin(theta(1)) - l(2)*sin(theta(1)+theta(2)),-l(2)*sin(theta(1)+theta(2));
    l(1)*cos(theta(1)) + l(2)*cos(theta(1)+theta(2)),l(2)*cos(theta(1)+theta(2))];
