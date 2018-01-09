% for KTH is 'data/', for break fast is 'data/break fast/', for break fast is 'data/MPII/'
matDirPrefix='../../data/MPII/';

% just for kth
% features = load('../../data/break fast/features/pcakmeansfeatures.mat');
% features = features.features;

GMModel = load(strcat(matDirPrefix, 'features/GMModel.mat'));
GMModel = GMModel.GMModel;
normalizationParams = load(strcat(matDirPrefix, 'features/normalizationParams.mat'));
minhog = normalizationParams.minhog;
maxhog = normalizationParams.maxhog;
minhoof = normalizationParams.minhoof;
maxhoof = normalizationParams.maxhoof;
pcaParams = load(strcat(matDirPrefix, 'features/pcakmeansparams.mat'));
coeff = pcaParams.coeff;
pruneIndex = pcaParams.pruneIndex;
meanColumns = pcaParams.meanColumns;
pca2ParamsGMM = load(strcat(matDirPrefix, 'features/pca2Params.mat'));
coeff2 = pca2ParamsGMM.coeff2;
pruneIndex2 = pca2ParamsGMM.pruneIndex2;
meanColumns2 = pca2ParamsGMM.meanColumns2;
arvData = load(strcat(matDirPrefix, 'features/arvData.mat'));
arvData = arvData.arvData;
labels = arvData(:, end-1:end);
arvData = [bsxfun(@minus, arvData(:, 1:end-2), meanColumns2) arvData(:, end-1:end)];
arvData = arvData(:, 1:end-2) * coeff2;
arvData = [arvData(:, 1:pruneIndex2) labels];
correctSegments = load(strcat(matDirPrefix, 'correctSegments.mat'));
correctSegments = correctSegments.correctSegments;
labels = load(strcat(matDirPrefix, 'labels.mat'));
labels = labels.labels;
windowSize = [100 100];
% windows = break2Windows(features, 6, windowSize, GMModel, coeff2, pruneIndex2);
featurePath = strcat(matDirPrefix, 'features/detail/');

[windows, shifts] = break2WindowsFeaturePath(featurePath, windowSize, GMModel, minhog, maxhog, minhoof, maxhoof, coeff, pruneIndex, meanColumns, coeff2, pruneIndex2, meanColumns2);
% for KTH is 'data/', for break fast is 'data/break fast/', for break fast is 'data/MPII/'
matDirPrefix='../data/MPII/';
save(strcat(matDirPrefix, 'windows.mat'), 'windows', 'shifts', '-v7.3');

% k=10;
% results = KFoldObservation(k, windows, labels, correctSegments, matDirPrefix);
% 
% SVMStructs = trainClassifier(arvData);
% save(strcat(matDirPrefix, 'SVMStructs.mat'), 'SVMStructs', '-v7.3');