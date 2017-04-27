clear all;
global kf kr kfp krp keC keR krec kdeg fR fL fC Vs eta beta; 

kf=7.2E7;
kr=0.3;
kfp=kf*0.1;
krp=2*kr;
keC=0.3;
keR=0.03;
krec=0.06;
kdeg=0.002;
fR=0.2;
fL=0.2;
fC=0.5;
Vs=100;
n=5e5/3e-3; % in # cells per L
Nav = 6.022e23;
eta=Nav/n;
beta = Nav*1e-14;

[T,Y]=ode45(@rates,[0 500],[1e6 0 1e-9 2.5e5 0 0]); %Rs,Cs,Ls,Ri,Ci,Li
plot(T,Y(:,1),'-k',T,Y(:,2),'-r',T,Y(:,4),'-g',T,Y(:,5),'-m');
xlabel('Time (min)');
ylabel('Amount of receptor species');
h_legend=legend('R_s (#/cell)', 'C_s (#/cell)', 'R_i (#/cell)', 'C_i (#/cell)');
set(h_legend,'FontSize',14);

figure;
plot(T,Y(:,6),'-b');
xlabel('Time (min)');
ylabel('L_i (#/cell)');
set(h_legend,'FontSize',14);

figure;
plot(T,Y(:,3)*1e9,'-b');
xlabel('Time (min)');
ylabel('L_s (nM)');
set(h_legend,'FontSize',14);
