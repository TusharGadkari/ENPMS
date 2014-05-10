function [D_TIMESERIES] = ts_mergeV0(DATA_TMP,DATE_I,DATE_F)
% 2011-10-11 keb - added comments
% 2011-10-25 keb - corrected typo in comment
% 2011-10-26 keb - added more comments

% variables (arguments & return values):
% DATA_TMP is a data structure. it must contain:
% DATA_TMP.TIMESERIES (the data, looks like it can be any type)
% DATA_TMP.TIMEVECTOR 
% DATE_I is a date string, date vector, or integer date
% DATE_F is same as DATE_I
% D_TIMESERIES is same datatype as DATA_TMP.TIMESERIES

%cI is begin date of input (computed) data
%cF is end   date of input (computed) data
cI = datenum(DATA_TMP.TIMEVECTOR(1,:));
cF = datenum(DATA_TMP.TIMEVECTOR(end,:));

%aI is begin date of trimmed data to analyze
%aF is end   date of trimmed data to analyze
aI = datenum(DATE_I);
aF = datenum(DATE_F);

% initialize D_TIMESERIES output array 
D_TIMESERIES(1: aF - aI + 1) = NaN;
D_TIMESERIES = D_TIMESERIES';

if (aI >= cI)
    d = aI - cI;
    i_aI = 1;
    i_cI = 1 + d;
else
    d = cI - aI;
    i_cI = 1;
    i_aI= 1 + d;
end

if (aF >= cF)
    d = aF - cF;
    i_aF = (aF - aI) - d + 1;
    i_cF = cF - cI + 1;
else
    d = cF - aF;
    i_aF = aF - aI + 1;
    i_cF = cF - cI + 1 - d;
end

D_TIMESERIES(i_aI:i_aF) = DATA_TMP.TIMESERIES(i_cI:i_cF);

end
