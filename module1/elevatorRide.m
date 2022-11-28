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
conversionRateAccelertation = (8*9.81)/((2^15) - 1);
%accelerationSI = (accelerationRaw/16384)*9.81;
accelerationSI = accelerationRaw * conversionRateAccelertation;

%% Get mean of acceleration and pressure
accelerationMeanZ = mean(accelerationSI((t<=11),3));
accelerationZ = accelerationSI(:,3) - accelerationMeanZ;

%accMovingAverageZ = movingAverage(accelerationZ,30);

a = movmean(accelerationZ,5);
v = cumtrapz(t,a);
p = cumtrapz(t,v);

plotData(t,p, 'Position from velocity integration', ...
              'Time [s]', ...
              'Position [m]');
plotData(t,v, 'Velocity from acceleration integration', ...
              'Time [s]', ...
              'Velocity [m/s]');
plotData(t,a, 'Acceleration from Arduino Nicla', ...
              'Time [s]', ...
              'Acceleration [m/s^2]');

%% Get height from pressure data
pressureMean = mean(pressureRaw((t<=11),1));
T = 20+273;
heightFromPressure = (log(pressureMean./pressureRaw)*8.314*T)/(accelerationMeanZ*0.02896);
%heightFromPressure = log(pressureMean * pressureRaw.^-1) * 8.314 * T / (accelerationMeanZ * 0.02896);
%% Plot pressure sensor data

plotData(t,pressureRaw, 'Pressure from Arduino Nicla', ...
              'Time [s]', ...
              'Pressure [hPa]');
plotData(t,heightFromPressure, 'Height from pressure', ...
              'Time [s]', ...
              'Elevator Height [hm]');

function plotData(x, y, currentTitle, xLabel, yLabel)
    fig = figure('DefaultAxesFontSize',30);
    fig.Position = [100 100 1200 1000];
    grid on
    plot(x,y);
    title(currentTitle)
    xlabel(xLabel, 'FontSize', 30);
    ylabel(yLabel, 'FontSize', 30);
    % legend(legend,'Location','northwest')
end

function y = movingAverage(data, windowSize)
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    y = filter(b,a,data);
end

