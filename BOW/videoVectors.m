tic
videoFeatures = features2BOW(features, 6, 4000, 1);
[coeff,scores,latent] = princomp(videoFeatures(:, 1:end -2));
latent =latent(1) - latent;
for(pruneIndex=size(latent, 1):-1:2)
    if(floor(latent(pruneIndex)) ~= floor(latent(pruneIndex-1)))
        break;
    end
end
videoFeatures = [scores(:, 1:pruneIndex) videoFeatures(:, end-1:end)];
clear scores;
toc;
