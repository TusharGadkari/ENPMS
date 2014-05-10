function [V] = get_CORv0(TS)
if isempty(TS), V = NaN; return, end;
MEAN_OBS = mean(TS(:,3));
MEAN_COMP = mean(TS(:,2));

N=sum(dot(TS(:,3)-MEAN_OBS,TS(:,2)-MEAN_COMP));

D=dot(sum((TS(:,3)-MEAN_OBS).^2),sum((TS(:,2)-MEAN_COMP).^2))^0.5; %

V = N/D;
% to use Matlab's function use, diag(corrcoef(x,y),1)
end
