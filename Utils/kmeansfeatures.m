tic;
% features(any(isnan(features), 2), :) = [];
features(isnan(features)) = 0;
toc;

tic;
[coeff,scores,latent] = pca(features(:, 1:end -2));
latent =100* (latent(1) - latent);
for(pruneIndex=size(latent, 1):-1:2)
    if(floor(latent(pruneIndex)) ~= floor(latent(pruneIndex-1)))
        break;
    end
end
features = [scores(:, 1:pruneIndex) features(:, end-1:end)];
clear scores;
toc;

tic;
opts = statset('MaxIter',10);
[IDX,C,sumd,D] = kmeans(features(:, 1:end -2),4000,'Options',opts);
toc;

tic;
features = [features IDX];
for(i=1:4000)
    indices = find(features(:, end) == i);
    if(size(indices, 1)>400)
        dists = [D(indices, i) indices];
        dists = sortrows(dists, 1);
        features(dists(end - 400:end, 2),:) = [];
        disp(num2str(i));
    end
end
toc;