 function L_hat = stimatoreAR(datiWeek)
%STIMATOREAR Summary of this function goes here
%   Detailed explanation goes here

load datiOTT

% Prelevo le info sui dati settimana:
giorni_settimana = datiWeek(:, 6);
giorni_mese = datiWeek(:, 5);
anno = unique(datiWeek(:, 3));
dati = datiWeek(:, 2);
    log_dati = log(dati);
date = datiWeek(:, 1);

% Detrend
log_dati_detrend = log_dati - mean(log_dati);

% Destag
loadsRemaining = log_dati_detrend; % Vettore che conterra' i dati destagionalizzati
meanDailyLoad = [-0.239674947019469 0.015877332975354 0.076934116678350 0.080139545724700 0.079664665770198 0.069665000109273 -0.085255188426933]
for d = 1:7,
    booleanD = (giorni_settimana == d);
    % Destagionalizzazione
    meanDailyLoad(d)
    loadsRemaining = loadsRemaining - meanDailyLoad(d)*(booleanD);
    
end


%% Stima AR
loads_realization = [-0.0117884781420819;-0.0222158759705362;-0.0138290228209034;0.0178808405196209;-0.0120846372831600;-0.0163979541493757;-0.000899893693430395;-0.00508814501026428;-0.0103964394165334;0.0132575271147977;0.0407532548782034;0.0111732961089815;0.00521403743836248;0.0131090764113026;0.000271438906666865;-0.00233424371460164;-0.00320631053005518;0.0252969032226042;-0.133489065097653]'% = loadsIrregularity(years == 2010)';
% loads_realization = [-912.128328470595 122.662882422765 -107.714719114406 -262.948042486957 -319.174981793632 66.3100334216476 -445.836418413823 -1174.91225371217 -385.201826462902 179.664789012852 165.023099634303 358.521312233640 751.104228462661 445.080566737087 -518.188685255567 43.6124208967250 -73.1275152795088 -159.013095451543 -151.231605568940 147.666869373014 -116.566563275439 -876.698094775411 177.988127210274 310.774535866113 370.956607019748 529.686308005443 742.161808760073 96.1361897305319 -580.311391211091 711.380980009608 266.255861467221 153.201829124782 467.637636770706 314.934580562946 347.348960020376 543.402518814525 -40.9248567923682 -826.970811609202 576.545559012169 477.704300508974 471.041980453389 357.066251711611 325.998604779678 -644.042771004483 -1402.65192108206 75.7888727147130 322.131734248834 193.009920475562 191.629744949937 513.623519818172 -140.050894770906 -1257.46068612571 29.8996952928811 385.204428257556 98.7351894063731 -34.1411146977621 61.5888794709178 -627.583738582322 -1203.79660029211 -67.1223353890617 -12.1515502293978 -234.265031390230 118.578264338445 177.552920844294 389.995352219773 798.807092731870 -47.2505726875684 -967.706956075510 385.128096880419 610.264752607928 850.493901551538 1051.20697285038 878.653241736051 -213.796928857876 -1257.68725220378 201.143977444341 498.477520218233 581.037957428071 469.210568875813 -3262.24272362728 -2037.32551255131 -1508.40734166663 305.071104711247 637.863162548002 374.008391209009 265.217336955179 442.959542917023 -205.915774551399 -938.859662380330 468.601847506207 523.095370805667 439.455783277114 151.569033123288 715.664697430309 775.493311126433 1228.23164593806 -112.950970521961 -1342.27898337296 -582.188155978341 -255.316086295009 -381.134380024442 -512.182978608951 -74.4087996197516 -770.216398450721 -1432.88585286019 276.170378377034 491.049850328681 318.119658275770 -70.4526887505776 321.485115151711 -99.4246349989303 -1023.75798619885 785.327482941439 595.103164087291 844.588974219442 813.345448690052 -1717.31791201328 -1378.15216493974 -743.855003447696 861.938271057743 1204.46238039534 1595.90436952331 1077.81673941061 1208.45435944810 329.931485740338 -597.721372044289 -1350.75321616258 7.99702040368186 433.117956302555 652.269849931673 688.325220806819 931.318865267393 -34.9681903224523 -1014.68993409572 450.962839585247 402.958147135539 124.931089132549 -60.5784288225727 182.294424051783 -917.487705624510 -1809.87450319770 -343.105415462285 575.797213038791 614.168434779863 594.861066536655 654.789114813423 -404.036008855867 -1314.48325328671 338.047208452326 572.839648283986 29.3519173346913 -58.0530069339834 134.888836935934 -976.092556517579 -1656.07538694472 -1170.47846617624 -1669.66378248310 446.845227360633 444.953283935030 566.717836927245 636.811043962779 1029.54897197012 -520.241380399359 -1799.63915786556 138.773824583341 433.102901271174 358.824967998437 261.174842502122 602.743293064112 -639.438996056539 -1963.87115366023 255.650982959620 561.617273189354 931.740309942275 859.951366863651 824.866097284507 -682.693614039873 -1735.98178559687 210.948500353197 499.717841938175 436.306222633772 291.315320457310 -26.1096799758627 -1209.51739092139 -2075.88729353911 -4230.35119007934 -1438.90602757159 804.767375600206 1526.20043946271 1218.00638208156 567.387852931141 587.925565006267 -607.957272964468 -2164.37087599976 -233.036096941423 48.1604207803694 168.042329062861 254.252711891925 560.375815487588 -746.708533634920 -2165.23026469845 -297.711861316789 7.55528153097930 118.630499782827 510.496164385092 891.689373122824 -368.472458704801 -1766.03511000680 465.825716919413 702.702155894230 614.926643856962 466.703827886282 767.826413400359 -487.945840412828 -1768.31572131672 -285.540199120804 -528.369063063415 -270.392199683743 121.139078748319 500.336280219731 774.657013788034 823.637476649729 -434.405211274654 -1964.98900286191 -194.985738012057 129.634583142914 143.805440762256 -23.9041968138913 53.1545506778318 -1230.85763551369 -2459.15538354764 -515.447595452022 1360.81704958096 121.603670484671 293.358189242201 272.604578666372 -890.075959415881 -1768.96798380967 842.872255826080 1030.80766720887 1423.35090612999 1262.14441171580 1506.16710615241 -506.892471783347 -1215.09755677889 314.672808390295 -337.573991262586 -464.205834059640 417.775346897318 854.219734502964 962.163697292356 -820.585483400857 -1470.01975082443 35.7217842906777 467.282533499711 403.870413381193 383.472646602801 534.723743504231 -687.302181518081 -1395.71480833045 63.3854417903295 272.596515581602 387.527024321856 580.146337414830 406.107874521532 -714.710090264984 -1466.04433833208 82.8371943492840 296.804579557219 331.371524846371 347.869929234178 213.905516347685 -697.454254462115 -1096.12004811540 365.079567132069 525.289097777794 602.770944300283 -2.19518481205114 22.4322330608891 577.556236131110 286.826205282200 -505.840985539926 -961.058283515422 70.8700740766454 169.864209684297 354.857113215608 359.093038576379 -149.934090051126 -606.926349796996 -974.983826812788 -82.8049560300332 -618.686683481958 -483.413516881242 -73.1535956958392 173.597770909405 -185.750842252983 -581.528409610464 438.707668428915 760.281612815242 987.472734502358 1039.39567180496 843.175424653706 -138.877837028246 -554.423175917460 -119.114662352234 -63.6676663999451 -30.2560527832820 -51.9138257032751 18.1107694424907 -404.368014713630 -1823.91549542686 2352.66285475717 5957.04378456221 -322.380531535919 -2054.36249583692 -2125.49374509502 -2128.03979490101 -1823.91549542686 2352.66285475717 5957.04378456221 -322.380531535919 -2054.36249583692 -2125.49374509502 -2128.03979490101 -1823.91549542686 2352.66285475717 5957.04378456221 -322.380531535919 -2054.36249583692 -2125.49374509502 -2128.03979490101 -1823.91549542686 2352.66285475717 5957.04378456221 -322.380531535919 -2054.36249583692 -2125.49374509502 -2128.03979490101 -1823.91549542686 2352.66285475717 5957.04378456221 2352.66285475717 5957.04378456221 -322.380531535919 -2054.36249583692 -2125.49374509502 -2128.03979490101 -1823.91549542686 2352.66285475717 5957.04378456221 -322.380531535919 -2054.36249583692 -2125.49374509502 -2128.03979490101 -1823.91549542686 2352.66285475717 5957.04378456221 -322.380531535919 -2054.36249583692 -2125.49374509502 -2128.03979490101 -1823.91549542686 2352.66285475717 5957.04378456221 -322.380531535919 -2054.36249583692 -2125.49374509502 -2128.03979490101 -1823.91549542686 2352.66285475717 5957.04378456221 -322.380531535919];
m = ar(loads_realization, 1)
m.a

yf = forecast(m,loadsRemaining,1)
giorno_succ = giorni_settimana(7)+1;
if giorno_succ > 7,
    giorno_succ = 1;
end
yf = yf + meanDailyLoad(giorno_succ)
yf = yf + mean(log_dati)


% L_hat=mean(datiOTT(years==anno-1 & dayOfWeek==giorni,2));
L_hat = yf;

end

