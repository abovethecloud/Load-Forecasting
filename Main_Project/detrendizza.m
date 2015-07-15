function [loadsDetrended, trend] = detrendizza(dataSet)
%DETRENDIZZA Detrendizza i dati di carico elettrico in ingresso e li
%restituisce unitamente al trend stimato.
%   La detrendizzazione avviene sui dati di carico elettrico contenuti in
%   un matrice nx6, in cui n è il numero di righe (e quindi di dati
%   giornalieri) e 6 sono le colonne contenti le informazioni sui dati.
%   L'effettivo dato di carico è contenuto nella seconda colonna.

%% Estrapolazione dati utili
loads = dataSet(:,2);
years = dataSet(:, 3);

% Conta degli anni per decidere la lunghezza del ciclo
anni_unici = unique(years); % Vettore contenente un anno diverso per elemento
numero_anni = length(anni_unici); % Numero di anni nei dati

%% Algoritmo di stima del trend e detrendizzazione

trend = zeros(1, numero_anni);
partialMeans = zeros(1, 3); % vettore richiesto per fare la media
loadsDetrended = zeros(1, length(loads));
for i = 1:numero_anni,
    
    currentYear = min(anni_unici)-1 + i;
    currentYearLoads = loads(years == currentYear);
    
    % Prendo solo i dati di tutte le sequenze di 28 giorni per l'Ottobre di
    % ogni anno e ne faccio la media (tranne l'ultima, che contiene il 31).
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

