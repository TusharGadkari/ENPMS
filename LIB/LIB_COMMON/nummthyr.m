function [TS] = nummthyr(TS)
%{
Set up the length of time requested from startdate and enddate
Set up year and month lists, accounts for leap yr
%}
        %the length of time of the desired output vector
    TS.dlength =datenum(TS.enddate) - datenum(TS.startdate) + 1;
    TIMEINTS = linspace(datenum(TS.startdate),datenum(TS.enddate),TS.dlength); % linearly spaced vector of date ints: 23456
    TS.TIMEVECS = datevec(TIMEINTS); % convert date ints to date vecs: [2003  10  24  12  45  07]
        % unique years
    TS.yrs = unique (TS.TIMEVECS(:,1));
        %create vector of 0 or 1 for leapyears
    xlpyr = ~mod(TS.yrs,4) & (mod(TS.yrs,100) | ~mod(TS.yrs,400));
        %%%%%%%%ANNUAL
        % total days for each year
    TS.totyrdays = repmat(365,length(TS.yrs),1) + xlpyr;
        % accumulate the days
    TS.cumtotyrdays = cumsum (TS.totyrdays);
        %%%%%%%MONTHLY
    totmthdays = [31 28 31 30 31 30 31 31 30 31 30 31];
        % create an array of months for the no of years
    mtharray= repmat (totmthdays, length(TS.yrs), 1);
        %adjust feb for leap yr
    mtharray(:,2) = mtharray(:,2) + xlpyr;
        %vectorize the array
    vec= reshape(mtharray',length(TS.yrs)*12,1);
        %accumulate the number of days for each month
    TS.cumtotmthdays = cumsum(vec);
end
