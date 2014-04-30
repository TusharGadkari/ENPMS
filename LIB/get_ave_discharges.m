function [Q] = get_ave_discharges(d,x)
%get_ave_discharges() Computes yearly and monthly averages of timeseries
%and yearly and monthly totals
%   Takes arguments: d - datevector, x - datavector

[y,m] = datevec(d);
Q.xm = NaN(12,1); % Monthly average
for i = 1:12
    Q.xm(i) = nanmean(x(m == i));
    Q.xm(i) = nansum(x(m == i));
end
yy = unique(y); % Years
ny = length(yy)
Q.xy = NaN(ny,1); % Annual average array
for i = 1:ny
    Q.xy(i) = nansum(x(y == yy(i)));
    Q.xy(i) = nanmean(x(y == yy(i)))
end
Q.xym = NaN(ny,12);
for i = 1:ny
    for j = 1:12
        Q.xym(i,j) = nanmean(x((y == yy(i)) & (m == j))); %yr and mo ave
        Q.xym(i,j) = nansum(x((y == yy(i)) & (m == j))); %yr and mo ave
    end
end

end

