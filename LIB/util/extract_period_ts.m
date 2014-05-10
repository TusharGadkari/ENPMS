% takes two vectors of different length containing dates, and should crop both to
% match the DATE_I and DATE_F dates. input dataseries should have same
% time increments
function [TS] = extract_period_ts(TIMESERIES_TMP,TIMEVECTOR_OBS, DATE_I, DATE_F) 

cI = datenum(TIMEVECTOR_OBS(1,:));
cF = datenum(TIMEVECTOR_OBS(end,:));
aI = datenum(DATE_I);
aF = datenum(DATE_F);
TS(1: aF - aI + 1) = NaN;
TS = TS';

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

TS(i_aI:i_aF) = TIMESERIES_TMP(i_cI:i_cF);

end
