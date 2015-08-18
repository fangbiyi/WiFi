function [Dout] = DTW_distfun(XI,XJ)
% Writing this for matlab PDIST, can use distPairwise.m in ML toolbox by JANG
% A distance function specified using @:
% D = pdist(X,@distfun)
% A distance function must be of form
% d2 = distfun(XI,XJ)
% taking as arguments a 1-by-n vector XI, corresponding to a single row of X,
% and an m2-by-n matrix XJ, corresponding to multiple rows of X. distfun must
% accept a matrix XJ with an arbitrary number of rows. distfun must return an
% m2-by-1 vector of distances d2, whose kth element is the distance between XI and XJ(k,:).

% DTW optimization parameters
DTW_OPT = struct;
DTW_OPT.type = 1;
DTW_OPT.endCorner = 1;
DTW_OPT.beginCorner = 1;
DTW_OPT.distanceBound = inf;

LJ = size(XJ,1); % considering arbitrary number of rows
L = size(XI,2); % 1xn XI, m2xn XJ
no_DWT = 5; % repetetive DTW
Dout = [];
% Take DWT of XI here.
TEMP1 = XI;
% TEMP1 = VarianceVector(XI',5)';
for l = 1:no_DWT
    [TEMP1, ~] = dwt(TEMP1, 'db4');
end

for k = 1:LJ
    % Take DWT of DTW here.
    TEMP2 = XJ(k,:);
%     TEMP2 = VarianceVector(XJ(k,:)',5)';
    for l = 1:no_DWT
        [TEMP2, ~] = dwt(TEMP2, 'db4'); % Did not replace XJ in dwt(XJ(k,:), 'db4') with TEMP2, so previously only one DWT was happening
    end
    [minDist1, ~, ~]=dtw(TEMP1, TEMP2,DTW_OPT);
    [minDist2, ~, ~]=dtw(TEMP1, -TEMP2,DTW_OPT);
    % Incrementing the output
    Dout = [Dout min(minDist1,minDist2)];
%       Dout = [Dout minDist1];
end
Dout = Dout';
end