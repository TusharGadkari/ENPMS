function [ MAP_ALL_DATA ] = combine_observed_timeseries_v0(MAP_ALL_DATA,obs_index)

% 2011-10-07 keb - added some ';'s

% define a blank container structure for initializing
BLANK_STRUCTURE.NAME       = '';
BLANK_STRUCTURE.DATATYPE   = '';
BLANK_STRUCTURE.DFSTYPE    = '';
BLANK_STRUCTURE.UNIT       = '';
BLANK_STRUCTURE.X_UTM      = NaN;
BLANK_STRUCTURE.Y_UTM      = NaN;
BLANK_STRUCTURE.Z          = NaN;
BLANK_STRUCTURE.Z_GRID     = NaN;
BLANK_STRUCTURE.Z_SURF     = NaN;
BLANK_STRUCTURE.TIMESERIES = NaN;
BLANK_STRUCTURE.TIMEVECTOR = NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TSB transect

mykey = 'xsect_TSB_Q';
copykey = 'TSB_Q';

%initialize
NEW_STRUCTURE = BLANK_STRUCTURE;
NEW_STRUCTURE.NAME = mykey;

try
	% attempt to access and sum up component timeseries
	NEW_STRUCTURE.TIMESERIES(:,obs_index) = ...
	MAP_ALL_DATA(char('TSB_Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_8')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_9')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_10')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_11')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_12')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_13')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_14')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_15')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_16')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_17')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_18')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('TSB_culvert_19')).TIMESERIES(:,obs_index) ;
	
  % if xsect exists copy model data to new variable and delete old one
  if isKey(MAP_ALL_DATA,mykey)
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(mykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(mykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(mykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(mykey).UNIT;
     NEW_STRUCTURE.TIMESERIES(:,1) = MAP_ALL_DATA(mykey).TIMESERIES(:,1);
     remove(MAP_ALL_DATA,mykey);
     
  % otherwise copy datatype,unit and time vector from one component
  else
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(copykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(copykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(copykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(copykey).UNIT;
  end

  MAP_ALL_DATA(mykey) = NEW_STRUCTURE;

catch
   fprintf('\nWARNING - problem calculating obs group: %s  - skipped',mykey);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TT-NESS transect

mykey = 'xsect_TTNESS_Q';
copykey = 'culvert_41';

%initialize
NEW_STRUCTURE = BLANK_STRUCTURE;
NEW_STRUCTURE.NAME = mykey;

try
	% attempt to access and sum up component timeseries
	NEW_STRUCTURE.TIMESERIES(:,obs_index) = ...
	MAP_ALL_DATA(char('culvert_41')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_42')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_43')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_44')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_45')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_46')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_47')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_48')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_49')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_50')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_51')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_52')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_53')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_54')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_55')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_56')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_57')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_58')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_59')).TIMESERIES(:,obs_index) ;
	
  % if xsect exists copy model data to new variable and delete old one
  if isKey(MAP_ALL_DATA,mykey)
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(mykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(mykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(mykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(mykey).UNIT;
     NEW_STRUCTURE.TIMESERIES(:,1) = MAP_ALL_DATA(mykey).TIMESERIES(:,1);
     remove(MAP_ALL_DATA,mykey);
     
  % otherwise copy datatype,unit and time vector from one component
  else
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(copykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(copykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(copykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(copykey).UNIT;
  end

  MAP_ALL_DATA(mykey) = NEW_STRUCTURE;

catch
   fprintf('\nWARNING - problem calculating obs group: %s  - skipped',mykey);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TT-S12s transect

mykey = 'xsect_TTS12s_Q';
copykey = 'S12A_Q';

%initialize
NEW_STRUCTURE = BLANK_STRUCTURE;
NEW_STRUCTURE.NAME = mykey;

try
	% attempt to access and sum up component timeseries
	NEW_STRUCTURE.TIMESERIES(:,obs_index) = ...
	MAP_ALL_DATA(char('S12A_Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('S12B_Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('S12C_Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('S12D_Q')).TIMESERIES(:,obs_index) ;
	
  % if xsect exists copy model data to new variable and delete old one
  if isKey(MAP_ALL_DATA,mykey)
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(mykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(mykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(mykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(mykey).UNIT;
     NEW_STRUCTURE.TIMESERIES(:,1) = MAP_ALL_DATA(mykey).TIMESERIES(:,1);
     remove(MAP_ALL_DATA,mykey);
     
  % otherwise copy datatype,unit and time vector from one component
  else
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(copykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(copykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(copykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(copykey).UNIT;
  end

  MAP_ALL_DATA(mykey) = NEW_STRUCTURE;

catch
   fprintf('\nWARNING - problem calculating obs group: %s  - skipped',mykey);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S343 transect

mykey = 'xsect_S343s_Q';
copykey = 'culvert_24Q';

%initialize
NEW_STRUCTURE = BLANK_STRUCTURE;
NEW_STRUCTURE.NAME = mykey;

try
	% attempt to access and sum up component timeseries
	NEW_STRUCTURE.TIMESERIES(:,obs_index) = ...
	MAP_ALL_DATA(char('culvert_24Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_25Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_26Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_27Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_28Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('S343A_Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('S343B_Q')).TIMESERIES(:,obs_index) ;
	
  % if xsect exists copy model data to new variable and delete old one
  if isKey(MAP_ALL_DATA,mykey)
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(mykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(mykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(mykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(mykey).UNIT;
     NEW_STRUCTURE.TIMESERIES(:,1) = MAP_ALL_DATA(mykey).TIMESERIES(:,1);
     remove(MAP_ALL_DATA,mykey);
     
  % otherwise copy datatype,unit and time vector from one component
  else
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(copykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(copykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(copykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(copykey).UNIT;
  end

  MAP_ALL_DATA(mykey) = NEW_STRUCTURE;

catch
   fprintf('\nWARNING - problem calculating obs group: %s  - skipped',mykey);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S343 transect - only S343A and B

mykey = 'xsect_S343strucs_Q';
copykey = 'S343A_Q';

%initialize
NEW_STRUCTURE = BLANK_STRUCTURE;
NEW_STRUCTURE.NAME = mykey;

try
	% attempt to access and sum up component timeseries
	NEW_STRUCTURE.TIMESERIES(:,obs_index) = ...
	MAP_ALL_DATA(char('S343A_Q')).TIMESERIES(:,3) + ...
	MAP_ALL_DATA(char('S343B_Q')).TIMESERIES(:,3) ;
	
  % if xsect exists copy model data to new variable and delete old one
  if isKey(MAP_ALL_DATA,mykey)
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(mykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(mykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(mykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(mykey).UNIT;
     NEW_STRUCTURE.TIMESERIES(:,1) = MAP_ALL_DATA(mykey).TIMESERIES(:,1);
     remove(MAP_ALL_DATA,mykey);
     
  % otherwise copy datatype,unit and time vector from one component
  else
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(copykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(copykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(copykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(copykey).UNIT;
  end

  MAP_ALL_DATA(mykey) = NEW_STRUCTURE;

catch
   fprintf('\nWARNING - problem calculating obs group: %s  - skipped',mykey);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S343 transect - culverts only

mykey = 'xsect_S343culverts_Q';
copykey = 'culvert_24Q';

%initialize
NEW_STRUCTURE = BLANK_STRUCTURE;
NEW_STRUCTURE.NAME = mykey;

try
	% attempt to access and sum up component timeseries
	NEW_STRUCTURE.TIMESERIES(:,obs_index) = ...
	MAP_ALL_DATA(char('culvert_24Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_25Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_26Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_27Q')).TIMESERIES(:,obs_index) + ...
	MAP_ALL_DATA(char('culvert_28Q')).TIMESERIES(:,obs_index) ;
	
  % if xsect exists copy model data to new variable and delete old one
  if isKey(MAP_ALL_DATA,mykey)
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(mykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(mykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(mykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(mykey).UNIT;
     NEW_STRUCTURE.TIMESERIES(:,1) = MAP_ALL_DATA(mykey).TIMESERIES(:,1);
     remove(MAP_ALL_DATA,mykey);
     
  % otherwise copy datatype,unit and time vector from one component
  else
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(copykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(copykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(copykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(copykey).UNIT;
  end

  MAP_ALL_DATA(mykey) = NEW_STRUCTURE;

catch
   fprintf('\nWARNING - problem calculating obs group: %s  - skipped',mykey);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TSB head for testing

mykey = 'TSB_OL';
copykey = 'TSB';

%initialize
NEW_STRUCTURE = BLANK_STRUCTURE;
NEW_STRUCTURE.NAME = mykey;

try
	% attempt to access and sum up component timeseries
	NEW_STRUCTURE.TIMESERIES(:,obs_index) = ...
	MAP_ALL_DATA(char('TSB')).TIMESERIES(:,obs_index) ;
	
  % if xsect exists copy model data to new variable and delete old one
  if isKey(MAP_ALL_DATA,mykey)
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(mykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(mykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(mykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(mykey).UNIT;
     NEW_STRUCTURE.TIMESERIES(:,1) = MAP_ALL_DATA(mykey).TIMESERIES(:,1);
     remove(MAP_ALL_DATA,mykey);
     
  % otherwise copy datatype,unit and time vector from one component
  else
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(copykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(copykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(copykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(copykey).UNIT;
  end

  MAP_ALL_DATA(mykey) = NEW_STRUCTURE;

catch
   fprintf('\nWARNING - problem calculating obs group: %s  - skipped',mykey);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TSB head for testing

mykey = 'TSB_3dsz_h';
copykey = 'TSB';

%initialize
NEW_STRUCTURE = BLANK_STRUCTURE;
NEW_STRUCTURE.NAME = mykey;

try
	% attempt to access and sum up component timeseries
	NEW_STRUCTURE.TIMESERIES(:,obs_index) = ...
	MAP_ALL_DATA(char('TSB')).TIMESERIES(:,obs_index) ;
	
  % if xsect exists copy model data to new variable and delete old one
  if isKey(MAP_ALL_DATA,mykey)
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(mykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(mykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(mykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(mykey).UNIT;
     NEW_STRUCTURE.TIMESERIES(:,1) = MAP_ALL_DATA(mykey).TIMESERIES(:,1);
     remove(MAP_ALL_DATA,mykey);
     
  % otherwise copy datatype,unit and time vector from one component
  else
     NEW_STRUCTURE.TIMEVECTOR = MAP_ALL_DATA(copykey).TIMEVECTOR;
     NEW_STRUCTURE.DATATYPE   = MAP_ALL_DATA(copykey).DATATYPE;
     NEW_STRUCTURE.DFSTYPE    = MAP_ALL_DATA(copykey).DFSTYPE;
     NEW_STRUCTURE.UNIT       = MAP_ALL_DATA(copykey).UNIT;
  end

  MAP_ALL_DATA(mykey) = NEW_STRUCTURE;

catch
   fprintf('\nWARNING - problem calculating obs group: %s  - skipped',mykey);
end

end
