function theta = invKin2D(l,theta0,pos,n,mode)
%alpha = 0.01;
k = 0;
if mode == 0
    while k < n
        [pos1,Jac] = evalRobot2D(l,theta0);
        if norm(pos1-pos) < .01
            break
        end
        diff = (Jac\-(pos1-pos));
        %theta0 = theta0;
        theta0 = theta0 + diff;
        k = k+1;
    end
else
    [~,B0] = evalRobot2D(l,theta0);
    while k < n
        
        diff = (B0\-pos);
        theta0 = theta0 + diff;
        k = k+1;
        pos1 = [(l(1)* cos(theta0(1))) + (l(2)*cos(theta0(1)+theta0(2)));l(1)*sin(theta0(1)) + l(2)*sin(theta0(1)+theta0(2))];
        if norm(pos1-pos) < .2
            break
        end
        yk = pos1 - pos;
        B0 = B0 + ((yk - B0*diff)*diff')/(diff'*diff);
        
    end
    
end
k = k
theta = theta0;
end
