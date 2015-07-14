 function L_hat = stimatoreAR(datiWeek)
%STIMATOREAR Summary of this function goes here
%   Detailed explanation goes here

load datiOTT

% Prelevo le info sui dati settimana:
giorni_settimana = datiWeek(:, 6);
giorni_mese = datiWeek(:, 5);
anno = unique(datiWeek(:, 3));
dati = datiWeek(:, 2);
    log_dati = log(dati);
date = datiWeek(:, 1);

% Detrend
log_dati_detrend = log_dati - mean(log_dati);

% Destag
loadsRemaining = log_dati_detrend; % Vettore che conterra' i dati destagionalizzati
meanDailyLoad = [-0.239674947019469 0.015877332975354 0.076934116678350 0.080139545724700 0.079664665770198 0.069665000109273 -0.085255188426933]
for d = 1:7,
    booleanD = (giorni_settimana == d);
    % Destagionalizzazione
    meanDailyLoad(d)
    loadsRemaining = loadsRemaining - meanDailyLoad(d)*(booleanD);
    
end


%% Stima AR
loads_realization = [-0.0117884781420819;-0.0222158759705362;-0.0138290228209034;0.0178808405196209;-0.0120846372831600;-0.0163979541493757;-0.000899893693430395;-0.00508814501026428;-0.0103964394165334;0.0132575271147977;0.0407532548782034;0.0111732961089815;0.00521403743836248;0.0131090764113026;0.000271438906666865;-0.00233424371460164;-0.00320631053005518;0.0252969032226042;-0.133489065097653]'% = loadsIrregularity(years == 2010)';
m = ar(loads_realization, 1)
m.a

yf = forecast(m,loadsRemaining,1)
giorno_succ = giorni_settimana(7)+1;
if giorno_succ > 7,
    giorno_succ = 1;
end
yf = yf + meanDailyLoad(giorno_succ)
yf = yf + mean(log_dati)


% L_hat=mean(datiOTT(years==anno-1 & dayOfWeek==giorni,2));
L_hat = yf;

end

