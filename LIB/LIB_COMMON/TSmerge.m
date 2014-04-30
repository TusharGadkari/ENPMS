function [ValueVector] = TSmerge(TSdata, dlength, aI, aF, cI, cF)
%{
    Create and NaN the value vector for the desired length
    Set the timeseries data to within the requested interval
    and replace NaN in the value vector with the data
%}
%fprintf('%d %d %d %d %d\n',dlength,aI,aF,cI,cF);
    ValueVector(1:dlength) = NaN;
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
%fprintf('%d %d %d %d\n',i_aI,i_aF,i_cI,i_cF);
    ValueVector(i_aI:i_aF) = TSdata(i_cI:i_cF);
end
