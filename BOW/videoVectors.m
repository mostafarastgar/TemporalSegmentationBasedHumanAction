% videoFeatures = features2BOW(features, classNO, 4000, 1);
mats=dir(strcat(matDirPrefix,'features/detail/*.mat'));
file_names = {mats.name};
arvData = [];
for(i=1 : size(file_names,2))
    tic;
    file_name=strcat(matDirPrefix, 'features/detail/', file_names{i});
    features = load(file_name);
    features = features.features;
    classes = unique(features(:, end-2));
    for(classIdx=1:size(classes, 1))
        classFeatures = features(features(:, end-2)==classes(classIdx), :);
        files = unique(classFeatures(:, end-1));
        for(fileIdx=1:size(files, 1))
            fileFeatures = classFeatures(classFeatures(:, end-1)==files(fileIdx), :);
            fileFeatures(:, 1:512) = (fileFeatures(:, 1:512) - minhog)/(maxhog-minhog);
            fileFeatures(:, 513:768) = (fileFeatures(:, 513:768) - minhoof)/(maxhoof-minhoof);
            fileFeatures = [bsxfun(@minus, fileFeatures(:, 1:end -3), meanColumns) fileFeatures(:, end-2:end)];
            fileFeatures = fileFeatures(:, 1:end-3) * coeff;
            fileFeatures = fileFeatures(:, 1:pruneIndex);
            fileFeatures(isnan(fileFeatures)) = 0;
            P = posterior(GMModel, fileFeatures);
            arvData = [arvData; sum(P, 1) classes(classIdx) files(fileIdx)];
            disp(strcat('features:', num2str(i),' of ', num2str(size(file_names,2)) ,' calss:', num2str(classIdx), ' of ', num2str(size(classes, 1)),' file:', num2str(fileIdx), ' of ', num2str(size(files, 1)),' has been done.'));
        end
    end
    toc;
end
save(strcat(matDirPrefix, 'features/arvData.mat'), 'arvData', '-v7.3');
meanColumns2 = mean(arvData(:, 1:end-2));
[coeff2,scores2,latent2] = princomp(arvData(:, 1:end-2));
latent2 =100*(latent2(1) - latent2);
for(pruneIndex2=size(latent2, 1):-1:2)
    if(floor(latent2(pruneIndex2)) ~= floor(latent2(pruneIndex2-1)))
        break;
    end
end
scores2 = [scores2(:, 1:pruneIndex2) arvData(:, end-1:end)];
save(strcat(matDirPrefix, 'features/pca2Params.mat'), 'coeff2', 'latent2', 'scores2', 'pruneIndex2', 'meanColumns2', '-v7.3');
