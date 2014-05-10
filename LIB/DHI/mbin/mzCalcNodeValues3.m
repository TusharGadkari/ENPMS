function [Zn,NtoE,Xe,Ye] = mzCalcNodeValues3(Elmts,Xn,Yn,Ze,Xe,Ye,NtoE)
%MZCALCNODEVALUES Calculate node values from element center values
%
%   Calculate node values from element center values. Based on a Pseudo
%   Laplace procedure by [Holmes, Connell 1989]. Uses an inverse distance
%   average if the pseudo laplace procedure fails. 
%
%   Usage:
%       [Zn]            = mzCalcNodeValues(Elmts,Xn,Yn,Ze)
%       [Zn,NtoE]       = mzCalcNodeValues(Elmts,Xn,Yn,Ze,Xe,Ye,NtoE)
%       [Zn,NtoE,Xe,Ye] = mzCalcNodeValues(Elmts,Xn,Yn,Ze,Xe,Ye,NtoE)
%
%   Input:
%           Elmts  : Element table
%           Xn     : node x coordinates           (nnodes x 1)
%           Yn     : node y coordinates           (nnodes x 1)
%           Ze     : element center value         (nelements x 1)
%           Xe     : element center x coordinates (nelements x 1)
%           Ye     : element center y coordinates (nelements x 1)
%           NtoE   : NodeToElmt table             (nnodes x ?)
%
%   Output:
%           Zn     : reconstructed z value at nodes (Xn,Yn)
%           NtoE   : NodeToElmt table (to be reused).
%           Xe     : element center x coordinates (to be reused)
%           Ye     : element center y coordinates (to be reused)
%
%   The NtoE table describes for each node which element is adjacent to
%   this node. May contain padded zeroes. See TRITABLES for details.
%
%   If element center coordinates Xe, Ye and NtoE are not given, 
%   or given as [], they will be calculated. They are returned for 
%   later use. 
%
%   Holmes, D. G. and Connell, S. D. (1989), Solution of the
%       2D Navier-Stokes on unstructured adaptive grids, AIAA Pap.
%       89-1932 in Proc. AIAA 9th CFD Conference.
%
%   See also TRITABLES MZCALCNODEVALUEPL

% Copyright, DHI, 2007-11-09. Author: JGR

if (nargin < 6 || (nargin >= 6 && (numel(Xe) == 0 || numel(Ye) == 0 )))
  % Find all the quads
  if (size(Elmts,2) == 3)
    hasquads = false;
    quads    = false(size(Elmts,1),1);
  else
    hasquads = true;
    quads    = Elmts(:,4) > 0;
  end
  % calculate element center coordinates
  Xe = sum(Xn(Elmts(:,1:3)),2);
  Ye = sum(Yn(Elmts(:,1:3)),2);
  if (hasquads)
    Xe(quads) = Xe(quads) + Xn(Elmts(quads,4));
    Ye(quads) = Ye(quads) + Yn(Elmts(quads,4));
  end
  Xe = Xe./(3+quads);
  Ye = Ye./(3+quads);
end

if (nargin < 7 || (nargin >= 7 && numel(NtoE) == 0))
  NtoE = tritables(Elmts);
end

Zn = zeros(size(Xn));



nelmts = size(NtoE,2);

Rx   = zeros(size(Zn));
Ry   = zeros(size(Zn));
Ixx  = zeros(size(Zn));
Iyy  = zeros(size(Zn));
Ixy  = zeros(size(Zn));
for i = 1:nelmts
  id = NtoE(:,i);
  I = (id ~= 0);
  id = id(I);
  
  dx  = Xe(id) - Xn(I);
  dy  = Xe(id) - Yn(I);
  Rx(I)  = Rx(I)  + dx;
  Ry(I)  = Ry(I)  + dy;
  Ixx(I) = Ixx(I) + dx*dx;
  Iyy(I) = Iyy(I) + dy*dy;
  Ixy(I) = Ixy(I) + dx*dy;
end
lamda   = Ixx.*Iyy - Ixy.*Ixy;

J = (abs(lamda) > 1.0d-10*(Ixx*Iyy));

if (abs(lamda) > 1.0d-10*(Ixx*Iyy))
  lamda_x = (Ixy*Ry - Iyy*Rx)/lamda;
  lamda_y = (Ixy*Rx - Ixx*Ry)/lamda;

  omega_sum = zeros(size(Zn));
  zz = zeros(size(Zn));
  for i = 1:nelmts
    id = NodeToElmt(J,i);
    I = (id ~= 0);
    id = id(I);

    omega     = 1.0 + lamda_x*(xe(id)-xn(:)) + lamda_y*(ye(id)-yn(:));
    % Clipping
    omega(omega<0) = 0;
    omega(omega>2) = 2;
    omega_sum(J) = omega_sum(J) + omega(J);
    zz(J) = zz + omega*ze(id);
  end
  
  if (abs(omega_sum) > 1.0d-10)
      zz  = zz/omega_sum;
  else
    omega_sum = 0.0d0;
  end
else
  omega_sum = 0.0d0;
end

% We did not succeed using pseudo laplace procedure, 
% use inverse distance instead
if (omega_sum == 0.0d0)
  %disp('Pseudo-Laplace failed - using inverse distance average');
  zz = 0.0d0;
  for i = 1:nelmts
    id = NodeToElmt(nn,i);
    if (id==0)
      continue;
    end
    dx  = xe(id) - xn(nn);
    dy  = ye(id) - yn(nn);

    omega     = 1.0d0/sqrt(dx*dx+dy*dy);
    omega_sum = omega_sum + omega;
    zz = zz + omega*ze(id);
  end   
  if (omega_sum ~= 0.0d0)
    zz = zz/omega_sum;
  else 
    zz = 0.0d0;
  end
end
