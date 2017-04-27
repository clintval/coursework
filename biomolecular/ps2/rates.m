function dy = rates(t,y)
global kf kr kfp krp keC keR krec kdeg fR fL fC Vs eta beta; 

dy=zeros(6,1);
Rs=y(1); Cs=y(2); Ls = y(3); Ri = y(4); Ci = y(5); Li = y(6);
dy(1) = -kf*Ls*Rs + kr*Cs - keR*Rs + krec*(1-fR)*Ri + Vs;
dy(2) = kf*Ls*Rs -kr*Cs - keC*Cs + krec*(1-fC)*Ci;
dy(3) = (-kf*Ls*Rs + kr*Cs + krec*(1-fL)*Li)/eta;
dy(4) = keR*Rs - kfp*Li*Ri/beta + krp*Ci - krec*(1-fR)*Ri - kdeg*fR*Ri;
dy(5) = keC*Cs + kfp*Li*Ri/beta - krp*Ci - krec*(1-fC)*Ci - kdeg*fC*Ci;
dy(6) = -kfp*Li*Ri/beta + krp*Ci - krec*(1-fL)*Li - kdeg*fL*Li;
