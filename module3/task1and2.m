%addpath '/Users/Rafa/Documents/git/unilectures/sensorslab'
clc;
clear;
close all

%% Load Steady data
load('data/1measurement1Kaffee.mat');
measurementKaffee = rawDataArduino;

load('data/1measurement2Acai.mat');
measurementAcai = rawDataArduino;

load('data/1measurement3Mate.mat');
measurementMate = rawDataArduino;

%% Calculated time 
measurementKaffee(:,1) = (measurementKaffee(:,1) - measurementKaffee(1,1))/1000;
measurementAcai(:,1) = (measurementAcai(:,1) - measurementAcai(1,1))/1000;
measurementMate(:,1) = (measurementMate(:,1) - measurementMate(1,1))/1000;

%% Only time before 800 seconds
%measurementKaffee = measurementKaffee(measurementKaffee(:,1)<500, :);
%measurementAcai = measurementAcai(measurementAcai(:,1)<500, :);
%measurementMate = measurementMate(measurementMate(:,1)<500, :);


%% Function to pot data
plotData("Coffee", "Coffee", measurementKaffee(:,1), measurementKaffee);
plotData("Acai", "A\c{c}a\'i", measurementAcai(:,1), measurementAcai);
plotData("Mate", "Mate", measurementMate(:,1), measurementMate);

function plotData(fileName, source, t, data)
    fig = figure('DefaultAxesFontSize',30);
    fig.Position = [100 100 1200 1000];
    subplot(2,1,1);
    plot(t, (data(:,2))/1000);
    title(sprintf("Resistance - %s", source), 'Interpreter','latex');
    xlabel("Time [s]", 'FontSize', 30, 'Interpreter','latex');
    ylabel("Resistance [$k\Omega$]", 'FontSize', 30, 'Interpreter','latex');
    %xline(mean, LineWidth=2, Color='red');
    %legend("Resistance",'Location','northwest', 'Interpreter','latex');

    %% Second plot
    %fig = figure('DefaultAxesFontSize',30);
    %fig.Position = [100 100 1200 1000];
    subplot(2,1,2);
    plot(t, data(:,4));
    hold on
    ylabel("VOC Concentration [ppm]", 'FontSize', 30, 'Interpreter','latex');
    yyaxis right
    plot(t, data(:,5));
    ylabel("$\mathrm{CO_2}$ Concentration [ppm]", 'FontSize', 30, 'Interpreter','latex');
    
    titleString = strcat("", source, " VOC and $\mathrm{CO_2}$");
    title(titleString, 'Interpreter','latex');
    xlabel("Time [s]", 'FontSize', 30, 'Interpreter','latex');
    legend("VOC","$\mathrm{CO_2}$",'Location','northeast', 'Interpreter','latex');
    % data 4 = VOC_eq data 5 = CO2 eq

    %% Save plot as PDF
    
    fig.Units = 'centimeters';        % set figure units to cm
    fig.PaperUnits = 'centimeters';   % set pdf printing paper units to cm
    fig.PaperSize = fig.Position(3:4);  % assign to the pdf printing paper the size of the figure
    print(fig,sprintf('./report/plots/plot%s',fileName),'-dpdf','-r0')
end