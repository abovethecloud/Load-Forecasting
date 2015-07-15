%% PREDIZIONE ONE-DAY-AHEAD DEL CARICO ELETTRICO

function L_hat = predizione(datiWeek)
%PREDIZIONE Predice il carico elettrico del giorno successivo ad una
%settimana di Ottobre di un dato anno
%   Per la previsione, questa funzione utilizza i dati della settimana di
%   Ottobre precedente al giorno da stimare e un certo numero di mesi di
%   Ottobre di anni precedenti utilizzati come Set di Identificazione del
%   modello previsionale.
%   Dei dati viene effettuata la detrendizzazione, la destagionalizzazione
%   e viene studiato ciò che rimane come modello AR.

% Dati di prova in mancanza di input:
% datiWeek = [734799 27930.0408215328 2011 10 23 1;734800 35011.4504166509 2011 10 24 2;734801 36994.6270701670 2011 10 25 3;734802 37407.5724480600 2011 10 26 4;734803 36912.8835697433 2011 10 27 5;734804 36450.5041654192 2011 10 28 6;734805 31192.0431393705 2011 10 29 7];

%% Scelta del numero di anni da escludere dal set di identificazione

anni_da_escludere = 1;


%% Import data set e inizializzazioni

% Caricamento dati
load datiOTT;
dataSet = datiOTT;

% Restrizione al data set delle righe di identificazione
years = dataSet(:, 3);
boolSet = (years <= max(years)-anni_da_escludere); % Maschera identificazione
dataSet = dataSet(boolSet, :); % Restrizione righe

% Esplicitazione dati di interesse
years = dataSet(:, 3);

anni_unici = unique(years); % Vettore contenente tutti gli anni diversi

%% Elaborazione dei dati degli anni precedenti e stima del modello

% Detrendizzazione DATI
[loadsDetrended, trend] = detrendizza(dataSet);

% Destagionalizzazione DATI
[loads_deseasonalized, stag_settimanale] = destagionalizza(loadsDetrended, dataSet);

% Stima modello AR sui DATI
[model] = stima_modello(loads_deseasonalized);


%% Elaborazione dei dati della settimana precedente la previsione

giorni_settimana = datiWeek(:, 6);
anno = unique(datiWeek(:, 3));
dati = datiWeek(:, 2); %     log_dati = log(dati);

% Detrendizzazione SETTIMANA
trend_settimana = trend(anni_unici(1: length(trend)) == anno);
if isempty(trend_settimana),
    trend_settimana = mean(dati);
else
    trend_settimana = mean([trend_settimana, mean(dati)]);
end
datiSettimana_detrendizzati = dati - trend_settimana;

% Destagionalizzazione SETTIMANA
dati_destagionalizzati = datiSettimana_detrendizzati; % Vettore che conterra' i dati destagionalizzati
for d = 1:7,
    booleanDay = (giorni_settimana == d);
    % Destagionalizzazione
    dati_destagionalizzati = dati_destagionalizzati - stag_settimanale(d)*(booleanDay);
end

%% Predizione
% Predizione basata sul modello estrapolato dai dati degli anni precedenti
% e calibrato sull'ultima settimana.

L_hat_modello = forecast(model, dati_destagionalizzati, 1);
giorno_succ = giorni_settimana(7)+1;
if giorno_succ > 7,
    giorno_succ = 1;
end
L_hat_detrendizzato = L_hat_modello + stag_settimanale(giorno_succ);
L_hat = L_hat_detrendizzato + trend_settimana;

end