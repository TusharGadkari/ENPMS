function [] = generate_latex_filesV4(MO,MS,INI)
%021812 - changed to only using INI
% added (currently unused) INI to input args in prepaation of future changes rjf 12/19/2011

fprintf('... Generating the LATEX file\n');
fidTEX = generate_latex_headV3(INI);

FILEDATA = INI.FILESAVE_TS;
%fprintf('... Loading Computed and observed data:\n\t %s\n', char(FILEDATA));
load(FILEDATA, '-mat');




for M = keys(MO)
% % % try
    STATION_LIST = MO(char(M));
%     FFIG = 'obsolete';
		%group subsection
% 	fprintf(fidTEX,'%s\n','\clearpage');
% 	row2 =['\subsection{' char(M) '}'];
% 	fprintf(fidTEX,'%s\n\n',row2);

		% add subsubsection timeseries
    generate_page_figures(M, STATION_LIST,MAP_ALL_DATA,INI,fidTEX);
% %     if (strcmp(INI.MAKE_EXCEEDANCE_PLOTS,'YES') == 1 )
% %             % add subsubsection exceedance
% %         fprintf('... Including exceedance plots in the LATEX file\n');
% %         generate_area_figures_exceedanceV2(M, STATION_LIST,INI,fidTEX);
% %     end
    
    if (strcmp(INI.MAKE_STATISTICS_TABLE,'YES') == 1 )
		% add subsubsection statistics
        fprintf('... Including statistics in the LATEX file\n');
    	fprintf(fidTEX,'%s\n','\clearpage');
    	row2 =['\subsubsection{Statistics Tables}'];
    	fprintf(fidTEX,'%s\n\n',row2);
    	generate_area_tablesV2(M, MS, STATION_LIST,INI,fidTEX);
    end
% % % catch
% % %   fprintf ('...skipping in latex  %s\n',char(M));
% % % end

end
generate_latex_tailV2(fidTEX);


end
