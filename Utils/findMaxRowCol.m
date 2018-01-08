function [ row, col] = findMaxRowCol(inputMat)
if(size(inputMat, 1)==0 || size(inputMat, 2)==0)
    row = 0;
    col = 0;
else
    maxes = zeros(size(inputMat, 1), 2);
    for(row=1:size(inputMat, 1))
        [amount, idx] = max(inputMat(row, :));
        maxes(row, :) = [amount, idx];
    end
    [~, row] = max(maxes(:, 1));
    col = maxes(row, 2);
end
end

