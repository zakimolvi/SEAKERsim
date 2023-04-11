clear all;

% y(1) -> CTL cell #
% y(2) -> target cells raji or set2 = f(t)
% y(3) -> killed frac=f([AMS](t))
% y(4) -> [AMS]=f(t)
% t is in hrs, conc in [nM]
 
ratio = 1 % 1:1 E/T 
seed = 1e4;

tspan = [0 500];
y0 = [ratio*seed; seed; 1e-10; 1e-7]; %initial conditions (cell seed amounts)

[t, y] = ode15s(@diffSEAKER, tspan, y0);

function dydt = diffSEAKER(t, y)

%We'll initialize constants first 
k = [];
%k = [CTL_growth_constant, CTL_death, target_growth, CTL_kill_rate, carrying_capacity];

% k(1) - CTL growth constant
%activation upon Ag stimulation after 30 min in culture
if (t <= 0.5)
    k(1) = growthConst(14*24); %before Ag stim
else
    k(1) = growthConst(8.0); %after
end

% k(2) - CTL_death constant
k(2) = 0.12*(1/24); %[percent/hour] from ref Macallan et al Eur J Immunol 2003

% k(3) - target growth constant 
k(3) = growthConst(24); %raji doubling time

% k(4) - CTL killing rate constant
k(4) = 1.33*60; % [1/hr] (Regoes et al PNAS 2007)

% k(5) - Carrying capacity in cells of culture vessel
% We will assume a T-75 flask (raji's are suspension cells, 
% which has 8.4e6 cells at confluency
k(5) = 8.4e6;

EC50 = 34.4; %nM from CPG/SET2 sup assay
dy3dt = (5*EC50^5*AMSRate(t, y(1)))/(y(4)^6*(EC50^5/y(4)^5 + 1)^2);
dydt = [
    k(1)*y(1)*(1-y(1)/k(5)) - y(1)*k(2) - y(1)*dy3dt;
    k(3)*y(2)*(1-y(2)/k(5)) - (y(2)/y(1))*exp(-t*k(4)) - y(2)*(dy3dt);
    dy3dt;
    AMSRate(t, y(1));
    ];
end

function k = growthConst(td)
% This function finds the growth constant of cells for logistic eq in [1/hrs]
% td -> cell doubling time [hrs]    
k = log(2)/td;
end

function dAMSdt = AMSRate(t, y1)
% Returns rate of formation of AMS in nM/hr
% t-> time in hours
% y1 -> T cells present
% V_media -> volume of culture media in LITERS to get concentration
V_media = 10e-3;
%We'll assume that the SEAKERs produce 5e6 molecules CPG2 per cell per day,
%thus:
% (5e6/24)*1e9/6.022e23 = 3.459e-10 %nmol CPG per cell per hour
E0 = (3.4595e-10)*(1/V_media)*(t*y1); % nM CPG as f(t, CTL numbers)

C_PAMS = 5e10; %nM concentration of P-AMS from SET2 assay TG did
kcat = 583/60; %[1/hr] from Curiel-Cancer Gene Therapy
Vmax = kcat*E0;
Km = 7000; %nM (Spooner et al Nature 2003).
dAMSdt = Vmax*(C_PAMS/(Km+C_PAMS));
end

%function dAMSdt = dC_AMS(E0)
% Returns rate of formation (nM/hr) of AMS at current time step using MM kinetics
% Using kcat and Vmax values found in refs. Change in future.
% E0 is initial CPG2 concentration passed from function above

%C_PAMS = 5000 %nM concentration from SET2 assay TG did
%kcat = 583/60; %[1/hr] from Curiel-Cancer Gene Therapy
%Vmax = kcat*E0;
%Km = 7000; %nM (Spooner et al Nature 2003).
%dAMSdt = Vmax*(C_PAMS/(Km+C_PMAS))
%end

function old_dy3dt = fracKilled()
% t-> time
% y1 -> CTL(t): # of CTL cells
%returns fraction of cells of interest killed by AMS at certain time point
E0 = C_CPG(t, y(1), V_media);
dAMSdt = dC_AMS(E0);
EC50 = 34.4; %nM EC50 of AMS based on SET2 assay

dC_AMS = kcat*C_CPG2; %[nM/hr] rate of AMS formation

y3 = 1./(1+(C_AMS/(EC50)).^(-5));

old_dy3dt=(5*EC50^5*dAMSdt)/(C_AMS^6*(EC50^5/C_AMS^5 + 1)^2); % killed per hour
end