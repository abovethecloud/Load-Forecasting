clear all;
close all;
clc;

load datiOTT;


date_ID=datiOTT(:,1);
loads=datiOTT(:,2);
% years=datiOTT(:,3);
years = ones(336,1);
i = 0;
while (i < 12),
    % TODO: Deve prendere i primi 28 dati di ogni anno, quindi
    % datiOTT(1:28,3) poi datiOTT(32:59,3) e così via...
    years(1+i*28:28+i*28) = datiOTT(1+i*31:28+i*31,3);
    i = i + 1;
end

dnum=datiOTT(:,5);
days=datiOTT(:,6);

L=log(loads);
Y=datiOTT(:,3);
MD=dnum;
WD=days;

% Media
for i=1:12,
    M(i)=mean(L(Y==1999+i));
end

% Media su 28 gg
for i=1:12,
    ML=L(Y==1999+i);
    M2(i)=mean(ML(1:28));
end

y=[2000:2011];

% Detrendizzazione dei logaritmi dei carichi
% TODO: Far combaciare i carichi da 28 giorni con quelli da 28
Ldetrend=zeros(size(L));
for i=1:12,
    Ldetrend(Y==1999+i)=L(Y==1999+i)-M2(i);
end

y=2000;
Stagionati = ones(31,7);
j = 1;

figure(1)
for r=0:2,

    for c=1:4,

        i = 1;
        
        Stagionati(i:i+27,j) = exp(Ldetrend(years==y));

        asse=axis;
        axis([asse(1:2) 0.7 1.2]);
        datetick('x','d')

        
        title(strcat('October of year: ',num2str(y)))
        grid
        y = y+1;
        j = j+1;
        subplot(3,4,r*4+c)
% TODO: Aggiungere il plot

    end

end

i = 1;
j = 1;
k = 1;
DeStagionati = ones(28, 12);
MediaSettimanale = ones(4, 12);

while(j < 13),
    while(i < 29),
        DaFareLaMedia = Stagionati(i:i+6,j);
        MediaSettimanale(k, j) = mean(DaFareLaMedia);
        i = i + 7;
        k = 1 + idivide(i,int32(7));
    end
    j = j + 1;
    i = 1;
    k = 1;
end

i = 1;
j = 1;
k = 1;
l = 1;

while(j < 13),
    while(i < 29),
    
    DeStagionati(i:i+6,j) = Stagionati(i:i+6,j) - MediaSettimanale(k,l);
    i = i+7;
    k = k+1;
    
    end
    j = j + 1;
    l = l + 1;
    i = 1;
    k = 1;
end

y = 2000;
j = 1;
i = 0;
figure(2)
% for r=0:2
%     for c=1:4
%         hold all
%         subplot(3,4,r*4+c)
%         plot(date_ID(1+i:28+i),DeStagionati(1:28,j),'d-')
%         asse=axis;
%         axis([asse(1:2) -0.3 0.1]);
%         datetick('x','d')
%         xlabel('Week')
%         ylabel('Load DeStagionalizzato')
%         title(strcat('October of year: ',num2str(y)))
%         grid
%         y = y+1;
%         j = j+1;
%         i = i+28;
%     end
% end

for i=1:12,
    
    Ascisse = date_ID(1+i:28+i);
    Ordinate = DeStagionati(1:28,j);
    %md=md+wd(1)-1;
    Ascisse = Ascisse+Ordinate(1)-1;
    
    plot(Ascisse,Ordinate,'*-')
    j = j + 1;
    hold on
    
    pause
    
end
hold off

% spaghetti plot

% figure(4)
% 
% for i=1:12
%     
%     md=MD(Y==1999+i);
%     wd=WD(Y==1999+i);
%     ldet=Ldetrend(Y==1999+i);
%     md=md+wd(1)-1;
%     
%     plot(md,ldet,'*-')
%     hold on
%     
%     % pause
%     
% end
% hold off

