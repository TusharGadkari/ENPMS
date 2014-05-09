function [Elmts2,Nodes2] = mzRefineMesh(Elmts,Nodes)
%MZREFINEMESH Refine triangulated mesh, put node at center of faces.
%
%   Refine triangulated mesh. A new node will be put on every face in the
%   triangulation. The new mesh will contain exactly 4 times as many
%   elements. Elements will be ordered counter-clockwise.
%
%   This does presently not work for mixed triangular/quadrilateral meshes.
%
%   Usage:
%       [Elmts,Nodes] = mzRefineMesh(Elmts,Nodes)
%
%   Outputs:
%       Elmts : Element-Node table, for each element list the node number,
%               e.g., as returned by the delaunay function.
%       Nodes : Node coordinates having 4 columns, [x, y, z, code]
%

% Copyright, DHI, 2007-11-09. Author: JGR

if (size(Elmts,2) > 3)
  error('mzTool:mzRefineMesh:NotTriangular',...
    ['mzRefineMesh only works for triangular meshes, not for mixed\n'...
     'triangular/quadrilateral meshes']);
end

% Find node-node connectivity
NNcon = sparse(size(Nodes,1),size(Nodes,1));
for i=1:size(Elmts,1)
  for j=1:3
    n1 = j;
    n2 = mod(j,3)+1;
    n = sort([Elmts(i,n1) Elmts(i,n2)]);
    NNcon(n(1),n(2)) = NNcon(n(1),n(2)) + 1;
  end
end

% Internal faces
[n1,n2] = find(NNcon==2);
Nodes2 = 0.5*[ Nodes(n1,1)+Nodes(n2,1) , ...
               Nodes(n1,2)+Nodes(n2,2) , ...
               Nodes(n1,3)+Nodes(n2,3) , ...
               0*Nodes(n1,4) ];
  
% Boundary faces
[n1,n2] = find(NNcon==1);
Nodes3 =     [ 0.5*(Nodes(n1,1)+Nodes(n2,1)) , ... 
               0.5*(Nodes(n1,2)+Nodes(n2,2)) , ...
               0.5*(Nodes(n1,3)+Nodes(n2,3)) , ...
               min(Nodes(n1,4),Nodes(n2,4)) ];

% Collect new nodes and triangulate
Nodes2 = [Nodes;Nodes2;Nodes3];
Elmts2 = delaunay(Nodes2(:,1),Nodes2(:,2));

% Reorder elements to be counter-clockwise
ab = Nodes2(Elmts2(:,2),:)-Nodes2(Elmts2(:,1),:);    % edge vector corner a to b
ac = Nodes2(Elmts2(:,3),:)-Nodes2(Elmts2(:,1),:);    % edge vector corner a to c
area2=ab(:,1).*ac(:,2)-ab(:,2).*ac(:,1);         % 2*Area (signed) of triangles
I = find(area2<0);
Elmts2(I,[2 3]) = Elmts2(I,[3 2]);
