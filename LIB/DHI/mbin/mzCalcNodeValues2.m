function zz = calcNodeVal(xn,yn,zVal,xe,ye,n2e)

%   Calculate node values from element center values. Based on a Pseudo
%   Laplace procedure by [Holmes, Connell 1989].  
%   Holmes, D. G. and Connell, S. D. (1989), Solution of the
%       2D Navier-Stokes on unstructured adaptive grids, AIAA Pap.
%       89-1932 in Proc. AIAA 9th CFD Conference.
%
%   Input:
%           xn     : node x coordinates           (nnodes x 1)
%           yn     : node y coordinates           (nnodes x 1)
%           zVal   : element center value         (nelements x 1)
%           xe     : element center x coordinates (nelements x 1)
%           ye     : element center y coordinates (nelements x 1)
%           n2e    : NodeToElmt table             (nnodes x ?) which comes
%           from tritables.
%
%   Output:
%           Zn     : reconstructed z value at nodes (Xn,Yn)
% Jay Willis Turnpenny Horsfield Associates, with thanks to
% mzCalcNodeValues from DHI author JGR. This is FREEWARE, enjoy.
[~, c]=size(n2e);
t=find(n2e>0); % find indicies of nodes
dx = zeros(size(n2e));
dy = zeros(size(n2e));
dz = zeros(size(n2e));
dz(t) = zVal(n2e(t));

xnn = repmat(xn, 1, c);
ynn = repmat(yn, 1, c);
dx(t) = xe(n2e(t)) - xnn(t);
dy(t) = ye(n2e(t)) - ynn(t);
rx = sum(dx, 2);
ry = sum(dy, 2);
Ixx = sum(dx.*dx, 2);
Iyy = sum(dy.*dy, 2);
Ixy = sum(dy.*dx, 2);

lamda   = (Ixx.*Iyy) - (Ixy.*Ixy); 
sz = find(abs(lamda) > 1.0d-10.*(Ixx.*Iyy)); % safe from zeros
lamdaX = zeros(size(lamda));
lamdaY = zeros(size(lamda));
lamdaX(sz) = ((Ixy(sz).*ry(sz)) - (Iyy(sz).*rx(sz)))./lamda(sz);
lamdaY(sz) = ((Ixy(sz).*rx(sz)) - (Ixx(sz).*ry(sz)))./lamda(sz);

lamdaX = repmat(lamdaX, 1, c);
lamdaY = repmat(lamdaY, 1, c);
omega = zeros(size(n2e));
omega(sz) = 1.0 + (lamdaX(sz).*dx(sz)) + (lamdaY(sz).*dy(sz));

omega(omega<0)=0;
omega(omega>2)=2;

omegaSum = sum(omega, 2);
zz=zeros(size(xn));
zz(omegaSum>0) = sum(omega(omegaSum>0).*dz(omegaSum>0), 2)./omegaSum(omegaSum>0);


