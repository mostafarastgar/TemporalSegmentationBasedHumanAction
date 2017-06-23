HMMData = load('../../data/features/HMMData.mat');
windows = HMMData.windows;
prior = HMMData.prior;
obsmat = HMMData.obsmat;
transmat = HMMData.transmat;

features = load('../../data/features/pcakmeansfeatures.mat');
features = features.features;

GMModel = load('../../data/features/GMModel.mat');
GMModel = GMModel.GMModel;

pca2Params = load('../../data/features/pca2ParamsGMM.mat');
coeff2 = pca2Params.coeff2;
latent2 = pca2Params.latent2;
pruneIndex2 = pca2Params.pruneIndex2;
scores2 = pca2Params.scores2;

confuseItems = [1 1; 4 1; 5 4; 2 5];
[testWindows, originalSegments] = generateWindows(features, confuseItems, 1, GMModel, coeff2, pruneIndex2);

% [ loglik, D, Qs, segments ] = testHMM(testWindows, windows, prior, obsmat, transmat);
[ loglik, D, Qs, segments ] = interactiveTestsHMM(features, confuseItems, 1, windows, GMModel, coeff2, pruneIndex2, prior, obsmat, transmat);
