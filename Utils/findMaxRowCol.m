function [ row, col] = findMaxRowCol( inputMat)
mat = reshape(transpose(inputMat), 1, []);
j = size(inputMat, 2);
[~, idx] = max(mat);
row = ceil(idx/j);
col = mod(idx, j);
if(col == 0)
    col = j;
end
end

