function [MAP_TS_NAN] = remove_nanV1(STATION,INI)

%rjf; changed over from SIM to INI

sz = length(INI.MODEL_ALL_RUNS);
TV = STATION.TIMEVECTOR;
i_obs = sz + 1;
% this function should remove 
for i = 1:sz
    %TS1 = 
    MK = INI.MODEL_ALL_RUNS(i);
    TS(:,1) = TV;
    TS(:,2) = STATION.TIMESERIES(:,i);
    TS(:,3) = STATION.TIMESERIES(:,i_obs);
    DIFF = TS(:,2)-TS(:,3);
    TS(:,4) = DIFF;
    A = TS(:,1:4);
    % a temporary array A is needed so that each run can have its own
    % length, if not the statement below clears the entire TS
    A(any(isnan(A),2),:) = [];
    [szv szh] = size(A);
%     if ~szv , continue, end
    TS_NAN(i).TS = A;
    TS_NAN(i).NAME = MK;
    MAP_KEY(i) = MK;
    MAP_VALUE(i) = {TS_NAN(i)};
    clear A, TS;
end
    MAP_TS_NAN = containers.Map(MAP_KEY, MAP_VALUE);
end
