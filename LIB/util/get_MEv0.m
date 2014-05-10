function [V] = get_MEv0 (TS)
if isempty(TS), V = NaN; return, end;

V = sum(TS(:,4))/length(TS(:,1)); %ok

end
