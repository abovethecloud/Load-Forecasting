function L_hat = predizione2(datiWeek, datiOTT)
    %L_hat = predizione2(datiWeek)
    % predittore banale basato sulla media dei consumi
    % dello stesso giorno della settimana, ma dell'anno precedente
    % (ad esempio la media di tutti i giovedì dello scorso anno)
    anno=datiWeek(1,3);
    giorno=datiWeek(1,6);
    load datiOTT;
    years=datiOTT(:,3);
    days=datiOTT(:,6);
    L_hat=mean(datiOTT(years==anno-1 & days==giorno,2));
end