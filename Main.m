addpath('STIPDetector/selective-stip/method 1/demo');
addpath('STIPDetector/selective-stip/method 1/src');
addpath('Descriptor/hog3d');
addpath('Descriptor/HOOF');
addpath('Utils');
addpath('BOW');
addpath('BreakfastPreProcessing');
addpath('HMM');
addpath('HMM/train');

% for KTH, call this
ExtractFeatures;
% for break fast, call this
% MainBreakfast;

% for KTH is 'data/', for break fast is 'data/break fast/'
matDirPrefix='data/break fast/';
% for KTH is 6, for break fast is 49
classNO=49;

normalize;

kmeansfeatures;

GMModel = GMM(features, C, matDirPrefix);

videoVectors;