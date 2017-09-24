baseDir = '../data/break fast/features/';
videos=dir(strcat(baseDir, 'features*.mat'));
file_names = {videos.name};
features = zeros(71000000, 771);
sIndex = 1;
for(i=1:size(file_names, 2))
    tmp = load(strcat(baseDir, file_names{i}));
    tmp = tmp.features;
    idx = randi(size(tmp, 1), round(size(tmp, 1)*0.572), 1);
    tmp(idx, :) = [];
    eIndex = sIndex + size(tmp, 1) - 1;
    features(sIndex:eIndex, :) = tmp;
    sIndex = eIndex + 1;
    display(num2str(i));
end
features(sIndex:end, :) = [];
save(strcat(baseDir,'features.mat'), 'features', '-v7.3');
