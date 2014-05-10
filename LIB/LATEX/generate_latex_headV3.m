function [fidTEX] = generate_latex_headV2( SIM)
% 2011-10-07 keb - path for readme.txt file updated to current location in new directory structure using RELATIVE reference. a bit hacky.
% 2011-10-12 keb - changed readme.txt include to verbatim style
% 2011-10-12 keb - changed row1 section header to generic title and moved description from station file below it
% 2011-10-13 keb - added try statement for readme so wouldn't crash if none found

FFF_TEX = [SIM.LATEX_DIR '/' SIM.ANALYSIS_TAG '.tex'];
fidTEX = fopen(FFF_TEX,'w');

row0 = ['\input{headV1.sty}'];
%row1 =['\section{' SIM.SELECTED_STATIONS.header '}']; % removed 2011-10-12 keb
row1 =['\section{Simulation Information}']; % added 2011-10-12 keb
row2 =[ SIM.SELECTED_STATIONS.header ]; % added 2011-10-12 keb

fprintf(fidTEX,'%s\n\n',row0);
fprintf(fidTEX,'%s\n\n',row1);
fprintf(fidTEX,'%s\n\n',row2); % added 2011-10-12 keb

% include the readme file
for i = 1:SIM.NSIMULATIONS
   try % added 2011-10-13 keb so doesn't boot out if no readme exists
    %rowt = ['Simulation run readme: ' SIM.MODEL_SIMULATION_SET{i}{3}]; % removed 2011-10-12 keb
    rowt = ['\paragraph{Simulation run readme: ' SIM.MODEL_SIMULATION_SET{i}{3} '}']; % added 2011-10-12 keb
    fprintf(fidTEX,'%s\n',rowt);

    [path,name.ext,versn] = fileparts(SIM.MODEL_SIMULATION_SET{i}{1});
    readme = [path '../../DHIMODEL/SIMULATIONS/M3ENP/' name.ext '/readme.txt']
    %2011-10-07 keb - changed to reflect new directory structure
    %copyfile([path '/readme.txt'], SIM.LATEX_DIR );
    copyfile( readme, SIM.LATEX_DIR )
    
    movefile ([SIM.LATEX_DIR  '/readme.txt'],[SIM.LATEX_DIR '/' SIM.MODEL_SIMULATION_SET{i}{3} '-readme.txt']);
    readmefile = [SIM.MODEL_SIMULATION_SET{i}{3} '-readme.txt'];
    %keb 2011-10-12 changed to verbatim blue font for readmefiles to avoid 
    % compilation and formatting problems. had to add \usepackage{verbatim}
    %rowi = ['\input{' readmefile '}']; 
    rowi = ['\vskip 0.1in \verbatiminput{' readmefile '}'];
    fprintf(fidTEX,'%s\n\n',rowi);
   catch
    rowi = ['\vskip 0.1in \emph{file not found: ' readme '}'];
    fprintf(fidTEX,'%s\n\n',rowi);
      
end

end

	fprintf(fidTEX,'%s\n','\clearpage');
end
