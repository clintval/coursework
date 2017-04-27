function prob1

clear all;

global eta lokd u90 counter; % declare global variables

%% Problem 1a

lokd = 1;
eta = 2; 

u=0:0.01:2;         % set a range of values for u
rhsu = rhs(u);      % evaluate right hand side of the differential equation
plot(u,rhsu, '-k', u, zeros(length(u),1),':k');  % generate phase portrait
xlabel('u');ylabel('du/d\tau');

% we see that there are fixed points near u=0.2 and 1.7. Use these as
% initial guesses to determine values of fixed points more precisely.

fixpt=fsolve(@rhs,0.2);
hold on;
plot(fixpt,0,'o','MarkerEdgeColor','k','MarkerFaceColor','k');  % solid for stable
text(1.01*fixpt,.05,num2str(fixpt,3));

fixpt=fsolve(@rhs,1.7);
hold on;
plot(fixpt,0,'o','MarkerEdgeColor','k','MarkerFaceColor','w');  % empty for unstable
text(1.01*fixpt,.05,num2str(fixpt,3));


%% Problem 1b


figure; 
i=1;
for eta = [0.1, 1, 10]
    [t1, u1]=ode45(@dudt, [0, 3], 0.1);
    uss(i) = u1(length(u1));    % assign steady-state value to be the last time point.
    plot(t1,u1);
    hold on;
    i=i+1;
end
xlabel('\tau');
ylabel('u');
legend('\eta = 0.1', '\eta = 1', '\eta = 10', 'Location','northwest');


%% Problem 1c

u90=[0.9 0.9 1.1].*uss; % find tau when u=90% of steady-state.
counter=1;
for eta = [0.1, 1, 10]
    options = odeset('Events', @events);
    [t2, u2, TE, YE, IE]=ode45(@dudt, [0, 3], 0.1, options);
    tau90(counter) = TE;
    t90(counter) = TE/0.12; % where k_r = 0.12 min^-1 for EGF/EGFR.
    counter=counter+1;
end

uss
u90
tau90
t90



function F = rhs(u)

global eta lokd; % declare global variables

    F=lokd*(1-eta*u).*(1-u)-u;      % the operate .* is different from *. See Matlab help.
                                  


function F = dudt(t,u)

global eta lokd; % notice that by declaring these as global variables, there values are 
                 % maintained from that held in the main function Prob1.

    F=(1-eta*u)*(1-u)-u;


function [value,isterminal,direction] = events(t,u)
% Locate the time when u equals u90 and stop integration.
global u90 counter;

value = u-u90(counter);     % Detects when u-u90 hits 0 (i.e., when u=u90)
isterminal = 1;             % Stop the integration
direction = 0;              % Negative or positive direction 

