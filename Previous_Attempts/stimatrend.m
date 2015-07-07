
% Caricamento dei dati e denominazine delle colonne
load datiOTT;
L=log(datiOTT(:,2));    % L e' il log del carico elettrico
Y=datiOTT(:,3);         % Y e' il vettore degli anni
MD=datiOTT(:,5);        % MD e' il vettore dei giorni del mese
WD=datiOTT(:,6);        % WD e' il vettore dei giorni della settimana

% Calcolo della media dei logaritmi dei carichi per ogni anno.
% M e' un vettore di 12 elementi il cui i-esimo elemento contiene la media per l'anno 1999+i
M = zeros(1, 12);
 for i = 1:12,
     M(i) = mean(L(Y==1999+i));
 end
 
 % Calcolo della media dei logaritmi dei carichi "migliorata".
 % Si considerano solamente 28 giorni invece di 31
 % M2 e' un vettore di 12 elementi contenente le medie fatte su 28 gg.
M28 = zeros(1, 12);
for i=1:12,
    ML = L(Y==1999+i);      % ML contiene i carichi di ogni anno (31 gg) a ciclo
    M28(i)=mean(ML(1:28));   % Restrizione a 28 gg
end

% y e' il vettore contenente gli anni di riferimento per le medie M e M28.
% Serve per la visualizzazione (plot)
y = 2000:2011;

figure(1)
plot(y,M,'*-b',y,M28,'o-r')


%Ldetrend(1:31)=L(1:31)-M2(1);
Ldetrend=zeros(size(L));

for i=1:12,Ldetrend(Y==1999+i)=L(Y==1999+i)-M2(i);end


figure(2)
y=2000;

for r=0:2

    for c=1:4

        subplot(3,4,r*4+c)
        plot(dates(years==y),exp(Ldetrend(years==y)),'d-')
%         asse=axis;
        axis([asse(1:2) 0.7 1.2]);
        datetick('x','d')
        xlabel('weekday')
        ylabel('detrended load (MW)')
        title(strcat('October of year: ',num2str(y)))
        grid
        y=y+1;

    end

end

% spaghetti plot

figure(3)

for i=1:12
    
    md=MD(Y==1999+i);
    wd=WD(Y==1999+i);
    ldet=Ldetrend(Y==1999+i);
    md=md+wd(1)-1;
    
    plot(md,ldet,'*-')
    hold on
    
    pause
    
end
hold off

Lweekday=zeros(7,1);

for d=1:7
    
    Lweekday(d)=mean(Ldetrend(WD==d));
    
end

figure(4)

WL=zeros(size(L));

for i=1:length(L)
    
    WL(i)=Lweekday(WD(i));
    
end


y=2000;

for r=0:2

    for c=1:4

        subplot(3,4,r*4+c)
        plot(dates(years==y),exp(L(years==y)),'*',dates(years==y),exp(M2(y-1999)+WL(years==y)),'d-')
%         asse=axis;
%        axis([asse(1:2) 0.7 1.2]);
        datetick('x','d')
        xlabel('weekday')
        ylabel('load (MW)')
        title(strcat('October of year: ',num2str(y)))
        grid
        y=y+1;

    end

end





Phi=[ones(size(y')) y' (y.^2)']



theta=Phi\M'



Mhat=Phi*theta


figure(5)
plot(y,M,'o-',y,Mhat,'+-')
diary off