clear
close all

% Initialization
S = 300; I = 700; R = 10; N = S + I + R;
% Note that R refers to resistant in this case, not recovered

% Infectivity
a_0 = 10;
p_trans = 0.2;
a = a_0 * p_trans;
% Varying a while holding everything else constant effects order of SIR
% percentages in magnitude

% beta > betaI
% deltaI > delta
% beta > delta
% deltaI > betaI

% Birth rates (Suspectible & Infected)
beta = 0.3;
betaI = 0.2;
% Units of 1/hour

% Death rates (Suspectible & Infected)
delta = 0.2;
deltaI = 0.5;
% Units of 1/hour

tmax = 400; % Days
dt = 1/2; % 1 hour (Timestep)
clockmax = tmax/dt; % Number of timesteps

tsave = zeros(1,clockmax);
Ssave = zeros(1,clockmax);
Isave = zeros(1,clockmax);
Rsave = zeros(1,clockmax);
Nsave = zeros(1,clockmax);
lambdasave = zeros(1,clockmax);

% Main Loop
for clock = 1:clockmax
    t = clock*dt;
   
    P_0 = (S + I)/N + (R/N)/2;
    P_0100 = ((S + I)/N)/2 + (R/N)/4;
    P_0001 = (R/N)/2;
    P_0101 = ((S + I)/N)/2 + (R/N)/2;
    
    B_S = (beta*S + betaI*I)*P_0 + beta*R*P_0100;
    B_R = (beta*S + betaI*I)*P_0001 + beta*R*P_0101;
    
    dS = dt*(B_S - delta*S - a*(I/N)*S);
    dI = dt*(a*(I/N)*S - deltaI*I);
    dR = dt*(B_R - delta*R);
    dN = dS + dI + dR;
    S = S + dS;
    I = I + dI;
    R = R + dR;
    N = S + I + R;
    lambda = (1/N)*dN;
    
    tsave(clock) = t;
    Ssave(clock) = S;
    Isave(clock) = I;
    Rsave(clock) = R;
    Nsave(clock) = N;
    lambdasave(clock) = lambda;
end

subplot(3,1,1) % SIR graph
plot(tsave, Ssave, tsave, Isave, tsave, Rsave, tsave, Nsave)
legend("Susceptible","Infected","Resistant","Total Female Population")
title("SIR Plot by Number of People")
xlabel("Days")
ylabel("Number of People")

subplot(3,1,2) % Percent of Pop Graph
plot(tsave, Ssave./Nsave, tsave, Isave./Nsave, tsave, Rsave./Nsave)
legend("Susceptible","Infected","Resistant")
title("SIR Plot by Percentage of People")
xlabel("Days")
ylabel("Percent of Population")

subplot(3,1,3) % Growth Rate Graph
plot(tsave, lambdasave, 'g-')
title("Population Growth Rate")
xlabel("Days")
ylabel("Growth Rate")