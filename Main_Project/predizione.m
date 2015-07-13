function L_hat = predizione(datiWeek)
%PREDIZIONE Summary of this function goes here
%   Detailed explanation goes here

% Dati di prova
datiWeek = [734799 27930.0408215328 2011 10 23 1;734800 35011.4504166509 2011 10 24 2;734801 36994.6270701670 2011 10 25 3;734802 37407.5724480600 2011 10 26 4;734803 36912.8835697433 2011 10 27 5;734804 36450.5041654192 2011 10 28 6;734805 31192.0431393705 2011 10 29 7];

%% Importazione dati e inizializzazioni
load datiOTT;
date_ID = datiOTT(:, 1);
loads = datiOTT(:,2);
years = datiOTT(:, 3);
month = datiOTT(:, 4);
dayOfMonth = datiOTT(:, 5);
dayOfWeek = datiOTT(:, 6);

anni_unici = unique(years); % Vettore contenente un anno diverso per elemento
numero_anni = length(anni_unici); % Numero di anni nei dati
numero_giorni_mese = 31; % Numero di giorni di Ottobre

% Detrendizzazione
[loadsDetrended, trend] = detrendizza(loads, years)








end