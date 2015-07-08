clc
clear all
close all

load datiOTT;

% Do i nomi alle colonne dei dati che mi interessano
loads = datiOTT(:,2);
years = datiOTT(:,3);

% Per ogni anno, calcolo la media dei carichi sulle 4 settimane di Ottobre
% e la salva negli elementi del vettore "means"
for i = 0:11
    
    currentYear = 2000+i;
    booleanVectorCurrentYear = (years == currentYear);
    currentYearLoads = loads(booleanVectorCurrentYear);
    
    % Prendo solo i dati dei primi 28 giorni per l'Ottobre di ogni anno.
    % Questo per avere esattamente 4 settimane ed evitare di avere 5 domeniche
    % o cose del genere.. Perdo in robustezza (se salta un dato: casino!)
    fourWeeksLoads = currentYearLoads(1:28);
    means(i+1) = mean(fourWeeksLoads);
    
end

% Plotto il grafico del trend negli anni
figure('Name', 'Data Trend',    'NumberTitle', 'off')
plot(2000:2011, means, 'r')