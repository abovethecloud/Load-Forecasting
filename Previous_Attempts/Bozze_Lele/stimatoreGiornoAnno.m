% Stimatore polinomiale: Z ~ aX + bY, dove a e b sono coefficienti da identificare,
% X è il consumo dello stesso giorno della settimana precedente e Y è la media
% consumo dello stesso giorno della settimana dell'anno precedente.

clear all
close all
clc

load datiOTT

years = datiOTT(:,3);
daysOfMonth = datiOTT(:,5);
days = datiOTT(:,6);

datiUtili = datiOTT(years > min(years) & years < max(years) & daysOfMonth > 7, :);
for i = 1:length(datiUtili)
    X(i) = datiOTT(years==datiUtili(i,3) & daysOfMonth==(datiUtili(i,5)-7), 2);
    Y(i) = mean(datiOTT(years==(datiUtili(i,3)-1) & days==(datiUtili(i,6)),2));
    Z(i) = datiUtili(i, 2);
end

createFit(X,Y,Z)