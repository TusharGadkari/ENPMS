% This code obtained from Marcelo Lago, DHI, April 2011
%
% get flow among grid cells in dfs2/dfs3 file
% input parameters:
% sFdfs: dfs2/dfs3 file name
% itemFx,itemFy: items numbers containing the flow in x and y direction, respectively
% kz: vertical layer in dfs3 file. kz= 0 is the bottom layer. kz=nz (toplayer) by default if kz value is outside the range
% KX1,KY1,KX2,KY2: index of start-end grid cells for reading flow 1->2
% nK: length(KX1)
% kT1: first time step
% kT2: last time step (if kT2<kT1 => kT2=nT)

% output parameters
% F12: 2D arraw for the flow from 1 to 2 with dimension nT,nK. 
% nT: number of time steps read from the dfs2/dfs3 
% Created by mla@dhi.us on july 24,2010.

function [F12,nT]= get_flow_at_faces_dfs(sFNdfs,itemFx,itemFy,kz,KX1,KY1,KX2,KY2,nK,kT1,kT2)

 okFx= (KY1==KY2); % is flow in x direction?
 
 % find file type dfs2 or dfs3
 ns= length(sFNdfs);
 okdfs2= strcmp(sFNdfs(ns-4:ns),'.dfs2');
 if ~okdfs2
  okdfs2= ~strcmp(sFNdfs(ns-4:ns),'.dfs3');
  if okdfs2
   disp('Error: file name not understood.');
   disp(sFNdfs);
   pause
  end
 end
 
 % Assign dfs2/dfs3
 dfs = dfsManager(sFNdfs);
 items= get(dfs,'items');
 dfsp= get(dfs) % get properties
 if okdfs2
  disp(sprintf('dfs2 Grid dimension (ny,nx)= (%d,%d) ',dfsp.GridSize));
 else
  disp(sprintf('dfs3 Grid dimension (ny,nx,nz)= (%d,%d,%d) ',dfsp.GridSize));
  nz= dfsp.GridSize(3);
  if kz<0 || kz>nz
   kz= nz; % top layer by default
  end
 end
 %pause
 dv= dfsp.DeleteValue;
 nT= dfsp.NumtimeSteps; % number of stress periods in dfs2/dfs3
 if (kT2<kT1) || (kT2<1) || (kT2>nT)
  kT2= nT;
 end
 if (kT1<1) || (kT1>nT)
  kT1= 1;
 end
 nT= kT2-kT1+1; % number of time steps to read

 disp(sprintf('Flow in X dir: %s, %s, %s',items{itemFx,1},items{itemFx,2},items{itemFx,3}));
 disp(sprintf('Flow in X dir: %s, %s, %s',items{itemFy,1},items{itemFy,2},items{itemFy,3}));
 
 F12= zeros(nT,nK); % initialize
 for kT= 1:nT
  Fx= readItemTimestep(dfs,itemFx,kT1-1+kT-1);
  Fy= readItemTimestep(dfs,itemFy,kT1-1+kT-1);
  if ~okdfs2
   % convert to 2D array for layer kz in dfs3
   Fx= Fx(:,:,kz+1); 
   Fy= Fy(:,:,kz+1); 
  end
  %if kT==nT
  % Fx
  % Fy
  %end
  for k= 1:nK
   %if kT==nT
   % disp(sprintf('Flow from cell (%d,%d) to cell (%d,%d) ...',KX1(k),KY1(k),KX2(k),KY2(k)));
   %end
   if okFx(k)
    if KX1(k)<KX2(k)
     fk= Fx(KY1(k),KX1(k));
     s= 1; % sign
    else %if KX1(k)>KX2(k)
     fk= Fx(KY2(k),KX2(k));
     s= -1; % sign
    end
    %if kT==nT
    % disp(sprintf('In X direction with flow = %d * %f.',s,fk)); pause;
    %end
   else %if ~okFx(k)
    if KY1(k)<KY2(k)
     fk= Fy(KY1(k),KX1(k));
     s= 1; % sign
    else %if KY1(k)>KY2(k)
     fk= Fy(KY2(k),KX2(k));
     s= -1; % sign
    end
    %if kT==nT
    % disp(sprintf('In Y direction with flow = %d * %f.',s,fk)); pause;
    %end
   end
   if (fk==dv)
    F12(kT,k)= nan;
   else
    F12(kT,k)= s*fk;
   end
  end
 end
 close(dfs);
end