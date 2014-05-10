function [V] = get_STDresV0(TS,ME)
if isempty(TS), V = NaN; return, end;

V = sum((TS(:,4)-ME).^2)^0.5/length(TS(:,1)); %revised
V = std(TS(:,4)-ME);
end
