clear; clc;
filename = "gyroscopeRaw.mat";

load(filename);
rawData = table2array(gyroscopeRaw);
mean = mean(rawData,1);
