addpath('STIPDetector/selective-stip/method 1/demo');
addpath('STIPDetector/selective-stip/method 1/src');
addpath('Descriptor/hog3d');
addpath('Descriptor/HOOF');
addpath('Utils');
addpath('BOW');
addpath('HMM');
addpath('HMM/train');

% ExtractFeatures;

% normalize;

% kmeansfeatures;

GMModel = GMM(features, C);

videoVectors;