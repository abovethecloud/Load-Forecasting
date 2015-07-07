clc
clear all
close all

% I dati sono stati scelti su ottobre, che è un mese piuttosto regolare.
% La predizione deve essere fatta da una funzione che si basa sui dati
% della settimana precedente

% Potremmo dividere i dati in identificazione e validazione


load datiOTT;
dates=datiOTT(:,1);
loads=datiOTT(:,2);
years=datiOTT(:,3);
figure(1)
y=2000;
for r=0:2
    for c=1:4
        subplot(3, 4, r*4+c)
        plot(dates(years==y),loads(years==y))
        asse=axis;  % Fornisce gli estremi (xMax yMax)
        axis([asse(1:2) 20000 40000]); % Blocco lo stesso intervallo sull'asse delle y, così da vedere i trend
        datetick('x','d')
        xlabel('weekday')
        ylabel('load (MW)')
        title(strcat('October of year: ', num2str(y)))
        grid
        y=y+1;
    end
end

datiWeek = datiOTT(end-22:end-15, :)
L_hat = predizione1(datiWeek);
L_hat1 = L_hat
L_hat = predizione2(datiWeek, datiOTT);
L_hat2 = L_hat
% 
% anno=datiWeek(1,3)
% giorno=datiWeek(1,6)
% years=datiOTT(:,3)
% days=datiOTT(:,6)
% 
% datiOTT(years==anno-1 & days==giorno,2)
% 
% L_hat=mean(datiOTT(years==anno-1 & days==giorno,2))



% figure(2)












