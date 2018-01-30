addpath('../../STIPDetector/selective-stip/method 1/demo');
addpath('../../STIPDetector/selective-stip/method 1/src');
addpath('../../Descriptor/hog3d');
addpath('../../Descriptor/HOOF');
addpath('../../Utils');
% % for KTH is 'data/', for break fast is 'data/break fast/', for MPII is 'data/MPII/'
matDirPrefix='../../data/MPII/';
colors = load('../../data/colors.mat');
colors = colors.colors;
correctSegments = load(strcat(matDirPrefix,'correctSegments.mat'));
correctSegments = correctSegments.correctSegments;
labels = load(strcat(matDirPrefix,'labels.mat'));
labels = labels.labels;
GMModel = load(strcat(matDirPrefix,'features/GMModel.mat'));
GMModel = GMModel.GMModel;
normalizationParams = load(strcat(matDirPrefix,'features/normalizationParams.mat'));
minhog = normalizationParams.minhog;
maxhog = normalizationParams.maxhog;
minhoof = normalizationParams.minhoof;
maxhoof = normalizationParams.maxhoof;
pcakmeansparams=load(strcat(matDirPrefix, 'features/pcakmeansparams.mat'));
coeff = pcakmeansparams.coeff;
pruneIndex = pcakmeansparams.pruneIndex;
meanColumns = pcakmeansparams.meanColumns;
pcakmeans2=load(strcat(matDirPrefix, 'features/pca2Params.mat'));
coeff2 = pcakmeans2.coeff2;
pruneIndex2 = pcakmeans2.pruneIndex2;
meanColumns2 = pcakmeans2.meanColumns2;

% % for KTH is 'data/', for break fast is 'data/break fast/', for MPII is 'data/MPII/'
matDirPrefix='../data/MPII/';
HMMData = load(strcat(matDirPrefix,'HMMData.mat'));
HMMData = HMMData.results;
SVMStructs = load(strcat(matDirPrefix,'SVMStructs.mat'));
SVMStructs = SVMStructs.SVMStructs;
windows = load(strcat(matDirPrefix,'windows.mat'));
shifts = windows.shifts;
windows = windows.windows;
shift = round(mean(shifts));
windowSize = [shift shift];
tolerance = round(windowSize(2)/2);
result = {};
for(i=1:size(HMMData, 1))
    teIdx = HMMData{i, 1};
    fences = HMMData{i, 3};
    ESTTR = HMMData{i, 9};
    ESTEMIT = HMMData{i, 10};
    OCs = HMMData{i, 5};
    orgSegs = {};
    segs = {};
    accuracies = [];
    confusionMat = zeros(size(SVMStructs, 2), size(SVMStructs, 2));
    for(j=1:size(teIdx, 1))
        originalSegments = correctSegments{teIdx(j), 3};
        originalSegments = sortrows(originalSegments, 2);
        for(k=2:size(originalSegments, 1))
            originalSegments(k, 1) = originalSegments(k-1, 2)+1;
        end
        partLength = 5;
        mov = VideoReader(strcat('../../data/MPII/videos/', correctSegments{teIdx(j), 1}, '.avi'));
        M=mov.Height;
        N=mov.Width;
        startFrame = 1;
        for(l=1:partLength:size(originalSegments, 1))
            testSequence = [];
            el = l+partLength-1;
            if(el>size(originalSegments, 1))
                el = size(originalSegments, 1);
            end
            partSegments = originalSegments(l:el, :);
            startFrame = min(partSegments(:, 1));
            endFrame = max(partSegments(:, 2));
            
            nFrames = endFrame - startFrame + 1;
            video=zeros(ceil(M/5),ceil(N/5),nFrames,'uint8');
            for k= startFrame : endFrame
                im= read(mov,k);
                im=im(1:5:end,1:5:end,1);
                video(:,:,k-startFrame+1)=im;
            end
            stips = demo_selective_stip(0, video);
            features = [(HOG3DAPI(video, stips, power(8/8, 3)*8*64, 8)-minhog)/(maxhog-minhog) (HOOFAPI(video, stips, 32, 8)-minhoof)/(maxhoof-minhoof)];
            features(isnan(features)) = 0;
            features = bsxfun(@minus, features, meanColumns);
            features = features * coeff;
            features = features(:, 1:pruneIndex);
            for(k=1:windowSize(2):nFrames)
                eIdx = k + windowSize(1) - 1;
                if(eIdx>nFrames)
                    eIdx = nFrames;
                end
                cube = features(find(any(stips(:, 3)>=k, 2) & any(stips(:, 3)<=eIdx, 2)), :);
                p = posterior(GMModel, cube);
                vector = sum(p, 1);
                if(sum(vector) ~= 0)
                    vector = bsxfun(@minus, vector, meanColumns2);
                    vector = vector * coeff2;
                    vector = vector(:, 1:pruneIndex2);
                    
                    [IDX,D]=knnsearch(OCs, vector);
                    if(D>fences(IDX, 1)&&D<=fences(IDX, 2))
                        % Do nothing
                    else
                        if(D>fences(IDX, 3)&&D<=fences(IDX, 4))
                            IDX = size(OCs, 1) + 1;
                        else
                            IDX = size(OCs, 1) + 2;
                        end
                    end
                    testSequence = [testSequence; startFrame+k-1 startFrame+eIdx-1 IDX];
                end
            end
            try
                [ STATES, segments ] = testHMM(testSequence, ESTTR, ESTEMIT, windowSize);
                features = [features stips(:, 3)];
                [partSegments, segments, accuracy, confusionMat, meanClass, correct] = findAccuracy(partSegments, segments, tolerance, SVMStructs, confusionMat, features, GMModel, coeff2, pruneIndex2, meanColumns2, labels);
                orgSegs{end+1} = partSegments;
                segs{end+1} = segments;
                accuracies = [accuracies;accuracy];
                save(strcat(matDirPrefix, 'results.mat'), 'orgSegs', 'segs', 'accuracies', 'confusionMat', 'meanClass',  '-v7.3');
                display(strcat('segment ', num2str(j), ' in iteration ', num2str(i), ' part ', num2str(l+partLength-1), ' out of ', num2str(size(originalSegments, 1)), ' has been done. mean class accuracy is ', num2str(meanClass),'. correct count is ', num2str(correct),'. accuracy is ', num2str(accuracy), ' mean accuracy: ', num2str(mean(accuracies(:, 1)))));
            catch exception
                display(exception);
            end
        end
    end
    result{i, 1} = {orgSegs, segs, accuracies};
    result{i, 2} = mean(accuracies(:, 1));
    result{i, 3} = confusionMat;
    result{i, 3} = meanClass;
    display(strcat('********end of iteration ', num2str(i), '********'));
end
% [~, idx] = max(result{:, 2});
% subplot(2, 1, 1);
% plot(result{:, 2});
% best = result{idx, 1};
% [~, idx] = max(best{3});
% subplot(2, 1, 2);
% displaySegments(best{3}{1}, best{3}{2}, colors);
