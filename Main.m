addpath('STIPDetector/selective-stip/method 1/demo');
addpath('STIPDetector/selective-stip/method 1/src');
addpath('Descriptor/hog3d');
addpath('Descriptor/HOOF');
addpath('Utils');
addpath('BOW');
addpath('BreakfastPreProcessing');
addpath('MPIIPreProcessing');
addpath('HMM');
addpath('HMM/train');

% for KTH, call this
% ExtractFeatures;
% for break fast, call this
% MainBreakfast;
% for MPII call this
% MainMPII;

% for KTH is 'data/', for break fast is 'data/break fast/', for MPII is 'data/MPII/'
matDirPrefix='data/MPII/';
% for KTH is 6, for break fast is 49, for MPII is 64
classNO=64;

% normalize;
% 
% kmeansfeatures;
% 
% GMModel = GMM(features, C, matDirPrefix);
% 
videoVectors;