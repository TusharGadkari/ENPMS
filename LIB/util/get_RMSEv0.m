function [V] = get_RMSEv0(TS)
if isempty(TS), V = NaN; return, end;

V = (sum(TS(:,4).^2)^0.5)/length(TS(:,1)); %revised

end
