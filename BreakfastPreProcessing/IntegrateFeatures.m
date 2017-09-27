baseDir = '../data/break fast/features/';
videos=dir(strcat(baseDir, 'features*.mat'));
file_names = {videos.name};
features = zeros(10000000, 771);
sIndex = 1;
for(i=1:size(file_names, 2))
    tmp = load(strcat(baseDir, file_names{i}));
    tmp = tmp.features;
    eIndex = sIndex + size(tmp, 1) - 1;
    if(eIndex>size(features, 1))
        calc = randi(2);
        if(calc==1)
            idx = randi(sIndex-1, 1500000, 1);
            features(idx, :) = [];
            sIndex = size(features, 1) + 1;
            features = [features; zeros(10000000-size(features, 1), 771)];
            eIndex = sIndex + size(tmp, 1) - 1;
            features(sIndex:eIndex, :) = tmp;
            sIndex = eIndex + 1;
        end
    else
        features(sIndex:eIndex, :) = tmp;
        sIndex = eIndex + 1;
    end
    display([num2str(i), ' ', num2str(eIndex)]);
end
features(sIndex:end, :) = [];
save(strcat(baseDir,'features.mat'), 'features', '-v7.3');
