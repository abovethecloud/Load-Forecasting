function [loads_deseasonalized, stag_settimanale] = destagionalizza(loadsDetrended, dataSet)
%DESTAGIONALIZZA Summary of this function goes here
%   Detailed explanation goes here
dayOfWeek = dataSet(:, 6);

stag_settimanale = zeros(1, 7);
loads_deseasonalized = loadsDetrended; % Vettore che conterra' i dati destagionalizzati
for d = 1:7,
    booleanD = (dayOfWeek == d)'; % Maschera per giorno
    booleanDay = booleanD(1:length(loadsDetrended));
    stag_settimanale(d) = mean(loadsDetrended(booleanDay'));
    % Destagionalizzazione
    loads_deseasonalized = loads_deseasonalized - stag_settimanale(d)*(booleanDay);
end


end

