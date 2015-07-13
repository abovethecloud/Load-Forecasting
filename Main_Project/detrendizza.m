function [loadsDetrended, trend] = detrendizza(loads, years, num_anni_da_escludere)
%DETRENDIZZA Summary of this function goes here
%   Detailed explanation goes here

anni_unici = unique(years); % Vettore contenente un anno diverso per elemento
numero_anni = length(anni_unici); % Numero di anni nei dati
num_anni_identificazione = numero_anni - num_anni_da_escludere;

trend = zeros(1, num_anni_identificazione);
partialMeans = zeros(1, 3); % vettore richiesto per fare la media
loadsDetrended = zeros(1, length(loads));
for i = 1:num_anni_identificazione,
    
    currentYear = min(anni_unici)-1 + i;
    currentYearLoads = loads(years == currentYear);
    
    % Prendo solo i dati di tutte le sequenze di 28 giorni per l'Ottobre di
    % ogni anno e ne faccio la media (tranne l'ultima che contiene il 31.
    % In questo modo il trend risulta indipendente da qual'è il primo
    % giorno di ottobre.
    for j = 0:2,
        fourWeeksLoadsPartial = currentYearLoads(1+j:28+j);
        partialMeans(j+1) = mean(fourWeeksLoadsPartial);
    end
    
    trend(i) = mean(partialMeans);
    
    % Detrendizzo
    loadsDetrended(years == currentYear) = loads(years == currentYear) - trend(i);
    
end


end

