addpath('STIPDetector/selective-stip/method 1/demo');
addpath('STIPDetector/selective-stip/method 1/src');
addpath('Descriptor/hog3d');
addpath('Descriptor/HOOF');
addpath('Utils');
video = load('data/mat/jogging/person01_jogging_d1_uncomp1.avi.mat');
video = video.video;
tic;
stips = demo_selective_stip(0, video);
HOG3DFeatures = HOG3DAPI(video, stips, 8*162, 9);
HOG3DFeatures = (HOG3DFeatures - min(HOG3DFeatures(:)))/(max(HOG3DFeatures(:)) - min(HOG3DFeatures(:)));
HOOFFeatures = HOOFAPI(video, stips, 32, 9);
HOOFFeatures = (HOOFFeatures - min(HOOFFeatures(:)))/(max(HOOFFeatures(:)) - min(HOOFFeatures(:)));
features = [HOG3DFeatures HOOFFeatures];
toc;

options = statset('Display','final');
obj = fitgmdist(features,2,'Options',options);