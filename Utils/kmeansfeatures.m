tic;
features(any(isnan(features), 2), :) = [];
toc;

tic;
[coeff,scores,latent] = pca(features(:, 1:end -2));
features = [scores(:, 1:392) features(:, end-1:end)];
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
    if(size(indices, 1)>375)
        dists = [D(indices, i) indices];
        dists = sortrows(dists, 1);
        features(dists(end - 374:end, 2),:) = [];
        disp(num2str(i));
    end
end
toc;