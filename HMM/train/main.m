features = load('../../data/features/pcakmeansfeatures.mat');
features = features.features;
GMModel = load('../../data/features/GMModel.mat');
GMModel = GMModel.GMModel;
pca2ParamsGMM = load('../../data/features/pca2ParamsGMM.mat');
coeff2 = pca2ParamsGMM.coeff2;
pruneIndex2 = pca2ParamsGMM.pruneIndex2;

windows = break2Windows(features, 6, 1, GMModel, coeff2, pruneIndex2);
display('windows has been created');

[ sequences, prior, transmat, obsmat ] = trainHMMGMM(windows, 6, 20, 20);
save('../../data/features/HMMData.mat', 'windows', 'sequences', 'prior', 'transmat', 'obsmat', '-v7.3');
display('HMM has been trained');
