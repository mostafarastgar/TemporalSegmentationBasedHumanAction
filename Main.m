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

% tic;
% GMModel = fitgmdist(features(:, 1:end-4), 4000,'SharedCov', true, 'CovType','diagonal', 'Options',statset('Display','iter','MaxIter',50));
% save('data/features/GMModel.mat', 'GMModel', '-v7.3');
% toc;

% videoVectors;