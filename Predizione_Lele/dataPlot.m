% Carica i dati e disegna i grafici.


load datiOTT
dates=datiOTT(:,1);
loads=datiOTT(:,2);
years=datiOTT(:,3);
figure(1)
y=2000;
for r=0:2
    for c=1:4
        subplot(3,4,r*4+c)
        plot(dates(years==y),loads(years==y))
        asse=axis;
        axis([asse(1:2) 20000 40000]);
        datetick('x','d')
        xlabel('weekday')
        ylabel('load (MW)')
        title(strcat('October of year: ',num2str(y)))
        grid
        y=y+1;
    end
end