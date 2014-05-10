function [output_args] = print_input(LMS,FILES,fidTEX)

LATEX_FILES = FILES.LATEX_MAIN;
%%%LATEX_FILES = FILES.LATEX_FILES;
%%%PRE = FILES.inputPREFIX;
PRE = 'firsttry';

%rjf; HARDCODE !!!!!!!!!!!!!!!!!!!!!!!!!
tstat = ['E:\APPS\matlab\working\rjf\A-scripts\output\firsttry\latex\tabstat\' char(LMS) '.tex'];
tpe = ['E:\APPS\matlab\working\rjf\A-scripts\output\firsttry\latex\tabpe\' char(LMS) '.tex'];
fig = ['E:\APPS\matlab\working\rjf\A-scripts\output\firsttry\latex\figs\' char(LMS) '.tex'];

tstat

if exist(tstat,'file')
    ROW1 = ['\input{' tstat '}'];
    fprintf(fidTEX,'%s\n\n',ROW1);
end

if exist(tpe,'file')
    ROW2 = ['\input{' tpe '}'];
    fprintf(fidTEX,'%s\n\n',ROW2);
end

if exist(fig,'file')
    ROW3 = ['\input{' fig '}'];
    fprintf(fidTEX,'%s\n\n',ROW3);
end


%%%fig = [LATEX_FILES 'FIGURES_' char(LMS) '.tex'];
%%%tstat = [LATEX_FILES 'TABLE_STAT_' char(LMS) '.tex'];
%%%tpe = [LATEX_FILES 'TABLE_PE_' char(LMS) '.tex'];
%%%if exist(fig,'file')
%%%    ROW3 = ['\input{' PRE 'FIGURES_' char(LMS) '}'];
%%%    fprintf(fidTEX,'%s\n\n',ROW3);
%%%end
%%%if exist(fig,'file')
%%%    ROW1 = ['\input{' PRE 'TABLE_STAT_' char(LMS) '}'];
%%%    fprintf(fidTEX,'%s\n\n',ROW1);
%%%end
%%%if exist(fig,'file')
%%%    ROW2 = ['\input{' PRE 'TABLE_PE_' char(LMS) '}'];
%%%    fprintf(fidTEX,'%s\n\n',ROW2);
%%%end

end

