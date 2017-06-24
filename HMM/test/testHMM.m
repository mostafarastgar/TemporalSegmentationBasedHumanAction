function [ loglik, Qs, segments ] = testHMM( input, prior, obsmat, transmat )
logliks = prior .* obsmat(:, input(1, 5));
loglik = max(logliks);
lastQ = find(logliks == logliks);
Qs = [lastQ];
segments = [];
for(i=2:size(input, 1))
    [C, indice] = max(transmat(lastQ, :) .* transpose(obsmat(:, input(i, 5))));
    loglik = loglik + C;
    
    newClass = floor((indice-1)/3)+1;
    lastClass = floor((lastQ-1)/3)+1;
    if(newClass ~= lastClass)
        segments = [segments; lastClass input(i, end-2) - 1];
    end
    
    lastQ = indice;
    Qs = [Qs lastQ];
end
segments = [segments; lastClass input(i, end-1)];

