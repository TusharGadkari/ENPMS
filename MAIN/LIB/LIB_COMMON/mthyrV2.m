function [OUT] = mthyrV2(TS, ValueVector)

%{
Computes the monthly and annual totals and averages for the ValueVector
Skips over NaN, adjusts the cntrs
returns  an array of monthly averages for each year and
the vector of annual averages
%}
cntr=1;mcntr=1;yrcntr=1;mth=1;
totyr=0;totmth=0;numyrdays=0;nummthdays=0;
permth=zeros(length(TS.yrs),12);
peryr=zeros(length(TS.yrs));
% OUT.permthave=zeros(length(TS.yrs),12);
% OUT.peryrave=zeros(length(TS.yrs));
OUT.permthave(length(TS.yrs),12)= NaN;
OUT.peryrave(length(TS.yrs)) = NaN;
OUT.permthtot(length(TS.yrs),12)= NaN;
OUT.peryrtot(length(TS.yrs)) = NaN;

for dy = 1 : TS.cumtotyrdays(end)
    if ~isnan(ValueVector(cntr))
        totmth= totmth + ValueVector(cntr);
        totyr = totyr + ValueVector(cntr);
        numyrdays = numyrdays + 1;
        nummthdays = nummthdays + 1;
    end
        %MONTHLY
    if (~mod(dy,TS.cumtotmthdays(mcntr)))
        if (nummthdays == 0) totmth = NaN; end;
        OUT.permthtot(yrcntr,mth)=totmth;
        %avemth = totmth / nummthdays;
        OUT.permthave(yrcntr,mth) = totmth / nummthdays;
         %fprintf('%04d   %05d  %03d  %02d/15/%d %7.1f %6.2f\n', mcntr, cntr, nummthdays, mth, TS.yrs(yrcntr), totmth, avemth);
         %fprintf('%02d/15/%d %6.2f %04d\n', mth, TS.yrs(yrcntr), avemth, nummthdays);
         if (mth == 12)
             mth=1;
         else
             mth=mth+1;
         end
         totmth=0; nummthdays=0;
         mcntr=mcntr+1;
    end
        %ANNUAL
    if (~mod(dy,TS.cumtotyrdays(yrcntr)))
        if (numyrdays == 0) totyr = NaN; end;
        peryr(yrcntr) =totyr;
        OUT.peryrtot(yrcntr) = totyr;
        OUT.peryrave(yrcntr) = totyr / numyrdays;
        %fprintf('%04d   %05d  %03d %03d %d %7.1f %6.2f\n', yrcntr, cntr, TS.totyrdays(yrcntr), numyrdays, TS.yrs(yrcntr), totyr, OUT.peryrave);
        %fprintf('%d %6.2f %04d\n', TS.yrs(yrcntr), OUT.peryrave(yrcntr), numyrdays);
        totyr=0;
        numyrdays = 0;
        yrcntr=yrcntr+1;
    end
    cntr=cntr+1;
end

end
%%%%%%%%%%%%%%%%%%% DO NOT DELETE
    %output to file
% % printyrxls = [outdir 'tmpyr.xlsx'];
% % printmthxls = [outdir 'tmpmth.xlsx'];
% printyrasc = [outdir 'tmpyr.asc'];
% printmthasc = [outdir 'tmpmth.asc'];
% fidyr=fopen(char(printyrasc),'w');
% %fprintf(fidyr,'cntr   tdays days num year  anntot annave\n');
% fprintf(fidyr,'year annave  num\n');
% fidmth=fopen(char(printmthasc),'w');
% %fprintf(fidmth,'cntr   tdays days     date     mthtot mthave\n');
% fprintf(fidmth,'   date    mthave  num\n');
% fclose(fidyr);
% fclose(fidmth);

