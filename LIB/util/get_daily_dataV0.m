function [D_TIME_VEC] = get_daily_dataV0(D, TIME_VECTOR_NONEQ,TIME_VECTOR)
% this function provides dayly data when the timestep is varying and
% smaller than daily. it takes the last daily value, may be it should take
% the average
sz = length(TIME_VECTOR);
sz_neq = length(TIME_VECTOR_NONEQ);

D_TIME_VEC(1:sz) = NaN;
k = 0;
DLAST = datenum([0 0 0 0 0 0]);

for i = 1:sz_neq
    DNUM = floor(datenum(TIME_VECTOR_NONEQ(i,:)));
    if (DNUM > DLAST) 
        k = k + 1;
        D_TIME_VEC(k) = D(i);
        DLAST = datenum(TIME_VECTOR_NONEQ(i,:));
    end
end
D_TIME_VEC = D_TIME_VEC';
end
