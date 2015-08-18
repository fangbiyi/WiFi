function TEMP1 = VarianceVector(TEMP,WIN)

ROW = size(TEMP,1);
COL = size(TEMP,2);
R_LEN = floor(ROW/WIN);
TEMP1 = zeros(R_LEN,COL);
for i = 1:R_LEN
    if (i*WIN < ROW)
        x = TEMP(1 + (i-1)*WIN:WIN + (i-1)*WIN,:);
        TEMP1(i,:) = var((x' - mean(x)'*ones(1,size(x,1)))');
    end
end

end