function [STATION] = summarize_YM(STATION,INI)

% K = keys(STATION.TS_NAN);

sz = length(INI.MODEL_ALL_RUNS);
TV = STATION.TIMEVECTOR';
TS = STATION.TIMESERIES;
i_obs = sz + 1;
% this function should remove 
n = length(TS(1,:));


for k = 1:n
    [QYM(k)] = get_ave_YM(TV,TS(:,k));
end

STATION.QYM = QYM;


end