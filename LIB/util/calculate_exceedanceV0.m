function [TS TS_HEADER] = calculate_exceedanceV0 (TS)

D = length(TS(:,1))+1;
SORT_COMP = sort(TS(:,2),1,'descend');
SORT_OBS = sort(TS(:,3),1,'descend');
SORT_DIFF = sort(TS(:,4),1,'descend');
RANK = 1:D-1; 
RANK = RANK';
P_COMP = RANK/D;
P_OBS = P_COMP;
P_DIFF = P_COMP;
TS(:,5)=SORT_COMP; 
TS(:,6)=SORT_OBS; 
TS(:,7)=SORT_DIFF; 
TS(:,8)=P_COMP; 

TS_HEADER = {'Time','Computed TS','Observed TS','Difference TS','Computed Descending',...
    'Observed Descending', 'Difference Descending', 'Probability'};

end
