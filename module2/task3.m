%addpath '/Users/Rafa/Documents/git/unilectures/sensorslab'
clc;
clear;
close all

%% Load Steady data
load('data/dataAligned51TF.mat');
load('data/sensorOffset.mat');

%% Variable definitions
magneticFieldRaw = [rawDataArduino(:,2) rawDataArduino(:,3) rawDataArduino(:,4)];
t = 1:size(magneticFieldRaw,1);

%% Magnetic field conversion
magneticField = ((magneticFieldRaw/16)*1e-6) - sensorOffset;

%% Take mean from pressure and acceleration
magneticFieldMean = mean(magneticField);

fprintf('Magnetic Field Mean X: %d  std: %d\n',magneticFieldMean(1), std(magneticField(:,1)));
fprintf('Magnetic Field Mean Y: %d  std: %d\n',magneticFieldMean(2), std(magneticField(:,2)));
fprintf('Magnetic Field Mean Z: %d  std: %d\n',magneticFieldMean(3), std(magneticField(:,3)));

%% Calculate field intensity
B_x = magneticFieldMean(1);
B_y = magneticFieldMean(2);
B_z = magneticFieldMean(3);

B_hor = sqrt(B_x^2 + B_y^2);
B_vert = B_z;

B = sqrt(B_x^2 + B_y^2 + B_z^2);

%% Calculate angle
declination = rad2deg(atan2(B_x,B_y));

%%
fprintf('B_x: %d\n',B_x);
fprintf('B_y: %d\n',B_y);
fprintf('B_z: %d\n',B_z);
fprintf('B_hor: %d\n',B_hor);
fprintf('B_vert: %d\n',B_vert);
fprintf('B: %d\n',B);
fprintf('declination: %d\n',declination);
% Result to compare from
% http://www.geomag.bgs.ac.uk/data_service/models_compass/wmm_calc.html
% X = 1.1412 uT
% Y = 21.2013 uT
% Z = 43.4783 uT
% B_hor = 21.232 uT
% B_vert = 43.4783 uT
% B = 48.385 uT
