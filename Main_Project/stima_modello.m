function [model] = stima_modello(loads_deseasonalized)
%STIMA_MODELLO Stima di un modello AR sui dati detrendizzati e
%destagionalizzati
%   Una volta detrendizzati e destagionalizzati i dati, viene stimato un
%   modello AR di settimo grado sui residui. La scelta del grado è stata
%   sostanzialmente dettata da una misurazione degli errori e da una
%   considerazione pratica: comunque disponendo solo di una settimana
%   prima, andare oltre il settimo grado non potrebbe apportare particolari
%   benefici

loads_realization = loads_deseasonalized;
model = ar(loads_realization, 7); % AR di settimo grado

end

