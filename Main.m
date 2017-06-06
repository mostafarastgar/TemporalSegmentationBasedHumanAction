addpath('STIPDetector/selective-stip/method 1/demo');
addpath('STIPDetector/selective-stip/method 1/src');
addpath('Descriptor/hog3d');
addpath('Descriptor/HOOF');
addpath('Utils');
dir_perfix = 'D:\mostafa\MS\semmester 1\image processing\Image Project\mat\boxing\';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, 8*162, 9);
    % HOG3DFeatures = (HOG3DFeatures - min(HOG3DFeatures(:)))/(max(HOG3DFeatures(:)) - min(HOG3DFeatures(:)));
    HOOFFeatures = HOOFAPI(video, stips, 32, 9);
    % HOOFFeatures = (HOOFFeatures - min(HOOFFeatures(:)))/(max(HOOFFeatures(:)) - min(HOOFFeatures(:)));
    classLabel = zeros(size(stips, 1), 1) + 1;
    features = [features; HOG3DFeatures HOOFFeatures classLabel];
    display('boxing');
    display(i);
end

dir_perfix = 'D:\mostafa\MS\semmester 1\image processing\Image Project\mat\handwaving\';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, 8*162, 9);
    HOOFFeatures = HOOFAPI(video, stips, 32, 9);
    classLabel = zeros(size(stips, 1), 1) + 2;
    features = [features; HOG3DFeatures HOOFFeatures classLabel];
    display('handwaving');
    display(i);
end

dir_perfix = 'D:\mostafa\MS\semmester 1\image processing\Image Project\mat\handclapping\';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, 8*162, 9);
    HOOFFeatures = HOOFAPI(video, stips, 32, 9);
    classLabel = zeros(size(stips, 1), 1) + 3;
    features = [features; HOG3DFeatures HOOFFeatures classLabel];
    display('handclapping');
    display(i);
end

dir_perfix = 'D:\mostafa\MS\semmester 1\image processing\Image Project\mat\jogging\';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, 8*162, 9);
    HOOFFeatures = HOOFAPI(video, stips, 32, 9);
    classLabel = zeros(size(stips, 1), 1) + 4;
    features = [features; HOG3DFeatures HOOFFeatures classLabel];
    display('jogging');
    display(i);
end

dir_perfix = 'D:\mostafa\MS\semmester 1\image processing\Image Project\mat\running\';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, 8*162, 9);
    HOOFFeatures = HOOFAPI(video, stips, 32, 9);
    classLabel = zeros(size(stips, 1), 1) + 5;
    features = [features; HOG3DFeatures HOOFFeatures classLabel];
    display('running');
    display(i);
end

dir_perfix = 'D:\mostafa\MS\semmester 1\image processing\Image Project\mat\walking\';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, 8*162, 9);
    HOOFFeatures = HOOFAPI(video, stips, 32, 9);
    classLabel = zeros(size(stips, 1), 1) + 6;
    features = [features; HOG3DFeatures HOOFFeatures classLabel];
    display('walking');
    display(i);
end
% options = statset('Display','final');
% obj = fitgmdist(features,2,'Options',options);