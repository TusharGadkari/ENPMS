function [ValVect] = computeAvefillDataV1(TS, TSS, ValVect)
%{
    Compute daily averages for the timeseries data
    Excludes NaN
    Fill the value vector from 
%}
    i=1; j=1; cntr=1;
    %%%totalyrval=0;
    dayofyear = zeros(1,366); iday = 1; vcntr=zeros(1,366);
    
if(length(ValVect) > length(TS.TimeseriesData))
    tlength = length(TS.TimeseriesData);
else
    tlength = length(ValVect);
end

    %total each day
%%%    for dy = 1 : TS.cumtotyrdays(end)
    for dy = 1 : tlength
    %    if (~isnan(TS.TimeseriesData(cntr)))
        if (~isnan(ValVect(cntr)))
            %%%totalyrval = totalyrval + ValVect(cntr);
            dayofyear(iday) = dayofyear(iday) + ValVect(cntr);
            vcntr(iday) = vcntr(iday) + 1;
        end
        if (mod(dy,TS.cumtotyrdays(j)))
            iday =iday + 1;
        else
            %fprintf('cntr= %04d iday= %03d year= %d totyrdays= %d cumtotyrdays= %d\n', cntr, iday, TS.yrs(j), TS.totyrdays(j), TS.cumtotyrdays(j));
            j=j+1;
            iday =1;
            %%%totalyrval=0;
        end
        cntr=cntr+1;
    end
    kk=1;
    j=1;
    %average each day and fill the value vector from the start
    % with the repeating daily averages
    % to where the timeseries data started
    %set leap year value to num=365
    


filllength = datenum(TSS.dfsstartdate)- datenum(TS.startdate);
   
%    for jj = 1 : TSS.dfsstart
    for jj = 1 : filllength
        ValVect(jj) = dayofyear(kk)/vcntr(kk);
        if (kk ==  TS.totyrdays(j))
            if (kk ==  366) ValVect(jj) = ValVect(jj-1); end
            kk=1;
            j=j+1;
        end
        kk=kk+1;
        %fprintf('%03d %03d %04d %7.2f %7.2f %7.2f\n',jj, kk, vcntr(kk),TS.yrs(j),TS.totyrdays(j),dayofyear(kk)/vcntr(kk))
    end
    
    
    % fill from the end of the timeseries to the end of the value vector
    %display(datevec(TS.dfsstartdate))
    %display(datevec(TSS.dfsenddate))
    startdayoftheyear = datevec2doy(datevec(TSS.dfsenddate+1));
    kk=startdayoftheyear;
    
    totmthdays = [31 28 31 30 31 30 31 31 30 31 30 31];
    whichMonth = min(find(startdayoftheyear<cumsum(totmthdays)));
    j=whichMonth;
    
    
    
%display(datevec(TSS.DfsTime))
%display(datevec(TSS.dfsend))
lastnonzero=find(~isnan(ValVect),1,'last');

%      for jj = TSS.dfsend : length(ValVect)
    for jj = lastnonzero : length(ValVect)
        ValVect(jj) = dayofyear(kk)/vcntr(kk);
        if (kk ==  TS.totyrdays(j))
            if (kk ==  366) ValVect(jj) = ValVect(jj-1); end
            kk=1;
            j=j+1;
        end
        kk=kk+1;
        %fprintf('%03d %03d %04d %7.2f %7.2f %7.2f\n',jj, kk, vcntr(kk),TS.yrs(j),TS.totyrdays(j),dayofyear(kk)/vcntr(kk))
    end
  
    
    
    
end