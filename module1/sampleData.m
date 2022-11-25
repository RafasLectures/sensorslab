%addpath '/Users/Rafa/Documents/git/unilectures/sensorslab'
clc;
clear;
close all
%% Load Elevator ride data
load('data/elevatorRide.mat');

%% Variable definitions
samplePeriod = 0.1;               % Sample period of 100 ms.
Fs = 1/samplePeriod;

t = elevatorRideRaw(:,1) / 1000;  % Convert time stamp (originially ms) to seconds.
t = t(:) - t(1);

% Acceleration raw [X Y Z]
accelerationRaw = [elevatorRideRaw(:,3) elevatorRideRaw(:,4) elevatorRideRaw(:,5)];
pressureRaw = elevatorRideRaw(:,2);

%% Convert acceleration to SI values
conversionRateAccelertation = (8*9.81)/(2^15); 
accelerationSI = accelerationRaw * conversionRateAccelertation;

%% Get mean of acceleration and pressure
accelerationMeanZ = mean(accelerationSI((t<=10),3));
accelerationZ = accelerationSI(:,3) - accelerationMeanZ;

accMovingAverageZ = movmean(accelerationZ,30);

a = accMovingAverageZ;
v = cumtrapz(t,a);
p = cumtrapz(t,v);
%{
N = length(t);



p =  zeros(N,1);
v =  zeros(N,1);
speedODE = @(t,x) [x*t];
for k=1:N % loop over control intervals
    v(k) = ode45(accelerationZ(k), [t(k) t(k+1)]);
    
    dt = t(k+1) - t(k);
    v(k+1) = rk4step(speedODE, dt, accelerationZ(k), t(k));
    p(k+1) = rk4step(speedODE, dt, v(k), t(k));
    %x(k+1,1) = rk4step(positionODE, dt, x(k,:), t(k));
    
end
%}
%{
f = @(x,u) [x(2); u]; % dx/dt = f(x,u)

speedModel = @(t,a) a*t;                    % change the function as you desireF_xy = @(t,r) 3.*exp(-t)-0.4*r;                    % change the function as you desire

for k=1:N-1 % loop over control intervals
    dt = t(k+1) - t(k);
    x(:,k+1) = x(:,k) + [dt   dt^2/2; ...
                        0    dt    ] * f(x(:,k),u(:,k));

end
%}
%velocityZ = accelerationMovingAverageZ


vPlot = figure('DefaultAxesFontSize',30);
vPlot.Position = [100 100 1200 1000];
grid on
plot(t,v);
xlabel('Time [s]', 'FontSize', 30);
legend('velocity [m/s]','Location','northwest')

aPlot = figure('DefaultAxesFontSize',30);
aPlot.Position = [100 100 1200 1000];
grid on
plot(t,a);
xlabel('Time [s]', 'FontSize', 30);
legend('acceleration [m/s^2]','Location','northwest')

pPlot = figure('DefaultAxesFontSize',30);
pPlot.Position = [100 100 1200 1000];
grid on
plot(t,p);
xlabel('Time [s]', 'FontSize', 30);
legend('position [m]','Location','northwest')


