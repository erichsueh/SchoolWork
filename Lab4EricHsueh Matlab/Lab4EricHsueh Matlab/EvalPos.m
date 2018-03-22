function pos = EvalPos(M,theta)
pos = (M{1}* RZ(theta(3)) * RY(theta(2)) * RX(theta(1)) * M{2} * RX(theta(4)) * M{3})
end