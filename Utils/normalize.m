disp('Start normalizing...');
tic;
minhog = min(min(features(:, 1:512)));
maxhog = max(max(features(:, 1:512)));
features(:, 1:512) = (features(:, 1:512)-minhog)/(maxhog - minhog);
toc;
tic;
minhoof = min(min(features(:, 513:768)));
maxhoof = max(max(features(:, 513:768)));
features(:, 513:768) = (features(:, 513:768)-minhoof)/(maxhoof - minhoof);
toc;
save(strcat(matDirPrefix, 'features/normalizedFeatures.mat'), 'features', '-v7.3');
save(strcat(matDirPrefix, 'features/normalizationParams.mat'), 'minhog', 'maxhog', 'minhoof',  'maxhoof', '-v7.3');
