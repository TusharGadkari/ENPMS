function [V] = get_COVARv0(TS,COUNT)
if isempty(TS), V = NaN; return, end;
MEAN_OBS = mean(TS(:,3));
MEAN_COMP = mean(TS(:,2));
V = sum(dot(TS(:,3)- MEAN_OBS,TS(:,2)- MEAN_COMP))/COUNT; % covar
% to use Matlab's function use, diag(cov(x,y),1)
end
