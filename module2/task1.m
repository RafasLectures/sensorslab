%addpath '/Users/Rafa/Documents/git/unilectures/sensorslab'
clc;
clear;
close all

%% Load Steady data
load('data/data1aFrankfurt.mat');

%% Variable definitions
magneticFieldRaw = [rawDataArduino(:,2) rawDataArduino(:,3) rawDataArduino(:,4)];
t = 1:size(magneticFieldRaw,1);

%% Magnetic field conversion
magneticField = (magneticFieldRaw/16);
%% Take mean from pressure and acceleration
magneticFieldMean = mean(magneticField);

fprintf('Magnetic Field Mean X: %d  std: %d\n',magneticFieldMean(1), std(magneticField(:,1)));
fprintf('Magnetic Field Mean Y: %d  std: %d\n',magneticFieldMean(2), std(magneticField(:,2)));
fprintf('Magnetic Field Mean Z: %d  std: %d\n',magneticFieldMean(3), std(magneticField(:,3)));

plotData("MagFieldX", "$B_{\mathrm{X}}$", "Magnetic Field [$\mu\mathrm{T}$]", t, magneticField(:,1), magneticFieldMean(1), true);
plotData("MagFieldY","$B_{\mathrm{Y}}$", "Magnetic Field [$\mu\mathrm{T}$]", t, magneticField(:,2), magneticFieldMean(2), true);
plotData("MagFieldZ","$B_{\mathrm{Z}}$", "Magnetic Field [$\mu\mathrm{T}$]", t, magneticField(:,3), magneticFieldMean(3), true);

function plotData(fileName, sensor, unit, t, data, mean, fitDistribution)
    fig = figure('DefaultAxesFontSize',30);
    fig.Position = [100 100 1200 1000];
    subplot(1,2,1);
    scatter(t, data, 'filled');
    title(sprintf("%s raw data", sensor), 'Interpreter','latex');
    xlabel("Sample", 'FontSize', 30, 'Interpreter','latex');
    ylabel(unit, 'FontSize', 30, 'Interpreter','latex');
    yline(mean, LineWidth=2, Color='red');
    legend("Raw value", "Mean",'Location','northwest', 'Interpreter','latex');
    
    subplot(1,2,2);
    if (fitDistribution)
        histfit(data-mean);
    else
        histogram(data-mean);
    end
    
    title(sprintf("%s data - mean histogram", sensor), 'Interpreter','latex');
    xlabel(unit, 'FontSize', 30, 'Interpreter','latex');
    ylabel("Number of samples", 'FontSize', 30, 'Interpreter','latex');

    %% Save plot as PDF
    
    fig.Units = 'centimeters';        % set figure units to cm
    fig.PaperUnits = 'centimeters';   % set pdf printing paper units to cm
    fig.PaperSize = fig.Position(3:4);  % assign to the pdf printing paper the size of the figure
    print(fig,sprintf('./report/plots/plot%s',fileName),'-dpdf','-r0')
end