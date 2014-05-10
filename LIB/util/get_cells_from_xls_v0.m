function [MyRequestedStnNames,MyRequestedStns] = get_cells_from_xls_v0(xlsdir,xlssheet,sheet_names)

   num_sheets = length(sheet_names);
   
   for i = 1:num_sheets
      mysheet = sheet_names{i};
      xlsfile = [xlsdir '\' mysheet '.xlsx'];
      
      % read xls file
      if ~exist(xlsfile,'file')
        fprintf('MISSING: %s, exiting...', xlsfile);
        return
      end
      
      [~,~,xlsdata] = xlsread(xlsfile,xlssheet);
      [numrows,~] = size(xlsdata);
      
      MyRequestedStnNames = xlsdata(2:numrows,1);
      
      Rows = xlsdata(2:numrows,2);
      Cols = xlsdata(2:numrows,3);
      Lays = xlsdata(2:numrows,4);
      Itms = xlsdata(2:numrows,5);
      
      MyRequestedStns = [Rows Cols Lays Itms];
   end
