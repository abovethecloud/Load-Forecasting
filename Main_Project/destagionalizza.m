function [loads_deseasonalized, stag_settimanale] = destagionalizza(loadsDetrended, dataSet)
%DESTAGIONALIZZA Destagionalizza i dati già detrendizzati in ingresso.
%Restituisce i dati destagionalizzati e la stagionalità settimanale
%stimata.
%   La destagionalizzazione dei dati detrendizzati avviene effettuando la
%   media per ogni giorno della settimana di tutti i giorni degli anni
%   che compongono il data set.

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

