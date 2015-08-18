function [minVar] = VarBins(V1, V2, WIN)
% Outputs the vector with maximum number of greater variance bins as
% compared to the other vector.
ROW = size(V1,1);
COL = size(V1,2);
R_LEN = floor(ROW/WIN);
% TEMP1 = zeros(R_LEN,COL);
mV1 = 0;
mV2 = 0;
for i = 1:R_LEN
    if (i*WIN < ROW)
        x = V1(1 + (i-1)*WIN:WIN + (i-1)*WIN,:);
        y = V2(1 + (i-1)*WIN:WIN + (i-1)*WIN,:);
        Vx = var((x' - mean(x)'*ones(1,size(x,1)))');
        Vy = var((y' - mean(y)'*ones(1,size(y,1)))');
        if (Vx > Vy)
            mV1 = mV1 + 1;
        else
            mV2 = mV2 + 1;
        end
    end
end
[maxVarV, maxVarInd] = max([mV1 mV2]);
if maxVarInd == 1
    minVar = 2;
else
    minVar = 1;
end
end

