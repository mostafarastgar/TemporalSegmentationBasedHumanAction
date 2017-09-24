labels = load('../data/break fast/labels.mat');
labels = labels.labels;
features = zeros(300000, 771);
index = 1;
firstJ = 2;
for(i=3:size(labels, 1))
    dir_perfix = strcat('../data/break fast/clips/', num2str(i), '-', labels{i}, '/');
    videos=dir(strcat(dir_perfix,'*.avi'));
    file_names = {videos.name};
    for(j=firstJ:size(file_names,2))
        tic;
        file_name=strcat(dir_perfix,file_names{j});
        mov = VideoReader(file_name);
        nFrames=mov.NumberOfFrames;
        M=mov.Height;
        N=mov.Width;
        video=zeros(M,N,nFrames,'uint8');
        for k= 1 : nFrames
            im= read(mov,k);
            im=im(:,:,1);
            video(:,:,k)=im;
        end
        stips = demo_selective_stip(0, video);
        HOG3DFeatures = HOG3DAPI(video, stips, power(8/8, 3)*8*64, 8);
        HOOFFeatures = HOOFAPI(video, stips, 32, 8);
        classLabel = zeros(size(stips, 1), 1)+i;
        fileId = zeros(size(stips, 1), 1)+j;
        if(index+size(stips, 1)-1>300000)
            features(index:end, :) = [];
            save(strcat('../data/break fast/features/features_',num2str(i), '_', num2str(j),'.mat'), 'features', '-v7.3');
            features = zeros(300000, 771);
            index = 1;
        end
        features(index:index+size(stips, 1)-1, :) = [HOG3DFeatures HOOFFeatures classLabel fileId stips(:, 3)];
        index = index + size(stips, 1);
        disp([num2str(i), '-', labels{i}, ' file ', num2str(j), 'has been completed']);
        toc;
    end
    firstJ = 1;
end
features(index:end, :) = [];
save('../data/break fast/features/features.mat', 'features', '-v7.3');