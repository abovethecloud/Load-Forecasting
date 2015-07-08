% Benchmark: sceglie una settimana a caso nel 2011 e la usa per testare lo
% stimatore. Restituisce l'errore percentuale assoluto (MAPE).

clear all
close all
clc

load datiOTT

loads=datiOTT(:,2);
years=datiOTT(:,3);

dati2011 = datiOTT(years == 2011, :);

for i = 1:(length(dati2011)-8)
    
    datiWeek = dati2011(i:(i+7),:);
    stima = stimatoreMediaAnnoPrec(datiWeek);
    errore(i) = abs(stima - dati2011(i+8,2))/dati2011(i+8,2)*100;
    
end
media = mean(errore);

figure(1)
hist(errore)
title(strcat('Errore MAPE - media: ', num2str(media)))
