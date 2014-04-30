function mzWriteMesh(filename,Elmts,Nodes,coordsys,force)
%MZwritemesh Writes MikeZero .mesh file.
%
%   Write a MikeZero .mesh file.
%
%   Usage:
%       mzWriteMesh(filename,Elmts,Nodes,coordsys)
%       mzWriteMesh(filename,Elmts,Nodes,coordsys,force)
%
%   Inputs:
%       Elmts    : Element-Node table, for each element list the node
%                  number, e.g., as returned by the delaunay function.
%       Nodes    : Node coordinates having 4 columns, [x, y, z, code]
%       filename : Name of file to write
%       coordsys : String containing coordinate system
%       force    : Force overwrite, if filename already exist
%
%   Note: 
%       Elements are automatically reordered to be counter clockwise.
%       Duplicate or near-duplicate nodes are not allowed.
%
%   See also MZREADMESH

%   Note that only two element types are supported (the only one used in
%   MikeZero GUI):
%       21: 2D triangular mesh
%       25: 2D mixed triangular quadrilateral mesh
%   The value is set based on the size of the Elmts input

% Copyright, DHI, 2007-11-09. Author: JGR

% Check arguments
if (nargin < 4)
  coordsys = 'NON-UTM';
  warning(id('noProjection'),...
    'No projection given. Writing %s to file',coordsys);
end
if (nargin < 5)
  force = 0;
end
if (size(Nodes,2) == 3)
  warning(id('noNodeCode'),...
    ['Nodes does not have a code value (for applying boundary condition).\n'...
    'Writing 0 as code for all nodes']);
  Nodes(1,4) = 0;
end

nnodes = size(Nodes,1);

%% Check that there are no duplicate nodes
nodeeps          = 1e-8;
nodetol          = nodeeps*max(max(abs(Nodes(:,1))),max(abs(Nodes(:,2))));
[NodesSorted, I] = sortrows(Nodes);
for i=1:nnodes-1
  j = i+1;
  while (j <= nnodes && abs(NodesSorted(i,1)-NodesSorted(j,1)) < nodetol)
    if (sum((NodesSorted(i,1:2)-NodesSorted(j,1:2)).^2) < nodetol*nodetol)
      error(id('duplicateNodes'),...
            ['There are duplicate nodes in the mesh.\n'...
             'Nodes %i and %i have same (x,y) coordinates'],I(i),I(j));
    end
    j = j+1;
  end
end

%% Check that all elements are counter clockwise
area = mzCalcElmtArea(Elmts,Nodes,0,1);
% Those with negative area are clockwise
I = (area < 0);
if (nnz(I) > 0)
  warning(id('autoReorderMesh'),...
    ['Automatic reordering nodes in elements to be counter clockwise\n'...
     '%i elements affected'],nnz(I));

  % Reorder elements to be counter-clockwise
  if (size(Elmts,2) == 3)
    % Only triangles
    Elmts(I,[2 3]) = Elmts(I,[3 2]);
  else
    % Mixed triangles and quads
    quads  = (Elmts(:,4) > 0);
    I3     = (I & ~quads);  % All clockwise triangles
    I4     = (I & quads );  % All clockwise quadrilaterals
    % Reverse node order to counter-clockwise
    Elmts(I3,[2 3]) = Elmts(I3,[3 2]);
    Elmts(I4,[2 4]) = Elmts(I4,[4 2]);
  end
end

%% Check for existing filename
if (~force && exist(filename,'file'))
  button = questdlg(sprintf('File %s exists!\nOverwrite?',filename),'File exists','Yes','Cancel','Cancel');
  if (strcmp(button,'Cancel'))
    return
  end
end

%% Open and write file
fid    = fopen(filename,'wt');
if (fid == -1)
  error(id('fileWriteAccessDenied'),...
        'File can not be opened for writing: %s\n',filename);
end

% Node and projection header line
fprintf(fid,'%i  %s\n',size(Nodes,1),coordsys);

% Node table
for i=1:size(Nodes,1)
  fprintf(fid,'%i %-17.15g %17.15g %17.15g %i\n',i,Nodes(i,1),Nodes(i,2),Nodes(i,3),Nodes(i,4));
end

% Only triangles
if (size(Elmts,2) == 3)
  % Element header line
  fprintf(fid,'%i %i %i\n',size(Elmts,1),3,21);
  % Element table
  for i=1:size(Elmts,1)
    fprintf(fid,'%i %i %i %i\n',i,Elmts(i,1:3));
  end

% Mixed triangles/quadrilaterals
else
  % Element header line - not sure about 25
  fprintf(fid,'%i %i %i\n',size(Elmts,1),4,25);
  % Element table
  for i=1:size(Elmts,1)
    fprintf(fid,'%i %i %i %i %i\n',i,Elmts(i,1:4));
  end
end

fclose(fid);


function str = id(str)
str = ['mzTool:mzWriteMesh:' str];
