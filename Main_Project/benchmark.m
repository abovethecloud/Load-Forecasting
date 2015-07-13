%% Benchmark:
% Calcola l'errore di predizione per tutte le settimane dell'Ottobre 2011 e
% ne calcola la media.
% *Restituisce l'errore percentuale assoluto (MAPE).*

clear all
% close all
clc

load datiOTT

% Diamo i nomi alle colonne dei dati
loads=datiOTT(:,2);
years=datiOTT(:,3);

% Dei dati prendiamo solamente le righe appartenenti al 2011 e ne calcolo
% il numero.
dati_anno_campione = datiOTT(years == 2011, :);
numero_dati_campione = length(dati_anno_campione);

% Usando come dati di validazione di volta in volta tutte le possibili
% settimane di Ottobre 2011, stimo gli errori, salvandoli in un vettore
% "errore". Ne faccio poi la media.
errore = zeros(1, numero_dati_campione);
for i = 1:(numero_dati_campione-8)
    
    datiWeek = dati_anno_campione(i:(i+6),:);
    stima = predizione(datiWeek);
    errore(i) = 100*(abs(stima - dati_anno_campione(i+7,2))/dati_anno_campione(i+7,2));
    giorni_settimana = datiWeek(:, 6);
    giorno_successivo(i) = giorni_settimana(7)+1;
    if giorno_successivo(i) > 7,
        giorno_successivo(i) = 1;
    end

end
media = mean(errore);

% Visualizzo il risultato del benchmark in uns figura.
figure('NumberTitle', 'off',     'Name', 'Errore MAPE medio')
bar(errore)
title(strcat('Errore MAPE - media: ', num2str(media)))
