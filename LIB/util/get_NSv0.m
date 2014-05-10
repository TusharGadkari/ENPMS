function [V] = get_NSv0(TS)
if isempty(TS), V = NaN; return, end;

MEAN_OBS = mean(TS(:,3));
V = 1 - sum(TS(:,4).^2)/sum((TS(:,3)-MEAN_OBS).^2); % ok

end
