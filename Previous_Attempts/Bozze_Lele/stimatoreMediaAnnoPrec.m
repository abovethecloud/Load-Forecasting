% Stimatore banale: il consumo di un giorno è pari alla media di tutti i
% giorni dell'anno precendente con la stessa posizione nella settimana.

function L_hat = stimatoreMediaAnnoPrec(datiWeek)
%L_hat = predizione2(datiWeek)
% predittore banale basato sulla media dei consumi
% dello stesso giorno della settimana, ma dell'anno precedente

load datiOTT

anno=datiWeek(1,3);
giorno=datiWeek(1,6);

years = datiOTT(:,3);
days = datiOTT(:,6);

L_hat=mean(datiOTT(years==anno-1 & days==giorno,2));
end