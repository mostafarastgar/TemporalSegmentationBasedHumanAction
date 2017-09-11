features = zeros(2400000, 771);
index = 1;

dir_perfix = 'data/mat/boxing/';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, power(8/8, 3)*8*64, 8);
    HOOFFeatures = HOOFAPI(video, stips, 32, 8);
    classLabel = zeros(size(stips, 1), 1) + 1;
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId stips(:, 3)];
    index = index + size(stips, 1);
    display('boxing');
    display(i);
end

dir_perfix = 'data/mat/handclapping/';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, power(8/8, 3)*8*64, 8);
    HOOFFeatures = HOOFAPI(video, stips, 32, 8);
    classLabel = zeros(size(stips, 1), 1) + 2;
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId stips(:, 3)];
    index = index + size(stips, 1);
    display('handclapping');
    display(i);
end

dir_perfix = 'data/mat/handwaving/';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, power(8/8, 3)*8*64, 8);
    HOOFFeatures = HOOFAPI(video, stips, 32, 8);
    classLabel = zeros(size(stips, 1), 1) + 3;
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId stips(:, 3)];
    index = index + size(stips, 1);
    display('handwaving');
    display(i);
end

dir_perfix = 'data/mat/jogging/';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, power(8/8, 3)*8*64, 8);
    HOOFFeatures = HOOFAPI(video, stips, 32, 8);
    classLabel = zeros(size(stips, 1), 1) + 4;
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId stips(:, 3)];
    index = index + size(stips, 1);
    display('jogging');
    display(i);
end

dir_perfix = 'data/mat/running/';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, power(8/8, 3)*8*64, 8);
    HOOFFeatures = HOOFAPI(video, stips, 32, 8);
    classLabel = zeros(size(stips, 1), 1) + 5;
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId stips(:, 3)];
    index = index + size(stips, 1);
    display('running');
    display(i);
end

dir_perfix = 'data/mat/walking/';
videos=dir(strcat(dir_perfix,'*.mat'));
file_names = {videos.name};
for i=1 : size(file_names,2)
    file_name=strcat(dir_perfix,file_names{i});
    video = load(file_name);
    video = video.video;
    stips = demo_selective_stip(0, video);
    HOG3DFeatures = HOG3DAPI(video, stips, power(8/8, 3)*8*64, 8);
    HOOFFeatures = HOOFAPI(video, stips, 32, 8);
    classLabel = zeros(size(stips, 1), 1) + 6;
    fileId = zeros(size(stips, 1), 1) + i;
    features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId stips(:, 3)];
    index = index + size(stips, 1);
    display('walking');
    display(i);
end
features(index:end, :) = [];
save('data/features/features.mat', 'features', '-v7.3');