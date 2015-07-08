%% Benchmark:
% Calcola l'errore di predizione per tutte le settimane dell'Ottobre 2011 e
% ne calcola la media.
% *Restituisce l'errore percentuale assoluto (MAPE).*

clear all
close all
clc

load datiOTT

% Diamo i nomi alle colonne dei dati
loads=datiOTT(:,2);
years=datiOTT(:,3);

% Dei dati prendiamo solamente le righe appartenenti al 2011 e ne calcolo
% il numero.
dati2011 = datiOTT(years == 2011, :);
numeroDati2011 = length(dati2011);

% Usando come dati di validazione di volta in volta tutte le possibili
% settimane di Ottobre 2011, stimo gli errori, salvandoli in un vettore
% "errore". Ne faccio poi la media.
for i = 1:(numeroDati2011-8)
    
    datiWeek = dati2011(i:(i+7),:);
    stima = stimatoreMediaAnnoPrec(datiWeek);
    errore(i) = abs(stima - dati2011(i+8,2))/dati2011(i+8,2)*100;
    
end
media = mean(errore);

% Visualizzo il risultato del benchmark in uns figura.
figure('NumberTitle', 'off',     'Name', 'Errore MAPE medio')
hist(errore)
title(strcat('Errore MAPE - media: ', num2str(media)))
