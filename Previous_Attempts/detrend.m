clc
clear all
close all

load datiOTT;
loads = datiOTT(:,2);
years = datiOTT(:,3);

for i = 0:11
    currentYear = 2000+i;
    currentLoads = loads(years == currentYear);
    fourWeeksLoads = currentLoads(1:28); % mi procuro i dati robusti (28 giorni invece di 31)
    means(i+1) = mean(fourWeeksLoads);
end

figure(1)
plot(2000:2011, means, 'r')