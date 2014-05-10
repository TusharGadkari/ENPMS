function [data] = get_station_listV1(infile)
%this reads the selected_station_list text file

if (~exist('infile','var')),infile = 'selected_station_listV1.txt'; end
	% open file ------------------
fid = fopen(infile);
if fid==-1
  error('File not found or permission denied');
end

	% one header line
data.header = fgetl(fid);

i=1;
page=1;
stat=1;
while  (~feof(fid))
        %read a line
    tmp = fgetl(fid);
            %see if it is a new subsection
    if ~isempty(regexp(tmp,'subsection', 'once'))
        tmp1 = regexp(tmp, '\s+', 'split');
        subsect = tmp1{2};
            %what is the page number
    elseif ~isempty(regexp(tmp,'clearpage', 'once'))
        page=page+1;
            %the end of the file, not needed?
    elseif ~isempty(regexp(tmp,'END', 'once'))
        break;
            %must be a station name, set the array
    else

        data.list.stat{stat} = tmp;
        data.list.subsect{stat} = subsect;
        data.list.page{stat} = page;

        %try creating a container
        % this format seems to do it
        % 
        STAT_MAP{stat} = tmp;
        lst{stat}.subsect = subsect;
        lst{stat}.page = page;
        
        stat=stat+1;
    end

    i=i+1;
end

fclose(fid);

data.MAP = containers.Map(STAT_MAP, lst);


return;


for M = keys(data.MAP)
    M;
    values(data.MAP, {char(M)});
	list = data.MAP(char(M));
   %fprintf (1,'%s\t', values(data.MAP, {'NP205'}));
end


fprintf (1,'%s', data.header);
fprintf (1,'\n');
for x = 1:length(data.list.stat)
    fprintf (1,'%s\t%s\t%d', data.list.stat{x},data.list.subsect{x},data.list.page{x});
    fprintf (1,'\n');
end

end
