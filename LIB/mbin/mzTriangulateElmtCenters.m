function t = mzTriangulateElmtCenters(x,y,EtoN)
%MZTRIANGULATEELMTCENTERS Triangulate element centers.
%
%   Triangulate (using delaunay) element centers, removing elements from
%   triangulation when the original elements does not share a node.
%
%   Usage:
%      t = mzTriangulateElmtCenters(x,y,EtoN)
%
%   Input:
%      x     : element center x coordinates.
%      y     : element center y coordinates.
%      EtoN  : triangulation matrix of elements.
%
%   Output:
%      t     : A triangulation matrix for the mesh using element centers as
%              nodes

% Copyright, DHI, 2007-11-09. Author: JGR

% triangulate element centers
t = delaunay(x,y);

% Create connectivity tables.
[NtoE,EtoE,B] = tritables(EtoN);
A  = double(B~=0);
EN = A*A';

ok = true(size(t,1),1);

% Safe but slightly slow version (though usually faster than delaunay)
for i = 1:size(t,1)
  for j = 1:3
    e1 = t(i,j);
    e2 = t(i,mod(j,3)+1);
    if (~EN(e1,e2))
      ok(i) = false;
      break;
    end
  end
end

t = t(ok,:);

