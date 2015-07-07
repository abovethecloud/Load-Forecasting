clc
clear all
close all

load datiOTT;
dates=datiOTT(:,1);
loads = log(datiOTT(:,2));
years = datiOTT(:,3);
dayOfMonth = datiOTT(:, 5);
dayOfWeek = datiOTT(:, 6);

for i = 0:11
    currentYear = 2000+i;
    currentLoads = loads(years == currentYear);
    fourWeeksLoads = currentLoads(1:28); % mi procuro i dati robusti (28 giorni invece di 31)
    means(i+1) = mean(currentLoads);
    fourWeeksMeans(i+1) = mean(fourWeeksLoads);
end

figure(1)
plot(2000:2011, means, 'b')
hold on
plot(2000:2011, fourWeeksMeans, 'r')

for i = 1:12
        currentYear = 1999+i;
        loadDetrended(years == currentYear) = loads(years == currentYear) - fourWeeksMeans(i);
end

% sistemare per vedere se i dati sono stati davvero detrendizzati
% TODO: aggiungere destagionalizzazione
figure(3)
y = 2000;
for r=0:2
    for c=1:4
        subplot(3, 4, r*4+c)
        plot(dates(years == y),loadDetrended(years == y))
        asse=axis;  % Fornisce gli estremi (xMax yMax)
        axis([asse(1:2) min(loadDetrended) max(loadDetrended)]); % Blocco lo stesso intervallo sull'asse delle y, così da vedere i trend
        datetick('x','d')
        xlabel('weekday')
        ylabel('detrendedLogLoad (MW)')
        title(strcat('October of year: ', num2str(y)))
        grid
        y=y+1;
    end
end

% figure(4)
% for i = 0:11
%     currentYear = 2000 + i
%     currentLoad = loadDetrended(year == currentYear)
%     startingDay = dayOfWeek
%     currentDays = 
% end
