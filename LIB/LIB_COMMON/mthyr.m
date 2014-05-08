function [OUT] = mthyr(TS, ValueVector)

%{
Computes the monthly and annual averages for the ValueVector
Skips over NaN
returns  an array of monthly averages for each year and
the a vector of annual averages
%}
cntr=1;mcntr=1;yrcntr=1;mth=1;
totyr=0;totmth=0;numyrdays=0;nummthdays=0;
permth=zeros(length(TS.yrs),12);
OUT.permthave=zeros(length(TS.yrs),12);
peryr=zeros(length(TS.yrs));
OUT.peryrave=zeros(length(TS.yrs));

for dy = 1 : TS.cumtotyrdays(end)
    if ~isnan(ValueVector(cntr))
        totmth= totmth + ValueVector(cntr);
        totyr = totyr + ValueVector(cntr);
        numyrdays = numyrdays + 1;
        nummthdays = nummthdays + 1;
    end
        %MONTHLY
    if (~mod(dy,TS.cumtotmthdays(mcntr)))
        permth(yrcntr,mth)=totmth;
        avemth = totmth / nummthdays;
        OUT.permthave(yrcntr,mth) = avemth;
%          fprintf(fidmth,'%04d   %05d  %03d  %02d/15/%d %7.1f %6.2f\n', mcntr, cntr, nummthdays, mth, TS.yrs(yrcntr), totmth, avemth);
%         fprintf(fidmth,'%02d/15/%d %6.2f %04d\n', mth, TS.yrs(yrcntr), avemth, nummthdays);
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
        peryr(yrcntr) =totyr;
        OUT.peryrave(yrcntr) = totyr / numyrdays;
%        fprintf(fidyr,'%04d   %05d  %03d %03d %d %7.1f %6.2f\n', yrcntr, cntr, TS.totyrdays(yrcntr), numyrdays, TS.yrs(yrcntr), totyr, aveperyr);
%         fprintf(fidyr,'%d %6.2f %04d\n', TS.yrs(yrcntr), aveperyr, numyrdays);
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

