function theta = invKin3D(M,theta0,pos)
k = 0;
n = 1000;
while k < n
        [pos1,Jac] = evalRobot3D(M,theta0);
        if norm(pos1-pos) < .01
            break
        end
        diff = (Jac\(pos-pos1));
        %theta0 = theta0;
        theta0 = theta0 + diff;
        k = k+1;
end
theta= theta0;
end