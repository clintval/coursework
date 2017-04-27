%% Problem Set 2
%  Clint Valentine
%  February 27th 2015
%  Biomolecular Control and Dynamics
%  Prof. Anand Asthagiri
%% Modeling Receptor-Ligand Trafficking
% To model the receptor-ligand trafficking system as proposed in the
% Problem Set #2 prompt we first make the assumptions that free surface
% ligand cannot enter an endocytic vessel unless bound to a surface
% receptor. We also assume that all outputs of the system, $\theta _{j}$
% where $j$ is equal to degraded species, disappear from the system and
% have no feedback. We also assume that because all species are degraded at
% some defined rate that there are no conserved species and therefore no
% mass balances in this system.
%
% <<elementary_rxns.jpg>>
%
% The rate laws defined are the rates of all of the variables in the system
% which are all time-dependent state variables. We chose not to model
% $\theta _{j}$ because it would provide no useful information at the
% moment. The code below converts the concentration of ligand to the
% molecular units of ligand and 
%
% <<rate_laws.jpg>>

kf     = 0.07;   % 1/(M x min)
kr     = 0.3;   % 1/min
kec    = 0.3;   % 1/min
ker    = 0.03;  % 1/min
krec   = 0.06;  % 1/min
kdeg   = 0.002; % 1/min
fdegr  = 0.2;
fdegl  = 0.2;
fdegc  = 0.5;  
rsynth = 100;   % units/min

% This function solves the system for no ligand (internal or external)

syms Rs(t) Ri(t);
b = dsolve(...
    diff(Ri, t) ==  ker*Rs -(1-fdegr)*krec*Ri -fdegr*kdeg*Ri,...
    diff(Rs, t) == -ker*Rs +(1-fdegr)*krec*Ri +rsynth,...
    Rs(0) == 0, Ri(0) == 0);

sRi = eval(limit(b.Ri, inf)); % steady-state at t=inf
sRs = eval(limit(b.Rs, inf)); % steady-state at t=inf

fprintf('Stable-state Ri per cell = %g\n', sRi);
fprintf('Stable-state Rs per cell = %g\n', sRs);

% Assuming ligand is added when receptor expression maintains a
% steady-state level.

cells = 5e5;   % Units
Lo = 1e-9;     % Molar
Volume = 3e-3; % Liters
Av = 6.02214129e23; % Avagadro's Number

iRi = cells * sRi;
iRs = cells * sRs;
iCi = 0;
iCs = 0;
iLi = 0;
iLs = Lo * Volume * Av; 

% Function code in ps2function.m kept in same directory
% function f = ps2function(t,Y)
%     f(1,1)= -.048*Y(1)+.03*Y(2)-7.2*10^-7*Y(1)*Y(5)+.3*Y(3)-.0004*Y(1);
%     f(2,1)= .048*Y(1)-.03*Y(2)-7.2*10^-7*Y(2)*Y(6)+.3*Y(4)+100;
%     f(3,1)=-.03*Y(3)+.3*Y(4)+7.2*10^-7*Y(1)*Y(5)-.3*Y(3)-.001*Y(3);
%     f(4,1)=.03*Y(3)-.3*Y(4)+7.2*10^-7*Y(2)*Y(6)-.3*Y(4);
%     f(5,1)=-7.2*10^-7*Y(5)*Y(1)+.3*Y(3)-.0004*Y(5);
%     f(6,1)=-7.2*10^-7*Y(6)*Y(2)+.3*Y(4); 
% end

sol = ode45(@ps2function,[0 4], [iRi iRs iCi iCs iLi iLs]);

time = sol.x;
Lsplot = sol.y(6,:);
Lpoundplot = sol.y(3,:) + sol.y(5,:);
Csplot = sol.y(4,:);

plot(time, Lsplot, time, Lpoundplot, time, Csplot);

h = xlabel('Time (min.)', 'FontSize', 12);
set(h, 'Interpreter', 'latex');
h = ylabel('Molecular Units $\cdot$ $10^{10}$', 'FontSize', 12);
set(h, 'Interpreter', 'latex');
h = title('Time Evolution of Surface Complex and Ligands', 'FontSize', 12);
set(h, 'Interpreter', 'latex');

grid on;
legend('Ls', 'L#', 'Cs');
%%
% The plot shows that total surface ligand is immediately consumed in a 1:1
% ratio for the available steady-state receptors on the surface of the
% cells in solution. This happens on a time scale which appears
% instantaneous. Over time surface ligand is consumed through the system
% and degraded. This occurs slowly as receptor synthesis attempts to keep
% up with the high intial ligand concentration. The quantity of internal
% ligand increases with time starting at a value of zero. We hypothesize
% that this value will reach zero ligand as time goes to infinity. We
% expect this because no new stock of ligand are supplied and ligand is
% continually degraded at a set rate.
%
% We simulated this for four minutes which took an excess of 15
% computaional minutes. With more computation time, it would be interesting
% to see if our hypothesis is supported.
%% Enzyme Kinetics
%
% #
% Product formation is the greates at initial time (i.e. $t=0$) because
% of the equation derived from complex formation at quasi-steady state:
% $\frac{dP}{dt}=\frac{k_{2}E_{o}S}{K_{m}+S}$
% When $\frac{dP}{dt}$ is at $t=0$ substrate concentration is at its
% highest. As time passes, substrate concentration decreases which
% corresponds to lesser values of $\frac{dP}{dt}$ until substrate is nearly
% exhausted $S=0$. As $\lim_{t\to\infty}$ the value for $\frac{dP}{dt}$
% nears zero due to subtrate nearing 0 mM.
%
% #
% By examining the Michaelis-Menten graph of reaction velocity vs.
% substrate concentration it is apparant that the maximum velcocity is when
% substrate concentration increases to infinity. The value for $V_{max}$ is
% theoretical because of this non-realistic infinity parameter. As
% substrate concentration increases more of the enzymes will be in the
% bound state and actively catalyzing product formation. Only when there is
% such a high concentrate of substrate that an enzyme has no idle time will
% the reaction reach the theoretical $V_{max}$