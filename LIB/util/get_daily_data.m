function [D_TIME_VEC] = get_daily_data(D, TIME_VECTOR_NONEQ, NUM_DAYS)

%---------------------------------------------
% FUNCTION DESCRIPTION:
%
% this script obtained from Georgio Tachiev at FIU in 2010/2011.
%
% this function provides daily data when the timestep is varying and
% smaller than daily. 
%
% it will only return NUM_DAYS number of values, so if TIME_VECTOR_NONEQ
% spans more than NUM_DAYS days, the ending days will not be returned
%
% this function will return the FIRST value for each new day
% (maybe it should take the average?)
%
% D is array of data on timesteps corresponding to the TIME_VECTOR_NONEQ timesteps
% TIME_VECTOR_NONEQ is time vector on smaller than daily timesteps
%
% (old: TIME_VECTOR is time vector of desired daily timesteps - 
%       IT IS NOT USED, JUST ITS LENGTH IS USED TO SIZE NEW DATA VECTOR)
%
%
% BUGS:
%
% COMMENTS:
%
%----------------------------------------
% REVISION HISTORY:
%
% changes introduced to v1:  (keb 8/2011)
%  -added comments and spacing.
%  -changed TIME_VECTOR input argument to one more representative of its real purpose (just an array length)
%
%  2011-10-07 keb - changed sz_neq calculation to use size instead of
%  length - because time arrays are size [num_days,6], length returns
%  highest dimension whaich is always a minimum of 6 and therefore exceeds the array dimensions if
%  less than 6 days are requested in postproc.
%  
%  2011-10-26 keb - added some comments for clarification
%----------------------------------------

% get lengths of desired and existing time vectors
sz = NUM_DAYS;
%sz_neq = length(TIME_VECTOR_NONEQ); % changed 2011-10-07 keb
[sz_neq,trash] = size(TIME_VECTOR_NONEQ);

% initialize new data vector for extracted data
D_TIME_VEC(1:sz) = NaN;

% initialize k
k = 0;

% initialize timestep variable that will keep track of which day we're on
DLAST = datenum([0 0 0 0 0 0]);

% iterate through all timesteps in noneq array
for i = 1:sz_neq

    % extract just the day from the current timestep, dropping the hours/minutes/seconds
    DNUM = floor(datenum(TIME_VECTOR_NONEQ(i,:)));
    
    % compare with timestep date of last saved value. if this is a new day:
    if (DNUM > DLAST) 
    
        % increment k counter
        k = k + 1;
        
        % save this timestep's data into our new data array
        D_TIME_VEC(k) = D(i);
        
        % update the timestep variable that keeps track of which day we're on
        DLAST = datenum(TIME_VECTOR_NONEQ(i,:));
    end
end

D_TIME_VEC = D_TIME_VEC';
end
