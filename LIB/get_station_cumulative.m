function [STATION] = get_station_stat(STATION)

%{
FUNCTION DESCRIPTION:
BUGS:
COMMENTS:
----------------------------------------
REVISION HISTORY:

v0 revisions (rjf 12/2011):
-call get_RMSEv1 (changed the formula)

%}

K = keys(STATION.TS_NAN);

for k = K
    TS = STATION.TS_NAN(char(k));
    COUNT = get_COUNTv0(TS.TS);
    TS.COUNT = COUNT;
    if (COUNT <= 3)
        ME = NaN;
        MAE = NaN;
        RMSE = NaN;
        STD = NaN;
        NS = NaN;
        COVAR = NaN;
        COR = NaN;
        PEV = NaN;
        TS_HEADER = '';
    else
        ME = get_MEv0(TS.TS);
        MAE = get_MAEv0(TS.TS);
        RMSE = get_RMSEv1(TS.TS);
        STD = get_STDresV0(TS.TS,ME);
        NS = get_NSv0(TS.TS);
        COVAR = get_COVARv0(TS.TS,COUNT);
        COR = get_CORv0(TS.TS);
        PEV = get_PEVv0(TS.TS,COUNT);
        [TS.TS TS_HEADER] = calculate_exceedanceV0(TS.TS);
    end
    
    TS.ME = ME;
    TS.MAE = MAE;
    TS.RMSE = RMSE;
    TS.STD = STD;
    TS.NS = NS;
    TS.COVAR = COVAR;
    TS.COR = COR;
    TS.PEV = PEV;
    TS.TS_HEADER = TS_HEADER;
    STATION.TS_NAN(char(k)) = TS;
end


end
