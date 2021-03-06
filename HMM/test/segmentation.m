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
pcakmeans2=load(strcat(matDirPrefix, 'features/pca2Params.mat'));
coeff2 = pcakmeans2.coeff2;
pruneIndex2 = pcakmeans2.pruneIndex2;

% % for KTH is 'data/', for break fast is 'data/break fast/', for MPII is 'data/MPII/'
matDirPrefix='../data/MPII/';
HMMData = load(strcat(matDirPrefix,'HMMData.mat'));
HMMData = HMMData.results;
windows = load(strcat(matDirPrefix,'windows.mat'));
shifts = windows.shifts;
windowSize = round(mean(shifts));
tolerance = round(windowSize/2);
windowSize = [windowSize windowSize];
result = {};
for(i=1:size(HMMData, 1))
    teIdx = HMMData{i, 1};
    fences = HMMData{i, 3};
    ESTTR = HMMData{i, 9};
    ESTEMIT = HMMData{i, 10};
    OCs = HMMData{i, 5};
    orgSegs = {};
    segs = {};
    accuracies = zeros(size(teIdx, 1), 1);
    if(i==1)
        startj=1;
    else
        startj=1;
    end
    for(j=startj:size(teIdx, 1))
        originalSegments = correctSegments{teIdx(j), 3};
%         for KTH and Break Fast
%         mov = VideoReader(correctSegments{teIdx(j), 1});
%         for MPII 
        mov = VideoReader(strcat('../../data/MPII/videos/', correctSegments{teIdx(j), 1}, '.avi'));
        nFrames=mov.NumberOfFrames;
        M=mov.Height;
        N=mov.Width;
%         for KTH and Break Fast
%         video=zeros(M,N,nFrames,'uint8');
%         for MPII
        video=zeros(ceil(M/5),ceil(N/5),nFrames,'uint8');
        try
            for k= 1 : nFrames
                im= read(mov,k);
%               for KTH and Break Fast
%               im=im(:,:,1);
%               video(:,:,k)=im;
%               for MPII
                im=im(1:5:end,1:5:end,1);
                video(:,:,k)=im;
            end
        catch exception
            nFrames = k-1;
        end
        stips = demo_selective_stip(0, video);
        features = [(HOG3DAPI(video, stips, power(8/8, 3)*8*64, 8)-minhog)/(maxhog-minhog) (HOOFAPI(video, stips, 32, 8)-minhoof)/(maxhoof-minhoof)];
        features = features * coeff;
        features = features(:, 1:pruneIndex);
        features(isnan(features)) = 0;
        testSequence = [];
        for(k=1:windowSize(2):nFrames)
            eIdx = k + windowSize(1) - 1;
            if(eIdx>nFrames)
                eIdx = nFrames;
            end
            cube = features(find(any(stips(:, 3)>=k, 2) & any(stips(:, 3)<=eIdx, 2)), :);
            p = posterior(GMModel, cube);
            vector = sum(p, 1);
            if(sum(vector) ~= 0)
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
                testSequence = [testSequence; k eIdx IDX];
            end
        end
        [ STATES, segments ] = testHMM(testSequence, ESTTR, ESTEMIT, windowSize);
        [originalSegments, segments, accuracy] = findAccuracy(originalSegments, segments, tolerance);
        orgSegs{j} = originalSegments;
        segs{j} = segments;
        accuracies(j) = accuracy;
        display(strcat('segment ', num2str(j), ' in iteration ', num2str(i), ' has been done. accuracy is ', num2str(accuracy), ' mean accuracy: ', num2str(mean(accuracies(1:j)))));
        displaySegments(originalSegments, segments, colors);
    end
    result{i, 1} = {orgSegs, segs, accuracies};
    result{i, 2} = mean(accuracies);
    display(strcat('********end of iteration ', num2str(i), '********'));
end
[~, idx] = max(result{:, 2});
subplot(2, 1, 1);
plot(result{:, 2});
best = result{idx, 1};
[~, idx] = max(best{3});
subplot(2, 1, 2);
displaySegments(best{3}{1}, best{3}{2}, colors);
