% features = pcakmeansfeatures.mat
function [ windows, shifts ] = break2WindowsFeaturePath(featurePath, windowSize, GMModel, minhog, maxhog, minhoof, maxhoof, coeff, pruneIndex, meanColumns, coeff2, pruneIndex2, meanColumns2)
videos=dir(strcat(featurePath,'*.mat'));
file_names = {videos.name};
windows = [];
shifts = [];
for(i=1:size(file_names, 2))
    tic;
    file_name=strcat(featurePath,file_names{i});
    features = load(file_name);
    features = features.features;
    classes = unique(features(:, end-2));
    for(classIdx=1:size(classes, 1))
        classFeatures = features(features(:, end-2)==classes(classIdx), :);
        files = unique(classFeatures(:, end-1));
        for(fileIdx=1:size(files, 1))
            tic;
            fileFeatures = classFeatures(classFeatures(:, end-1)==files(fileIdx), :);
            fileFeatures(:, 1:512) = (fileFeatures(:, 1:512) - minhog)/(maxhog-minhog);
            fileFeatures(:, 513:768) = (fileFeatures(:, 513:768) - minhoof)/(maxhoof-minhoof);
            labels = fileFeatures(:, end-2:end);
            fileFeatures(isnan(fileFeatures)) = 0;
            fileFeatures = [bsxfun(@minus, fileFeatures(:, 1:end-3), meanColumns) fileFeatures(:, end-2:end)];
            fileFeatures = fileFeatures(:, 1:end-3) * coeff;
            fileFeatures = fileFeatures(:, 1:pruneIndex);
            fileFeatures = posterior(GMModel, fileFeatures);
            fileFeatures = [fileFeatures labels];
            maxFramesNo = max(fileFeatures(:, end));
            if(maxFramesNo>=windowSize(1)*8)
                shift = round(maxFramesNo/windowSize(1));
            else
                shift = round(maxFramesNo/8);
            end
            shifts = [shifts; shift];
            windowsCount = ceil((maxFramesNo-shift)/shift)+1;
            for(k=1:windowsCount)
                minFrame=(k-1)*shift + 1;
                maxFrame=minFrame + shift-1;
                if(maxFrame>maxFramesNo)
                    maxFrame = maxFramesNo;
                end
                cube = fileFeatures(any(fileFeatures(:, end)>=minFrame, 2) & any(fileFeatures(:, end)<=maxFrame, 2), :);
                vector = sum(cube(:, 1:end-3), 1);
                if(sum(vector) ~= 0)
                    vector = bsxfun(@minus, vector, meanColumns2);
                    vector = vector * coeff2;
                    vector = vector(:, 1:pruneIndex2);
                    windows = [windows; vector classes(classIdx) files(fileIdx) minFrame maxFrame];
                end
            end
            display(strcat(['upto fileIdx ', num2str(fileIdx), ' out of ', num2str(size(files, 1)),' has been done.']));
            toc;
        end
        display(strcat(['upto classIdx ', num2str(classIdx), ' out of ', num2str(size(classes, 1)),' has been done.']));
    end
    display(strcat(['***file ', num2str(i), ' has been done***']));
    toc;
end
end