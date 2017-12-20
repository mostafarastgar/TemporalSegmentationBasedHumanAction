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
pca2ParamsGMM = load(strcat(matDirPrefix, 'features/pca2Params.mat'));
coeff2 = pca2ParamsGMM.coeff2;
pruneIndex2 = pca2ParamsGMM.pruneIndex2;
correctSegments = load(strcat(matDirPrefix, 'correctSegments.mat'));
correctSegments = correctSegments.correctSegments;
labels = load(strcat(matDirPrefix, 'labels.mat'));
labels = labels.labels;
windowSize = [100 100];
% windows = break2Windows(features, 6, windowSize, GMModel, coeff2, pruneIndex2);
featurePath = strcat(matDirPrefix, 'features/detail/');

% [windows, shifts] = break2WindowsFeaturePath(featurePath, windowSize, GMModel, minhog, maxhog, minhoof, maxhoof, coeff, pruneIndex, coeff2, pruneIndex2);
% for KTH is 'data/', for break fast is 'data/break fast/', for break fast is 'data/MPII/'
matDirPrefix='../data/MPII/';
% save(strcat(matDirPrefix, 'windows.mat'), 'windows', 'shifts', '-v7.3');

k=10;
results = KFoldObservation(k, windows, labels, correctSegments, matDirPrefix);
