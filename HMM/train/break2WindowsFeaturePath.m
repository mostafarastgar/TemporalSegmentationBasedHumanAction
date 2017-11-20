% features = pcakmeansfeatures.mat
function [ windows, shifts ] = break2WindowsFeaturePath( featurePath,windowSize, GMModel, minhog, maxhog, minhoof, maxhoof, coeff, pruneIndex, coeff2, pruneIndex2)
videos=dir(strcat(featurePath,'*.mat'));
file_names = {videos.name};
windows = [];
shifts = [];
for(i=1:size(file_names, 2))
    file_name=strcat(featurePath,file_names{i});
    features = load(file_name);
    features = features.features;
    [c, ia] = unique(features(:, end-2:end-1), 'rows');
    for(j=1:size(ia, 1))
        if(j == size(ia, 1))
            ej=size(features, 1);
        else
            ej = ia(j+1)-1;
        end
        subData = features(ia(j):ej, :);
        maxFramesNo = max(subData(:, end));
        if(maxFramesNo>=windowSize(1)*8)
            shift = round(maxFramesNo/windowSize(1));
        else
            shift = round(maxFramesNo/8);
        end
        shifts = [shifts; shift];
        windowsCount = ceil((maxFramesNo-shift)/shift)+1;
        tic;
        for(k=1:windowsCount)
            minFrame=(k-1)*shift + 1;
            maxFrame=minFrame + shift-1;
            if(maxFrame>maxFramesNo)
                maxFrame = maxFramesNo;
            end
            cube = subData(any(subData(:, end)>=minFrame, 2) & any(subData(:, end)<=maxFrame, 2), :);
            cube(:, 1:512) = (cube(:, 1:512)-minhog)/(maxhog - minhog);
            cube(:, 513:768) = (cube(:, 513:768)-minhoof)/(maxhoof - minhoof);
            cube(isnan(cube)) = 0;
            cube = cube(:, 1:end-3)*coeff(:, :);
            cube = cube(:, 1:pruneIndex);
            p = posterior(GMModel, cube);
            vector = sum(p, 1);
            if(sum(vector) ~= 0)
                vector = vector * coeff2;
                vector = vector(:, 1:pruneIndex2);
                windows = [windows; vector c(j, 1) c(j, 2) minFrame maxFrame];
            end
        end
        toc;
        display(strcat(['upto index ', num2str(j), ' of ', num2str(size(ia, 1)),' has been done.']));
    end
    save('../data/break fast/windows.mat', 'windows', 'shifts', '-v7.3');
    display(strcat(['***file ', num2str(i), ' has been done***']));
end
end