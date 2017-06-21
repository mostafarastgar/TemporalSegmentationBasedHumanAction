function [ loglik, D, Qs ] = testHMM( input, videoVectors, obsmat, transmat )
[IDX, D] = knnsearch(videoVectors(:, 1:end-4), input);
loglik = obsmat(1, IDX(1));
lastQ = 1;
Qs = [lastQ];
for(i=2:size(IDX, 1))
    [C, indice] = max(transmat(lastQ, :) .* transpose(obsmat(:, IDX(i))));
    lastQ = indice;
    loglik = loglik * C;
    Qs = [Qs lastQ];
end

