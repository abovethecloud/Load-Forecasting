function L_hat = predizione(datiWeek)
%PREDIZIONE Summary of this function goes here
%   Detailed explanation goes here

% Dati di prova ATTENZIONE A TOGLIERE SEMPRE
% datiWeek = [734799 27930.0408215328 2011 10 23 1;734800 35011.4504166509 2011 10 24 2;734801 36994.6270701670 2011 10 25 3;734802 37407.5724480600 2011 10 26 4;734803 36912.8835697433 2011 10 27 5;734804 36450.5041654192 2011 10 28 6;734805 31192.0431393705 2011 10 29 7];

anni_da_escludere = 1;

%% Importazione dati e inizializzazioni
load datiOTT;
years = datiOTT(:, 3);
% datiOTT = datiOTT((years <= max(years)-anni_da_escludere), :)
date_ID = datiOTT(:, 1);
loads = datiOTT(:,2);
years = datiOTT(:, 3);
month = datiOTT(:, 4);
dayOfMonth = datiOTT(:, 5);
dayOfWeek = datiOTT(:, 6);

anni_unici = unique(years); % Vettore contenente un anno diverso per elemento
numero_anni = length(anni_unici); % Numero di anni nei dati
numero_giorni_mese = 31; % Numero di giorni di Ottobre

boolAnno = years <= max(years) - anni_da_escludere; % TODO: eliminare condizione, in favore del filtro su datiOTT
loads = loads(boolAnno);

% Detrendizzazione DATI
[loadsDetrended, trend] = detrendizza(loads, years, anni_da_escludere)

% Destagionalizzazione DATI
[loads_deseasonalized, stagionalita] = destagionalizza(loadsDetrended, datiOTT)

% Stima modello AR sui DATI
[model] = stima_modello(loads_deseasonalized)

giorni_settimana = datiWeek(:, 6);
giorni_mese = datiWeek(:, 5);
anno = unique(datiWeek(:, 3));
dati = datiWeek(:, 2); %     log_dati = log(dati);
date = datiWeek(:, 1);

% Detrendizzazione SETTIMANA
trend_settimana = trend(anni_unici(1: length(trend)) == anno);
if isempty(trend_settimana),
    trend_settimana = mean(dati);
else
    trend_settimana = mean([trend_settimana, mean(dati)])
end
datiSettimana_detrendizzati = dati - trend_settimana;

% Destagionalizzazione SETTIMANA
dati_destagionalizzati = datiSettimana_detrendizzati; % Vettore che conterra' i dati destagionalizzati
for d = 1:7,
    booleanDay = (giorni_settimana == d);
    % Destagionalizzazione
    dati_destagionalizzati = dati_destagionalizzati - stagionalita(d)*(booleanDay);
end

% Predizione
L_hat = forecast(model, dati_destagionalizzati, 1)
giorno_succ = giorni_settimana(7)+1;
if giorno_succ > 7,
    giorno_succ = 1;
end
L_hat = L_hat + stagionalita(giorno_succ)
L_hat = L_hat + trend_settimana








end