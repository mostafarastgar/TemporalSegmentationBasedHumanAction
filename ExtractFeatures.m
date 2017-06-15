features = zeros(2400000, 1554);
index = 1;

dir_perfix = 'C:\mostafa\Image Project\mat\boxing\';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, 8*162, 9);
    HOOFFeatures = HOOFAPI(video, stips, 32, 9);
    classLabel = zeros(size(stips, 1), 1) + 1;
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId];
    index = index + size(stips, 1);
    display('jogging');
    display(i);
end

dir_perfix = 'C:\mostafa\Image Project\mat\handwaving\';
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
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId];
    index = index + size(stips, 1);
    display('jogging');
    display(i);
end

dir_perfix = 'C:\mostafa\Image Project\mat\handclapping\';
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
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId];
    index = index + size(stips, 1);
    display('jogging');
    display(i);
end

dir_perfix = 'C:\mostafa\Image Project\mat\jogging\';
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
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId];
    index = index + size(stips, 1);
    display('jogging');
    display(i);
end

dir_perfix = 'C:\mostafa\Image Project\mat\running\';
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
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId];
    index = index + size(stips, 1);
    display('running');
    display(i);
end

dir_perfix = 'C:\mostafa\Image Project\mat\walking\';
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
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId];
    index = index + size(stips, 1);
    display('walking');
    display(i);
end
features(index:end, :) = [];
save('data/features/features.mat', 'features', '-v7.3');