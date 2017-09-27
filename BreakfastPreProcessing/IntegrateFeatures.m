baseDir = '../data/break fast/features/';
videos=dir(strcat(baseDir, 'features*.mat'));
file_names = {videos.name};
features = zeros(2100000, 771);
sIndex = 1;
for(i=1:size(file_names, 2))
    tmp = load(strcat(baseDir, file_names{i}));
    tmp = tmp.features;
    eIndex = sIndex + size(tmp, 1) - 1;
    if(eIndex>size(features, 1))
        features(sIndex:end, :) = [];
        idx = randi(sIndex-1, 600000, 1);
        features(idx, :) = [];
        sIndex = size(features, 1) + 1;
        features = [features; zeros(2100000-size(features, 1), 771)];
        eIndex = sIndex + size(tmp, 1) - 1;
    end
    features(sIndex:eIndex, :) = tmp;
    sIndex = eIndex + 1;
    display([num2str(i), ' ', num2str(eIndex)]);
end
features(sIndex:end, :) = [];
save(strcat(baseDir,'features.mat'), 'features', '-v7.3');
