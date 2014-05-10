function [output_args] = generate_latex_filesV3(MO,MS,SIM,INI,F)
% added (currently unused) INI to input args in prepaation of future changes rjf 12/19/2011

fprintf('... Generating the LATEX file\n');

fidTEX = generate_latex_headV2(SIM);

%rjf; TODO,  paging not working correctly, not according to
%input file settings, now set to do clearpage after 3 figs.

%TODO: the loop does generate timeseries then goes to catch, why??
%  seems to generate the figures ok maybe one of the next if?


for M = keys(MO)
try
    STATION_LIST = MO(char(M));
    
    FFIG = 'obsolete';
		%group subsection
	fprintf(fidTEX,'%s\n','\clearpage');
	row2 =['\subsection{' char(M) '}'];
	fprintf(fidTEX,'%s\n\n',row2);

		% add subsubsection timeseries
    generate_area_figures_timeseriesV2(M, STATION_LIST,FFIG,F,SIM,fidTEX);
    
    if (strcmp(INI.MAKE_EXCEEDANCE_PLOTS,'YES') == 1 )
            % add subsubsection exceedance
        fprintf('... Including exceedance plots in the LATEX file\n');
        generate_area_figures_exceedanceV2(M, STATION_LIST,FFIG,F,SIM,fidTEX);
    end
    
    if (strcmp(INI.MAKE_STATISTICS_TABLE,'YES') == 1 )
		% add subsubsection statistics
        fprintf('... Including statistics in the LATEX file\n');
    	fprintf(fidTEX,'%s\n','\clearpage');
    	row2 =['\subsubsection{Statistics Tables}'];
    	fprintf(fidTEX,'%s\n\n',row2);
    	generate_area_tablesV2(M, MS, STATION_LIST,FFIG,F,SIM,fidTEX);
    end
catch
  fprintf ('...skipping in latex  %s\n',char(M));
end

end
generate_latex_tailV2(fidTEX);


end
