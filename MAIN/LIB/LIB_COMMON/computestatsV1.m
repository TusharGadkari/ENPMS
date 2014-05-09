function [ST] = computestatsV1(yobs,yest)

        %Number of points before
    ST.ALLpoints = length(yobs);
        %remove dates that have observed NaN
    I=isnan(yobs);
    yobs(I)=[];
    yest(I)=[];
        %remove dates that have model NaN (e.g., shorter runs)
    II=isnan(yest);
    yobs(II)=[];
    yest(II)=[];

        %Nash Sutcliffe
    SSE=sum((yobs-yest).^2);
    u=mean(yobs);
    SSU=sum((yobs-u).^2);
    ST.NS = 1-SSE/SSU;

        %This is the standard error SE
    ST.RMSE=sqrt(sum((yobs-yest).^2)/(length(yobs)-1));
    
        %Bias is sum of average residual
    ST.BIAS = sum(yobs-yest)/length(yobs);
    
        %Number of points as NaN
    ST.NANpoints = ST.ALLpoints - length(yobs);
end
