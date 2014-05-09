function setSpatialDef(dm,proj,varargin)
%SETSPATIALDEF Sets the spatial definition for dfs file.
%
%   Usage dfsu
%     setSpatialDef(dfs,proj,Elmts,Nodes)              % 2D
%     setSpatialDef(dfs,proj,Elmts,Nodes,nlayers)      % 3D from 3D
%     setSpatialDef(dfs,proj,Elmts,Nodes,layers,s)     % 3D from 2D
%
%   Usage dfs1+2+3
%     setSpatialDef(dfs,proj,geoorigin,orientation,spatialdef)
%
%   inputs:
%     dfs       : DFS object.
%     proj      : projection string
%
%   dfsu inputs:
%     Elmts     : Element table. It can be a 2D table as returned by a mesh
%                 file, or a full 3D table from another 3D dfsu file.
%     Nodes     : Node coordinates and code. It can be 2D as returned by a
%                 mesh file, or a full set of 3D nodes from a 3D dfsu file.
%     nlayers   : When Elmt-Node input is 3D, the number of layers is
%                 required.
%     layers    : When Elmt-Node input is 2D, a vector of relative layers 
%                 thickness, the number of elements in layers becomes the
%                 number layers, and the vector must sum to one. Bottom
%                 layer is first.
%     s         : For a 3D file with 2D Elmt-Node input, surface elevation
%                 at node coordinates, or constant surface elevation. If
%                 not given, s=0 is used. Column vector.
%
%   dfs1+2+3 inputs:
%     geoorigin : Geographical origin (lon,lat) coordinates of local 
%                 spatial axis origin (0,0).
%     orientation: Orientation in degrees, clockwise angle from true north
%                 at (0,0) in local spatial axis.
%     regulardef: Regular spatial definition, 3 columns per dimension
%                 specifying [spatial_origin, spacing, number_points].
%                 Spacing is in meters.
%
%   dfs1+2+3 example:
%     setSpatialDef(dfs,'UTM-33',[12,54],2.6,[0,100,11;0,200,6]);
%     

% Copyright, DHI 2006
% Version 0.4, 2007-11-21. Author: JGR

% dfsu2+3D
if (dm.filetype >= dm.FILETYPE_DFSU)
  if (nargin < 4 || (nargin < 5 && dm.numdims == 3))
     error(id('NotEnoughInputs'),'Not enough input arguments');
  end
  Elmts   = varargin{1};
  Nodes   = varargin{2};
  nlayers = 0;
  if (dm.numdims == 3)
    if (numel(varargin) < 4)
      s = 0;
    else
      s = varargin{4};
      s = s(:);
    end
    % 2D input, create 3D Nodes and Elmts
    if (size(Elmts,2) < 6)
      % 
      layers   = [0 cumsum(varargin{3})];
      nlayers  = numel(layers)-1;
      % Create stacked node coordinates
      X        = Nodes(:,1)';
      Y        = Nodes(:,2)';
      Z        = Nodes(:,3)';
      Code     = Nodes(:,4)';
      X_3D     = repmat(X,nlayers+1,1);
      Y_3D     = repmat(Y,nlayers+1,1);
      Z_3D     = repmat(Z,nlayers+1,1);
      Code_3D  = repmat(Code,nlayers+1,1);
      % find total water depth h
      h        = s - Z;
      h(h<0)   = 0;
      for i = 1:nlayers+1
        Z_3D(i,:) = Z + layers(i)*h;
      end
      Nodes_3D = [X_3D(:) Y_3D(:) Z_3D(:) Code_3D(:)];
      % Create stacked element table
      Elmts_3D = zeros(size(Elmts).*[nlayers 2]);
      for i = 1:size(Elmts,1)
        elmt = Elmts(i,:);
        elmt(elmt==0) = [];
        elmt_3D_bot = (elmt-1)*(nlayers+1);
        nnodes = 2*length(elmt);
        for j = 1:nlayers
          elmt_3D = [elmt_3D_bot+j , elmt_3D_bot+j+1];
          iel_3D  = (i-1)*nlayers+j;
          Elmts_3D(iel_3D,1:nnodes) = elmt_3D;
        end
      end
      Elmts = Elmts_3D;
      Nodes = Nodes_3D;
    else
      nlayers = varargin{3};
    end
  end

  calllib('DFSManLib','DMSetSpatialDefFEM',dm.fileid,proj,Elmts,[(1:size(Nodes,1))',Nodes],dm.numdims,nlayers);

% dfs0+1+2+3
else
  if (nargin < 5)
    error(id('NotEnoughInputs'),'Not enough input arguments');
  end
  geoorigin   = varargin{1};
  orientation = varargin{2};
  regulardef  = varargin{3};

  calllib('DFSManLib','DMSetSpatialDefReg',dm.fileid,proj,geoorigin,orientation,dm.numdims,regulardef);

end
  

function str = id(str)
str = ['dfsManager:setSpatialDef:' str];
