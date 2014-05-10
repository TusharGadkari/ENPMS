%------------------------------------------
function [TimeseriesData]= get_dfs23_timeseries_v0(MyDfsFile,MyRequestedItems,kT1,kT2)

NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;

[nK,trash] = size(MyRequestedItems); % number of locations to extract data for

dv = MyDfsFile.FileInfo.DeleteValueFloat;
nT = MyDfsFile.FileInfo.TimeAxis.NumberOfTimeSteps;
dim = MyDfsFile.SpatialAxis.Dimension;

if dim < 2 || dim > 3
   fprintf('\nERROR in get_dfs23_timeseries - dimension of dfs file not 2 or 3: %s\n', char(dfs.FileInfo.FileName));
   return;
end

% revise requested timesteps if either is out of bounds
if (kT2<kT1) || (kT2<1) || (kT2>nT)
   kT2= nT;
   nT= kT2-kT1+1; % number of time steps to read
end
if (kT1<1) || (kT1>nT)
   kT1= 1;
   nT= kT2-kT1+1; % number of time steps to read
end

TimeseriesData= zeros(nT,nK); % initialize

% create vectors of cell coordinates
Rows  = MyRequestedItems(:,1);
Cols  = MyRequestedItems(:,2);
Lays  = MyRequestedItems(:,3);

% create vector of item numbers
ItemNums=MyRequestedItems(:,4);

% revise requested vertical layer if it is out of bounds
%if dim == 3
%   nz = MyDfsFile.SpatialAxis.ZCount; % number of vert layers in dfs file
%   if Lays<1 || Lays>nz
%      Lays=nz; % top layer by default
%   end
%end

for kT= 1:nT
   if dim == 2
      for k= 1:nK
         Fx= double(MyDfsFile.ReadItemTimeStep(ItemNums{k},kT1-1+kT-1).To2DArray());
         fk= Fx(Cols{k},Rows{k});
         if (fk==dv)
            TimeseriesData(kT,k)= nan;
         else
            TimeseriesData(kT,k)= fk;
         end
      end
   end
   if dim == 3
      for k= 1:nK
         Fx= double(MyDfsFile.ReadItemTimeStep(ItemNums{k},kT1-1+kT-1).To3DArray());
         fk= Fx(Cols{k},Rows{k},Lays{k});
         if (fk==dv)
            TimeseriesData(kT,k)= nan;
         else
            TimeseriesData(kT,k)= fk;
         end
      end
   end
  
end
   
end