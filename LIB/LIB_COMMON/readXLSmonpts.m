function [MAP_ALL] = readXLSmonpts(MAKETEXTFILE,INI)
% read monpts MikeSHE and M11 xls file,
%  for import to the mikeshe storing of results setup option
%  for use in creating dfso from txt files
%  return the MAPs in a structure

%TODO:

%%%%%%%%%%%
    %add search path
% address = java.net.InetAddress.getLocalHost();
% if (regexp(char(address), 'ENP-PC'))
%     pathdir     = 'C:/MODELS/DHIMODEL/';
%     matdir =  'C:/MODELS/MATLAB/';
%     path(path,[matdir 'mbin']);
%     %path(path,[matdir 'HOBS/common']);
%     %workdir = [matdir 'HOBS/'];
%     path(path,[matdir 'scripts/common']);
%     %outdir = [matdir 'postproc/data/'];
%     %path(path,workdir);
% else
%     pathdir     = 'F:/MODELS/DHIMODEL/';
%     matdir =  'F:/MODELS/MATLAB/';
%     path(path, 'F:/APPS/DHI_2011/MATLAB/mbin');
%     path(path,[matdir 'scripts/common']);
%     %outdir = [matdir 'postproc/data/'];
% end

% if (~exist('xlsfile','var')), disp('Input a xls file'), return; end;
% xlfile2 = [matdir 'postproc/data/' xlsfile];
xlfile2 =  INI.STATION_DATA;

%%%%%%%%%%%%%%%%%%%%
    % Create the text file for 'detailed timeseries input'
    % always returns the structure with the MAP container
if (~exist('MAKETEXTFILE','var')), MAKETEXTFILE = 0; end
    %output file
