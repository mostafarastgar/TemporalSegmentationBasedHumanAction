% for KTH is 'data/', for break fast is 'data/break fast/'
matDirPrefix='../../data/break fast/';

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
windowSize = [10 10];
% windows = break2Windows(features, 6, windowSize, GMModel, coeff2, pruneIndex2);
windows = break2WindowsFeaturePath(strcat(matDirPrefix, 'features/detail/'), windowSize, GMModel, minhog, maxhog, minhoof, maxhoof, coeff, pruneIndex, coeff2, pruneIndex2);
% for KTH is 'data/', for break fast is 'data/break fast/'
matDirPrefix='../data/break fast/';
% save(strcat(matDirPrefix, 'windows.mat'), 'windows', '-v7.3');

k=10;
results = KFoldObservation(k, windows, labels, correctSegments, matDirPrefix);
