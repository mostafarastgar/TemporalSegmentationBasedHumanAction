addpath('STIPDetector/selective-stip/method 1/demo');
addpath('STIPDetector/selective-stip/method 1/src');
addpath('Descriptor/hog3d');
addpath('Descriptor/HOOF');
addpath('Utils');

% ExtractFeatures;

% normalize;

% kmeansfeatures;

tic;
GMModel = fitgmdist(features(:, 1:end-2), 4000,'SharedCov', true, 'CovType','diagonal', 'Options',statset('Display','iter','MaxIter',50));
toc;
