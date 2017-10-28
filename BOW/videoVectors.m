tic
% videoFeatures = features2BOW(features, classNO, 4000, 1);
videoFeatures = features2Fisher(features, classNO, GMModel, 4000, 1);
[coeff2,scores2,latent2] = princomp(videoFeatures(:, 1:end -2));
latent2 =100*(latent2(1) - latent2);
for(pruneIndex2=size(latent2, 1):-1:2)
    if(floor(latent2(pruneIndex2)) ~= floor(latent2(pruneIndex2-1)))
        break;
    end
end
scores2 = [scores2(:, 1:pruneIndex2) videoFeatures(:, end-1:end)];
save(strcat(matDirPrefix, 'features/videoFeatures.mat'), 'videoFeatures', '-v7.3');
save(strcat(matDirPrefix, 'features/pca2Params.mat'), 'coeff2', 'latent2', 'scores2', 'pruneIndex2', '-v7.3');
toc;
