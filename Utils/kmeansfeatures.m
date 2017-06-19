tic;
% features(any(isnan(features), 2), :) = [];
features(isnan(features)) = 0;
toc;

tic;
[coeff,scores,latent] = princomp(features(:, 1:end -3));
latent =100* (latent(1) - latent);
for(pruneIndex=size(latent, 1):-1:2)
    if(floor(latent(pruneIndex)) ~= floor(latent(pruneIndex-1)))
        break;
    end
end
features = [scores(:, 1:pruneIndex) features(:, end-2:end)];
clear scores;
save('data/features/pcafeatures.mat', 'features', '-v7.3');
toc;

tic;
opts = statset('MaxIter',10);
[IDX,C,sumd,D] = kmeans(features(:, 1:end -3),4000,'Options',opts);
toc;

tic;
features = [features IDX];
for(i=1:4000)
    indices = find(features(:, end) == i);
    dists = [D(indices, i) indices];
    dists = sortrows(dists, 1);
    features(dists(round(end*0.073):end, 2),:) = [];
    disp(num2str(i));
end
save('data/features/prunedfeatures.mat', 'features', '-v7.3');
save('data/features/pcakmeansparams.mat', 'C', 'coeff', 'IDX', 'latent', 'opts', 'sumd', '-v7.3');
toc;