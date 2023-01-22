%addpath '/Users/Rafa/Documents/git/unilectures/sensorslab'
clc;
clear;
close all

%% Load Steady data
load('data/data24hjan18.mat');
data24h = rawDataArduino;

data24h(:,1) = (data24h(:,1) - data24h(1,1))/1000; %in seconds
timestamp = datetime(2023, 1,18) + seconds(52020) + seconds(data24h(:,1));



plotData("co2_24h", "$\mathrm{CO_2}$", timestamp, data24h, "$\mathrm{CO_2}$ Concentration [ppm]");
%plotData("voc_24h", "VOC", timestamp, data24h(:,voc_idx), "VOC Concentration [ppm]");
%plotData("temp_24h", "Temperature", timestamp, data24h(:,temp_idx), "Temperature [ºC]");
%plotData("hum_idx", "Humidity", timestamp, data24h(:,hum_idx), "Humidity [xxx]");
%plotData("iaq_idx", "IAQ", timestamp, data24h(:,iaq_idx), "IAQ index");


function plotData(fileName, source, t, data, y_label)

    iaq_idx = 3;
    voc_idx = 4;
    co2_idx = 5;
    temp_idx = 6;
    hum_idx = 7;

    fig = figure('DefaultAxesFontSize',20);
    fig.Position = [100 100 1200 1000];
    
    plot(t, data(:, temp_idx));
   
    hold on
    plot(t, data(:, hum_idx));
    xtickangle(45)
    datetick('x','HH:MM')
    
    titleString = "Temperature and Humidity over 24h";
    title(titleString, 'Interpreter','latex');
    legend("Temperature [ºC]","Humidity [%]",'Location','northeast', 'Interpreter','latex');
    grid on
    %xticks(t(1):hours(1):t(end));
     %% Save plot as PDF
    
    fig.Units = 'centimeters';        % set figure units to cm
    fig.PaperUnits = 'centimeters';   % set pdf printing paper units to cm
    fig.PaperSize = fig.Position(3:4);  % assign to the pdf printing paper the size of the figure
    print(fig,'./report/plots/plotTempHum','-dpdf','-r0')

    %% second plot
    fig = figure('DefaultAxesFontSize',20);
    fig.Position = [100 100 1200 1000];
    plot(t, data(:, iaq_idx));
    ylabel("IAQ index", 'FontSize', 30, 'Interpreter','latex');
    hold on
    %plot(t, data(:, voc_idx));
    yyaxis right
    plot(t, data(:, co2_idx));
    xtickangle(45)
    datetick('x','HH:MM')
    ylabel("$\mathrm{CO_2}$ Concentration [ppm]", 'FontSize', 30, 'Interpreter','latex');
    titleString = "IAQ and $\mathrm{CO_2}$ over 24h";
    title(titleString, 'Interpreter','latex');
    legend("IAQ","$\mathrm{CO_2}$ [ppm]",'Location','northeast', 'Interpreter','latex');
    grid on

     %% Save plot as PDF
    fig.Units = 'centimeters';        % set figure units to cm
    fig.PaperUnits = 'centimeters';   % set pdf printing paper units to cm
    fig.PaperSize = fig.Position(3:4);  % assign to the pdf printing paper the size of the figure
    print(fig,'./report/plots/plotCO2IAQ','-dpdf','-r0')

    %% thirdplot

    fig = figure('DefaultAxesFontSize',20);
    fig.Position = [100 100 1200 1000];
    plot(t, data(:, iaq_idx));
    
    hold on
    yyaxis right
    plot(t, data(:, co2_idx));
    xtickangle(45)
    datetick('x','HH:MM')
    ylabel("$\mathrm{CO_2}$ Concentration [ppm]", 'FontSize', 30 ,'Interpreter','latex');
    
    yyaxis left
    plot(t, data(:, voc_idx), 'Color', "#77AC30");
    
    titleString = "IAQ, $\mathrm{CO_2}$ and VCO over 24h";
    title(titleString, 'Interpreter','latex');
    legend("IAQ","VOC","$\mathrm{CO_2}$",'Location','northeast', 'Interpreter','latex');
    grid on

     %% Save plot as PDF
    fig.Units = 'centimeters';        % set figure units to cm
    fig.PaperUnits = 'centimeters';   % set pdf printing paper units to cm
    fig.PaperSize = fig.Position(3:4);  % assign to the pdf printing paper the size of the figure
    print(fig,'./report/plots/plotCO2IAQVOC','-dpdf','-r0')
end