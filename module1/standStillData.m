%addpath '/Users/Rafa/Documents/git/unilectures/sensorslab'
clc;
clear;
close all

%% Load Steady data
load('data/standStillRaw.mat');

%% Variable definitions
accelerationRaw = [rawDataArduino(:,3) rawDataArduino(:,4) rawDataArduino(:,5)];
pressureRaw = rawDataArduino(:,2);
t = 1:size(pressureRaw);


%% Convert acceleration to SI values
accelerationSI = (accelerationRaw/16384)*9.81;

%% Take mean from pressure and acceleration
accelerationMean = mean(accelerationSI);
pressureMean = mean(pressureRaw);

fprintf('Pressure Mean: %d\n',pressureMean);
fprintf('Acceleration Mean X: %d  std: %d\n',accelerationMean(1), std(accelerationSI(:,1)));
fprintf('Acceleration Mean Y: %d  std: %d\n',accelerationMean(2), std(accelerationSI(:,2)));
fprintf('Acceleration Mean Z: %d  std: %d\n',accelerationMean(3), std(accelerationSI(:,3)));

plotData("Pressure", "Pressure [hPa]", t, pressureRaw, pressureMean, true);
plotData("Acceleration X", "Acceleration [m/s^2]", t, accelerationSI(:,1), accelerationMean(1), true);
plotData("Acceleration Y", "Acceleration [m/s^2]", t, accelerationSI(:,2), accelerationMean(2), true);
plotData("Acceleration Z", "Acceleration [m/s^2]", t, accelerationSI(:,3), accelerationMean(3), true);

function plotData(sensor, unit, t, data, mean, fitDistribution)
    fig = figure('DefaultAxesFontSize',30);
    fig.Position = [100 100 1200 1000];
    subplot(1,2,1);
    scatter(t, data, 'filled');
    title(sprintf("%s raw data", sensor));
    xlabel("Sample", 'FontSize', 30);
    ylabel(unit, 'FontSize', 30);
    yline(mean, LineWidth=2, Color='red');
    legend("Raw value", "Mean",'Location','northwest');
    
    subplot(1,2,2);
    if (fitDistribution)
        histfit(data-mean);
    else
        histogram(data-mean);
    end
    
    title(sprintf("%s data - mean histogram", sensor));
    xlabel(unit, 'FontSize', 30);
    ylabel("Number of samples", 'FontSize', 30);

    %% Save plot as PDF
    
    fig.Units = 'centimeters';        % set figure units to cm
    fig.PaperUnits = 'centimeters';   % set pdf printing paper units to cm
    fig.PaperSize = fig.Position(3:4);  % assign to the pdf printing paper the size of the figure
    print(fig,sprintf('./report/plots/plot%s',sensor),'-dpdf','-r0')
end