disp('Start normalizing...');
tic;
minhog = min(min(features(:, 1:1296)));
maxhog = max(max(features(:, 1:1296)));
features(:, 1:1296) = (features(:, 1:1296)-minhog)/(maxhog - minhog);
toc;
tic;
minhoof = min(min(features(:, 1297:1552)));
maxhoof = max(max(features(:, 1297:1552)));
features(:, 1297:1552) = (features(:, 1297:1552)-minhoof)/(maxhoof - minhoof);
toc;
save('data/features/normalizedFeatures.mat', 'features', '-v7.3');