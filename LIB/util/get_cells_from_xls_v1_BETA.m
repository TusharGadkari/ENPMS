function [MyRequestedStnNames,MyRequestedStns] = get_cells_from_xls_v1_BETA(xlsdir,xlssheet,xlsfilename)
   
      xlsfile = [xlsdir xlsfilename];
      
      % read xls file
      if ~exist(xlsfile,'file')
        fprintf('MISSING: %s, exiting...', xlsfile);
        return
      end
      
      [~,~,xlsdata] = xlsread(xlsfile,xlssheet);
      [numrows,~] = size(xlsdata);
      
      if numrows > 1
         
         MyRequestedStnNames = xlsdata(2:numrows,1);
      
         Rows = xlsdata(2:numrows,2);
         Cols = xlsdata(2:numrows,3);
         Lays = xlsdata(2:numrows,4);
         Itms = xlsdata(2:numrows,5);
      
         MyRequestedStns = [Rows Cols Lays Itms];
         
      else
         MyRequestedStnNames = 0;
         MyRequestedStns = 0;
      end
         