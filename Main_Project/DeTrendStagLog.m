%% DETRENDIZZAZIONE E DESTAGIONALIZZAZIONE DEI DATI

clc
clear all
close all

load datiOTT;

%% Stima trend del log dei dati

% Do i nomi alle colonne dei dati, e faccio il logaritmo dei dati.
date_ID = datiOTT(:, 1);
loads = datiOTT(:,2);
    log_loads = log(datiOTT(:, 2));
years = datiOTT(:, 3);
month = datiOTT(:, 4);
dayOfMonth = datiOTT(:, 5);
dayOfWeek = datiOTT(:, 6);

% Per ogni anno, calcolo la media dei logaritmi dei carichi in Ottobre in 3
% modi diversi, dopodiché la salvo negli elementi dei vettori "means",
% "fourWeeksMeans" e "betterMeans".
means = zeros(1, 12);
fourWeeksMeans = zeros(1, 12);
betterMeans = zeros(1, 12);
partialBetterMeans = zeros(1, 4); % vettore richiesto per fare la media
for i = 0:11,
    
    currentYear = 2000+i;
    currentYearLogLoads = log_loads(years == currentYear);
    
    % media dei carichi su tutti i giorni (3 giorni piu' delle 4 settimane)
    means(i+1) = mean(currentYearLogLoads);
    
    % Prendo solo i dati dei primi 28 giorni per l'Ottobre di ogni anno.
    % Questo per avere esattamente 4 settimane ed evitare di avere 5 domeniche
    % o cose del genere.. Perdo in robustezza (se salta un dato: casino!)
    fourWeeksLoads = currentYearLogLoads(1:28);
    fourWeeksMeans(i+1) = mean(fourWeeksLoads);
    
    % ULTERIORE MIGLIORAMENTO:
    % Prendo solo i dati di tutte le sequenze di 28 giorni per l'Ottobre di
    % ogni anno e ne faccio la media. In questo modo il trend risulta
    % indipendente da qual'è il primo giorno di ottobre.
    
    for j = 0:3,
        fourWeeksLoadsPartial = currentYearLogLoads(1+j:28+j);
        partialBetterMeans(j+1) = mean(fourWeeksLoadsPartial);
    end
    betterMeans(i+1) = mean(partialBetterMeans);
    
end

% Plotto il grafico del confronto tra trend
figure('Name', 'Confronto trend',    'NumberTitle', 'off')
plot(2000:2011, means, '-.rx')
hold on
plot(2000:2011, fourWeeksMeans, '-.g*')
hold on
plot(2000:2011, betterMeans, '-bo')
legend('Trend 31 gg', 'Trend 28 gg', 'Trend 28 gg medio',   'Location', 'southeast')
% La legenda è in basso a destra


%% Detrendizzazione del log dei dati

% Alloco un vettore dei dati logaritmici detrendizzati della stessa
% lunghezza dei dati e lo riempio con i dati detrendizzati (uso la miglior
% detrendizzazione)
loadsDetrended = zeros(1, length(log_loads));
for i = 1:12
    currentYear = 1999+i;
    loadsDetrended(years == currentYear) = log_loads(years == currentYear) - betterMeans(i);
end


%% Verifica detrendizzazione con plot grafico

% Plot dei dati (logaritmici) detrendizzati a partire dall'anno 2000
figure('Name', 'Dati detrendizzati',     'NumberTitle', 'off')
y = 2000;
for r=0:2,
    for c=1:4,
        % Plotto 
        subplot(3, 4, r*4+c)
        plot(date_ID(years == y), loadsDetrended(years == y))
        
        lim = axis;  % Fornisce un vettore [xMin xMax yMin yMax]
        vetLimX = lim(1:2);
        
        % Blocco lo stesso intervallo sugli assi x e y, cosi' da vedere i trend
        axis([vetLimX min(loadsDetrended) max(loadsDetrended)]);
        
        % Sull'asse delle X forzo il nome del giorno [datetick interpreta
        % l'identificatore del "date_ID", ottenuto con datenum(...)]
        datetick('x','ddd', 'keepticks')
        xlabel('weekday')
        ylabel('detrendedLogLoad (MW)')
        title(strcat('October of year: ', num2str(y)))
        grid
        y=y+1;
    end
end


%% Stima Stagionalta' dei dati e Destagionalizzazione

meanDailyLoad = zeros(1, 7);
% loadsIrregularity = zeros(1, length(loadsDetrended));
loadsIrregularity = loadsDetrended;
for i = 1:7,
    booleanDay = (dayOfWeek == i);
    meanDailyLoad(i) = mean(loadsDetrended(booleanDay));
    loadsIrregularity = loadsIrregularity - meanDailyLoad(i)*(booleanDay');
end

figure('Name', 'Andamento Stagionalità',    'NumberTitle', 'off')
plot(1:7, meanDailyLoad)

%% Verifica della destagionalizzazione

% Plot dei dati (logaritmici) detrendizzati e destagionalizzati a partire
% dall'anno 2000
figure('Name', 'Dati detrendizzati e destagionalizzati',     'NumberTitle', 'off')
y = 2000;
for r=0:2,
    for c=1:4,
        % Plotto 
        subplot(3, 4, r*4+c)
        plot(date_ID(years == y), loadsIrregularity(years == y))
        
        lim = axis;  % Fornisce un vettore [xMin xMax yMin yMax]
        vetLimX = lim(1:2);
        
        % Blocco lo stesso intervallo sugli assi x e y, cosi' da vedere i trend
        axis([vetLimX min(loadsIrregularity) max(loadsIrregularity)]);
        
        % Sull'asse delle X forzo il nome del giorno [datetick interpreta
        % l'identificatore del "date_ID", ottenuto con datenum(...)]
        datetick('x','ddd', 'keepticks')
        xlabel('weekday')
        ylabel('DETSLogLoad (MW)')
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
