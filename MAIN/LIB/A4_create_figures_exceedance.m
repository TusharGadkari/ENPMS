function [] = A4_create_figures_exceedance( INI )
%---------------------------------------------
% FUNCTION DESCRIPTION:
%
% BUGS:
% COMMENTS:
%----------------------------------------
% REVISION HISTORY:
%
% changes introduced to v1:  (keb 7/2011)
%  -script would exit prematurely if a STATION name from STATIONS_LIST
%   was not found in the MAP_ALL_DATA container. modified script to 'try'
%   to find station and just issue message if not found
%----------------------------------------
fprintf('\n\n Beginning A4_create_figures_exceedance: %s \n\n',datestr(now));

if (strcmp(INI.MAKE_EXCEEDANCE_PLOTS,'YES') == 0)
    fprintf('... Not making exceedance plots, exit A4\n');
    return
end


FILEDATA = INI.FILESAVE_STAT;
fprintf('\n... Loading Computed and observed and stat data:\n\t %s\n', char(FILEDATA));
load(FILEDATA, '-mat');


% only do the selected stations
STATIONS_LIST = INI.SELECTED_STATIONS.list.stat;

for M = STATIONS_LIST
    try
      fprintf('\n...processing station exceedance plot %s:', char(M));
      STATION = MAP_ALL_DATA(char(M));  %get a tmp structure, modify values
       try
            plot_exceedance(STATION,INI);
       catch
         fprintf(' --> no mapped data or elevations');
       end
    catch
       fprintf(' --> cannot find in MAP_ALL_DATA container');
    end
end

end

