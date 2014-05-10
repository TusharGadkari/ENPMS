function [V] = get_PEVv0(TS,COUNT)
if isempty(TS), V = NaN; return, end;
MEAN_OBS = mean(TS(:,3));
MEAN_COMP = mean(TS(:,2));

V = 1-sum((TS(:,4)-sum(TS(:,4))/COUNT).^2)/sum((TS(:,3)-MEAN_OBS).^2); %
%V = 100*(1-sum((TS(:,4)-sum(TS(:,4))/COUNT).^2)/sum((TS(:,3)-MEAN_OBS).^2))
end

