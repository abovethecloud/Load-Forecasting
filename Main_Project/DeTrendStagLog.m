%% DETRENDIZZAZIONE E DESTAGIONALIZZAZIONE DEI DATI

clc
clear all
close all

load datiOTT;


%% Inizializzazioni

% Do i nomi alle colonne dei dati, e faccio il logaritmo dei dati.
date_ID = datiOTT(:, 1);
loads = datiOTT(:,2);
    log_loads = log(datiOTT(:, 2));
years = datiOTT(:, 3);
month = datiOTT(:, 4);
dayOfMonth = datiOTT(:, 5);
dayOfWeek = datiOTT(:, 6);

anni_unici = unique(years); % Vettore contenente un anno diverso per elemento
numero_anni = length(anni_unici);
numero_giorni_mese = 31;



%% Stima trend del log dei dati

% Per ogni anno, calcolo la media dei logaritmi dei carichi in Ottobre in 3
% modi diversi, dopodiché la salvo negli elementi dei vettori "means",
% "fourWeeksMeans" e "betterMeans".
means = zeros(1, numero_anni);
fourWeeksMeans = zeros(1, numero_anni);
betterMeans = zeros(1, numero_anni);
partialBetterMeans = zeros(1, 4); % vettore richiesto per fare la media
for i = 0:numero_anni-1,
    
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
for i = 1:numero_anni,
    currentYear = 1999+i;
    loadsDetrended(years == currentYear) = log_loads(years == currentYear) - betterMeans(i);
end


%% Verifica detrendizzazione con plot grafico

% Plot dei dati (logaritmici) detrendizzati a partire dall'anno 2000
figure('Name', 'Dati detrendizzati',     'NumberTitle', 'off')
yyyy = 2000;
for r=0:2,
    for c=1:4,
        % Plotto 
        subplot(3, 4, r*4+c)
        plot(date_ID(years == yyyy), loadsDetrended(years == yyyy))
        
        lim = axis;  % Fornisce un vettore [xMin xMax yMin yMax]
        vetLimX = lim(1:2);
        
        % Blocco lo stesso intervallo sugli assi x e y, cosi' da vedere i trend
        axis([vetLimX min(loadsDetrended) max(loadsDetrended)]);
        
        % Sull'asse delle X forzo il nome del giorno [datetick interpreta
        % l'identificatore del "date_ID", ottenuto con datenum(...)]
        datetick('x','ddd', 'keepticks')
        xlabel('weekday')
        ylabel('detrendedLogLoad (MW)')
        title(strcat('October of year: ', num2str(yyyy)))
        grid
        yyyy=yyyy+1;
    end
end

%% Spaghetti plot per la detrendizzazione

figure('Name', 'Spaghetti plot detrendizzato', 'NumberTitle', 'off')
for i=1:numero_anni,

    % md rappresenta il vettore dei giorni del mese dell'anno in corso
    md = dayOfMonth(years == 1999+i);
    % wd è un vettore contenente il numero dei giorni (1-7)
    wd = dayOfWeek(years == 1999+i);
    
    % ldet contiene i dati detrendizzati di un solo anno
    ldet = loadsDetrended(years == 1999+i);
    
    % Prima di plottare l'ottobre di un singolo anno, mi assicuro che i
    % giorni siano sincronizzati.
    md = md + wd(1) - 1;
    
    plot(md, ldet, '*-')
    hold on
        
end
hold off

%% Stima Stagionalta' dei dati e Destagionalizzazione

