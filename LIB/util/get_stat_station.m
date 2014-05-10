function [STATION_STAT] = get_stat_stationV1(STATION,SIM,F)
%rjf; deleted args SIM and F, not used herein
VPE = [0.01 0.05 0.10 0.20 0.50 0.80 0.90 0.95 0.99];

CASES = keys(STATION.TS_NAN);
i = 1;
S = [];
PE = [];
MODELRUN = {};

for K = CASES
    TS = STATION.TS_NAN(char(K));
%     if int32(TS.COUNT) == 0; continue, end
    MODELRUN(i) = K;
    N(i) = TS.NAME;
    S(i,1) = int32(TS.COUNT);
    S(i,2) = TS.ME;
    S(i,3) = TS.MAE;
    S(i,4) = TS.RMSE;
    S(i,5) = TS.STD;
    S(i,6) = TS.NS;
    S(i,7) = TS.COVAR;
    S(i,8) = TS.COR;
    S(i,9) = TS.PEV;
    i = i + 1;
end

i = 1;
for K = CASES
    TS = STATION.TS_NAN(char(K)).TS;
%     if int32(STATION.TS_NAN(char(K)).COUNT) == 0; continue, end
    if ~isempty(TS)
        for ii = 1:9
            PE(i,ii) = get_PEv0(VPE(ii),TS);
        end
        i = i + 1;
    else
        PE(i,1:9) = NaN;
    end
end

STATION_STAT.NAME = STATION.NAME;
STATION_STAT.DFSTYPE = STATION.DFSTYPE;
STATION_STAT.UNIT = STATION.UNIT;
STATION_STAT.MODELRUN = MODELRUN;
STATION_STAT.STAT = S;
STATION_STAT.PE = PE;

end