if (~exist('printname','var')),printMSHEname = [INI.MATDIR 'DATASTRUCTURES/detTSmsheALL.txt']; end
xlsMSHE = 'monpts';
xlsMSHEadd = 'monptsadd';
dfs0MSHEdir=[INI.PATHDIR 'DHIMODEL/INPUTFILES/MSHE/TIMESERIES/'];
dfs0MSHEdpthdir= [INI.PATHDIR 'DHIMODEL/INPUTFILES/MSHE/TSDEPTH/'];
if (~exist('printname','var')),printM11name = [INI.MATDIR 'DATASTRUCTURES/detTSm11ALL.txt']; end
xlsM11 = 'M11';
xlsM11add = 'M11add';
dfs0M11dir=[INI.PATHDIR 'INPUTFILES/M11/TIMESERIES/'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Do the MSHE %%%%%%%%%%%%%%%%%%%%%%%%%
    % read the main MSHE sheet of stations
[~,~,xldata] = xlsread(xlfile2,xlsMSHE);
[numrows,~] = size(xldata);
stat= xldata(1:numrows,1);
utmx = xldata(1:numrows,2);
utmy = xldata(1:numrows,3);
filename = xldata(1:numrows,4);
code = xldata(1:numrows,5);
depth = xldata(1:numrows,6);
row = xldata(1:numrows,7);
col = xldata(1:numrows,8);
dfegse =  xldata(1:numrows,9);
gridgse = xldata(1:numrows,10);

    % create a container of the selected stations
for i = 1:numrows
    N = stat(i);
    DATA0(i).utmx = utmx(i);
    DATA0(i).utmy = utmy(i);
    DATA0(i).filename = filename(i);
    DATA0(i).code = code(i);
    DATA0(i).depth = depth(i);
    DATA0(i).row = row(i);
    DATA0(i).col = col(i);
    DATA0(i).dfegse = dfegse(i);
    DATA0(i).gridgse = gridgse(i);
    MAP_KEY(i) = N;
    MAP_VALUE(i) = {DATA0(i)};
end

    % read the additional monpts
[~,~,xldata] = xlsread(xlfile2,xlsMSHEadd);
[numrowsadd,~] = size(xldata);
stat= xldata(1:numrowsadd,1);
utmx = xldata(1:numrowsadd,2);
utmy = xldata(1:numrowsadd,3);
filename = xldata(1:numrowsadd,4);
code = xldata(1:numrowsadd,5);
depth = xldata(1:numrowsadd,6);
row = xldata(1:numrowsadd,7);
col = xldata(1:numrowsadd,8);
dfegse =  xldata(1:numrowsadd,9);
gridgse = xldata(1:numrowsadd,10);
for i = 1:numrowsadd
    MAP_KEY(numrows+i) = stat(i);
    DATA0(numrows+i).utmx = utmx(i);
    DATA0(numrows+i).utmy = utmy(i);
    DATA0(numrows+i).filename = filename(i);
    DATA0(numrows+i).code = code(i);
    DATA0(numrows+i).depth = depth(i);
    DATA0(numrows+i).row = row(i);
    DATA0(numrows+i).col = col(i);
    DATA0(numrows+i).dfegse = dfegse(i);
    DATA0(numrows+i).gridgse = gridgse(i);
    MAP_VALUE(numrows+i) = {DATA0(numrows+i)};
end

MAP_statMSHE = containers.Map(MAP_KEY, MAP_VALUE);

%%%%%%%%%%%%%%%%%  Do the M11  %%%%%%%%%%%%%%%%%%

[~,~,xldata] = xlsread(xlfile2,xlsM11);
[numrows,~] = size(xldata);
selstat= xldata(1:numrows,1);
%0= water level; 1= discharge
type = xldata(1:numrows,2);
branch = xldata(1:numrows,3);
chain = xldata(1:numrows,4);
filename11 = xldata(1:numrows,5);
utmx = xldata(1:numrows,6);
utmy = xldata(1:numrows,7);

    % create a container of the selected stations
for i = 1:numrows
    MAP_KE(i) = selstat(i);
    DATA1(i).type = type(i);
    DATA1(i).branch = branch(i);
    DATA1(i).filename11 = filename11(i);
    DATA1(i).chain = chain(i);
    DATA1(i).utmx = utmx(i);
    DATA1(i).utmy = utmy(i);
    DATA1(i).gridgse = 0;
    MAP_VALU(i) = {DATA1(i)};
    %fprintf('%s\n', char(selstat(i)));
end

[~,~,xldata] = xlsread(xlfile2,xlsM11add);
[numrowsadd,~] = size(xldata);
selstat= xldata(1:numrowsadd,1);
%0= water level; 1= discharge
type = xldata(1:numrowsadd,2);
branch = xldata(1:numrowsadd,3);
chain = xldata(1:numrowsadd,4);
filename1 = xldata(1:numrowsadd,5);
utmx = xldata(1:numrowsadd,6);
utmy = xldata(1:numrowsadd,7);

    % create a container of the selected stations
for i = 1:numrowsadd
    MAP_KE(numrows+i) = selstat(i);
    DATA1(numrows+i).type = type(i);
    DATA1(numrows+i).branch = branch(i);
    DATA1(numrows+i).filename11 = filename1(i);
    DATA1(numrows+i).chain = chain(i);
    DATA1(i).utmx = utmx(i);
    DATA1(i).utmy = utmy(i);
    DATA1(i).gridgse = 0;
    MAP_VALU(numrows+i) = {DATA1(numrows+i)};
end

MAP_statM11 = containers.Map(MAP_KE, MAP_VALU);

%%%%%%%%%%%%% Do the Locomotion %%%%%%%%%%%%%%%%%%

if MAKETEXTFILE
        %output to printfile
    fidp=fopen(char(printMSHEname),'w');
    K = keys(MAP_statMSHE);
    i=1;
    for k = K
        seldat = MAP_statMSHE(char(k));
        useobs = 1;
        filenm = [dfs0MSHEdir seldat.filename{:}];
        if (strcmp(seldat.filename{:}, 'none'))
            useobs = 0;
            filenm = 'none';
        end
        if(regexp(char(k),'dpth'))
            filenm = [dfs0MSHEdpthdir  seldat.filename{:}];
        end
        fprintf(fidp, '%s\t%d\t1\t%8.1f\t%8.1f\t0\t%d\t%s\t1\n', char(k),seldat.code{:},seldat.utmx{:},seldat.utmy{:},useobs,filenm);
        i=i+1;
    end
    fclose(fidp);

    %output to printfile
    fidp=fopen(char(printM11name),'w');
    K = keys(MAP_statM11);
    i=1;
    for k = K
        seldat = MAP_statM11(char(k));
        useobs = 1;
        filenm = [dfs0M11dir seldat.filename11{:}];
        if (strcmp(seldat.filename11{:}, 'none'))
            useobs = 0;
            filenm = 'none';
        end
        fprintf(fidp, '%s\t%d\t%s\t%8.2f\t%d\t%s\t1\n', char(k),seldat.type{:},seldat.branch{:},seldat.chain{:},useobs,filenm);
        i=i+1;
    end
    fclose(fidp);
end

MAP_ALL.MSHE = MAP_statMSHE;
MAP_ALL.M11 = MAP_statM11;

end

