function res11print_items_BETA(infile)
%RES11READ Extract time series data from res11 file.
%
%   Reads data from a .res11 file, extracting time series for specified
%   quantity, branch and chainage specifications
%
%   Usage: Setup extractPoints and call res11read, example here extracts
%          two water levels and one discharge time series
%
%     extractPoints{1}.branchName = 'VIDAA-NED';
%     extractPoints{1}.quantity = 'Water Level';
%     extractPoints{1}.chainages = [10000, 11300];
%     extractPoints{2}.branchName = 'VIDAA-NED';
%     extractPoints{2}.quantity = 'Discharge';
%     extractPoints{2}.chainages = 10128;
%     [values, outInfos] = res11read('filename.res11',extractPoints)
%
%   Inputs:
%     infile        : File name of res11 file
%     extractPoints : A specification of where to extract time series
%
%   Outputs:
%     vals     : Time series values at extract points
%     outInfos : Info of extracted time series quantities

% Copyright, DHI, 2010-08-20. Author: JGR
%

NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;

%% Open res11 file
res11File  = DfsFileFactory.DfsGenericOpen(infile);

%% Reading item info
itemInfos = {};
for ii = 1:res11File.ItemInfo.Count
    itemInfo = res11File.ItemInfo.Item(ii-1);
    % item name is on the form: Quantity, branchName chainagefrom-to
    % example: Water Level, VIDAA-NED 8775.000-10800.000
    itemName = char(itemInfo.Name);
    % Split on ', ' - seperates quantity and branch
    split = regexp(itemName,', ','split');
    itemQuantity = split{1};
    branch = split{2};
    try
       % Branch name and chainages are split on the last ' '
       I = find(branch == ' ');
       I1 = I(end);
       branchName = branch(1:I1-1);
       
       % Read spatial axis of item and extract chainages. 
       % The chainages values are grid point chainages. For Discharge items
       % these will not cover the entire branch chainage span.
       coords = itemInfo.SpatialAxis.Coordinates;
       chainages = zeros(coords.Length,1);
       for i=1:coords.Length
           % chainage is stored as X coordinate
           chainages(i) = coords(i).X;
       end
    catch
       branchName = 'none';
       chainages = -999.9;
    end

    % Print out item info
    fprintf('itemnum:	%d	itemName:	%s	\n',ii, itemName);
    %fprintf('itemnum:	%d	itemName:	%s chainage1: %d\n',ii, itemName, chainages(1));
    %fprintf('itemnum: %d,	branchName: %s,	itemQuantity: %s,	chainages: %d - %d\n',ii,branchName, itemQuantity, chainages(1), chainages(end));
    chainages'
    
end

% Print all itemInfos
for iitem = 1:numel(itemInfos);
   iitem;
   itemInfo = itemInfos{iitem};
   itemInfo.quantity;
   try itemInfo.branchName; end
   try itemInfo.chainages; end
    
end

res11File.Close();