meanDailyLoad = zeros(1, 7);
loadsIrregularity = loadsDetrended; % Vettore che conterra' i dati destagionalizzati
for d = 1:7,
    booleanDay = (dayOfWeek == d);
    meanDailyLoad(d) = mean(loadsDetrended(booleanDay));
    
    % Destagionalizzazione
    loadsIrregularity = loadsIrregularity - meanDailyLoad(d)*(booleanDay');
end

figure('Name', 'Andamento Stagionalità',    'NumberTitle', 'off')
plot(1:7, meanDailyLoad)

%% Verifica della destagionalizzazione

% Plot dei dati (logaritmici) detrendizzati e destagionalizzati a partire
% dall'anno 2000
figure('Name', 'Dati detrendizzati e destagionalizzati',     'NumberTitle', 'off')
yyyy = 2000;
for r=0:2,
    for c=1:4,
        % Plotto 
        subplot(3, 4, r*4+c)
        plot(date_ID(years == yyyy), loadsIrregularity(years == yyyy))
        
        lim = axis;  % Fornisce un vettore [xMin xMax yMin yMax]
        vetLimX = lim(1:2);
        
        % Blocco lo stesso intervallo sugli assi x e y, cosi' da vedere i trend
        axis([vetLimX min(loadsIrregularity) max(loadsIrregularity)]);
        
        % Sull'asse delle X forzo il nome del giorno [datetick interpreta
        % l'identificatore del "date_ID", ottenuto con datenum(...)]
        datetick('x','ddd', 'keepticks')
        xlabel('weekday')
        ylabel('DETSLogLoad (MW)')
        title(strcat('October of year: ', num2str(yyyy)))
        grid
        yyyy=yyyy+1;
    end
end

%% Spaghetti plot per la destagionalizzazione

figure('Name', 'Spaghetti plot Irregolarita', 'NumberTitle', 'off')
for i=1:numero_anni,

    % md rappresenta il vettore dei giorni del mese dell'anno in corso
    md = dayOfMonth(years == 1999+i);
    % wd è un vettore contenente il numero dei giorni (1-7)
    wd = dayOfWeek(years == 1999+i);
    
    % ldet contiene i dati detrendizzati di un solo anno
    ldet = loadsIrregularity(years == 1999+i);
    
    % Prima di plottare l'ottobre di un singolo anno, mi assicuro che i
    % giorni siano sincronizzati.
    md = md + wd(1) - 1;
    
    plot(md, ldet, '*-')
    hold on
        
end
hold off

%% Confronto tra stagionalità mensile e dati effettivi per quel mese


figure('Name', 'Media menisle - Dati veri',     'NumberTitle', 'off')

WL = zeros(size(log_loads));

for i=1:length(log_loads)
    
    WL(i)=meanDailyLoad(dayOfWeek(i));
    
end

yyyy=2000;

for r=0:2

    for c=1:4

        subplot(3,4,r*4+c)
        plot(date_ID(years==yyyy),log_loads(years==yyyy),'*',date_ID(years==yyyy),betterMeans(yyyy-1999)+WL(years==yyyy),'d-')
%       asse=axis;
%       axis([asse(1:2) 0.7 1.2]);
        datetick('x','d')
        xlabel('weekday')
        ylabel('load (MW)')
        title(strcat('October of year: ',num2str(yyyy)))
        grid
        yyyy=yyyy+1;

    end

end

%% Stima Autocovarianza annuale


figure('Name', 'Autocovarianza',     'NumberTitle', 'off')
yyyy = 2000;
loadsIrregYear = zeros(1, 28);
autocovarianza = zeros (12, 2*length(loadsIrregYear)-1);
for r=0:2,
    for c=1:4,
        % Plotto 
        subplot(3, 4, r*4+c)
        i = r*4+c
        
        loadsIrregYear = loadsIrregularity(years == yyyy);
        
        % Invece di fare l'autocovarianza per il processo che include gli
        % ultimi giorni del mese, lo pulisco per colpa del ponte di fine
        % mese. Tolgo gli ultimi 3 gg.
        loadsIrregYear28 = loadsIrregYear(1:28);
        autocovarianza(i, :) = xcov(loadsIrregYear28);
        plot(-27:1:27, autocovarianza(i, :))
        
        lim = axis;  % Fornisce un vettore [xMin xMax yMin yMax]
        vetLimX = lim(1:2);
        
        % Blocco lo stesso intervallo sugli assi x e y, cosi' da vedere i trend
        axis([vetLimX min(autocovarianza(i, :)) max(autocovarianza(i, :))]);
        
        xlabel('distanza temporale (gg)')
        ylabel('Auto-covarianza')
        title(strcat('October of year: ', num2str(yyyy)))
        grid
        yyyy=yyyy+1;
    end
end

%% Media dell'autocovarianza

figure('Name', 'Autocovarianza MEDIA',     'NumberTitle', 'off')
meanAutocov = zeros(1, length(autocovarianza(1, :)));
for i = 1:1:length(autocovarianza(1, :)),
    meanAutocov(i) = mean(autocovarianza(: ,i));
end
plot(-27:1:27, meanAutocov);


%% TIME-SERIES DATA

loads_realizations = zeros(numero_anni*4, 7);
for i = 1:numero_anni,
    currentYear = 1999+i;
    for j = 1:4,
            temp = log_loads(years == currentYear);
            temp_settimana = temp(j:j+6);
            loads_realizations(4*i+j-4,:) = temp_settimana;
    end

end

% y = iddata(loads_realizations, [], 1)
y = iddata(loadsIrregularity', [], 1)


% figure(4)
% for i = 0:11
%     currentYear = 2000 + i
%     currentLoad = loadDetrended(year == currentYear)
%     startingDay = dayOfWeek
%     currentDays = 
% end
