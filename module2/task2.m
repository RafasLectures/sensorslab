%addpath '/Users/Rafa/Documents/git/unilectures/sensorslab'
clc;
clear;
close all

%% Load Steady data
load('data/dataAligned51TF.mat');
data2a = rawDataArduino;
load('data/dataOffsetTFXZFlipped.mat');
dataXZflipped = rawDataArduino;
load('data/dataOffsetTFXYFlipped.mat');
dataXYflipped = rawDataArduino;
%% Variable definitions
magneticFieldRaw2a = [data2a(:,2) data2a(:,3) data2a(:,4)];
magneticFieldRaw2b = [dataXZflipped(:,2) dataXYflipped(:,3) dataXZflipped(:,4)];
t = 1:size(magneticFieldRaw2a,1);

%% Magnetic field conversion
magneticField2a = (magneticFieldRaw2a/16)*1e-6;
magneticField2b = (magneticFieldRaw2b/16)*1e-6;

%% Take mean from pressure and acceleration
magneticFieldMean2a = mean(magneticField2a);
magneticFieldMean2b = mean(magneticField2b);

sensorOffset = (magneticFieldMean2a + magneticFieldMean2b)/2;

fprintf('Magnetic Field Mean X: %d  std: %d\n',magneticFieldMean2a(1), std(magneticField2a(:,1)));
fprintf('Magnetic Field Mean Y: %d  std: %d\n',magneticFieldMean2a(2), std(magneticField2a(:,2)));
fprintf('Magnetic Field Mean Z: %d  std: %d\n',magneticFieldMean2a(3), std(magneticField2a(:,3)));

fprintf('Flipped Magnetic Field Mean X: %d  std: %d\n',magneticFieldMean2b(1), std(magneticField2b(:,1)));
fprintf('Flipped Magnetic Field Mean Y: %d  std: %d\n',magneticFieldMean2b(2), std(magneticField2b(:,2)));
fprintf('Flipped Magnetic Field Mean Z: %d  std: %d\n',magneticFieldMean2b(3), std(magneticField2b(:,3)));

fprintf('Offset X: %d\n', sensorOffset(1));
fprintf('Offset Y: %d\n', sensorOffset(2));
fprintf('Offset Z: %d\n', sensorOffset(3));

save('data/sensorOffset','sensorOffset')
