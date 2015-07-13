function [loads_deseasonalized, stagionalita] = destagionalizza(loadsDetrended, dayOfWeek)
%DESTAGIONALIZZA Summary of this function goes here
%   Detailed explanation goes here

stagionalita = zeros(1, 7);
loads_deseasonalized = loadsDetrended; % Vettore che conterra' i dati destagionalizzati
for d = 1:7,
    booleanDay = (dayOfWeek == d);
    stagionalita(d) = mean(loadsDetrended(booleanDay));
    % Destagionalizzazione
    loads_deseasonalized = loads_deseasonalized - stagionalita(d)*(booleanDay');
end


end
