function [ loglik, D, Qs, segments ] = testHMM( input, windows, prior, obsmat, transmat )
[IDX, D] = knnsearch(windows(:, 1:end-4), input(:, 1:end-2));
obsMatInd = ((windows(IDX(1), end-3)-1)*3) + 1;
loglik = prior(obsMatInd) * obsmat(obsMatInd, IDX(1));
lastQ = obsMatInd;
Qs = [lastQ];
segments = [];
for(i=2:size(IDX, 1))
    [C, indice] = max(transmat(lastQ, :) .* transpose(obsmat(:, IDX(i))));
    if(C == 0)
        [C, indice] = max(transmat(lastQ, :) .* transpose(obsmat(:, IDX(i)-1)));
    end
    loglik = loglik + C;
    
    newClass = floor((indice-1)/3)+1;
    lastClass = floor((lastQ-1)/3)+1;
    if(newClass ~= lastClass)
        segments = [segments; lastClass input(i, end -1) - 1];
    end
    
    lastQ = indice;
    Qs = [Qs lastQ];
end
segments = [segments; lastClass input(i, end)];

