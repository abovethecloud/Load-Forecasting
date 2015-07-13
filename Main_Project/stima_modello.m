function [model] = stima_modello(loads_deseasonalized)
%STIMA_MODELLO Summary of this function goes here
%   Detailed explanation goes here

loads_realization = loads_deseasonalized;
model = ar(loads_realization, 7) % AR di settimo grado

end

