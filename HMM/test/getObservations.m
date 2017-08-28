function [ sequence, segments ] = getObservations( features, classes_files, windowSize, GMModel, coeffGMM, pruneGMM, OCs, fences )
sequence = [];
lastFrameSize = 0;
segments = zeros(size(classes_files,1), 3);
sequence = [];
idxs = [];
for(i=1:size(classes_files))
    idx = find(any(features(:, end-3)==classes_files(i, 1), 2)...
        & any(features(:, end-2)==classes_files(i, 2), 2));
    subData = features(idx, :);
    minFramesNo = min(subData(:, end -1));
    maxFramesNo = max(subData(:, end -1));
    segments(i, :) = [minFramesNo+lastFrameSize maxFramesNo+lastFrameSize classes_files(i, 1)];
    features(idx, end -1)=features(idx, end -1)+lastFrameSize;
    lastFrameSize = maxFramesNo+lastFrameSize;
    idxs = [idxs; idx];
end
subData = features(idxs, :);
maxFramesNo = max(subData(:, end-1));
windowsCount = ceil((maxFramesNo-windowSize(1))/windowSize(2))+1;
for(j=1:windowsCount)
    minFrame=(j-1)*windowSize(2) + 1;
    maxFrame=minFrame + windowSize(1)-1;
    if(maxFrame>maxFramesNo)
        maxFrame = maxFramesNo;
    end
    cube = subData(any(subData(:, end -1)>=minFrame, 2) & any(subData(:, end -1)<=maxFrame, 2), 1:end-4);
    p = posterior(GMModel, cube);
    vector = sum(p, 1);
    vector = vector*coeffGMM;
    vector = vector(1, 1:pruneGMM);
    if(sum(vector) ~= 0)
        [IDX,D]=knnsearch(OCs, vector);
        if(D>fences(IDX, 2))
            IDX = size(OCs, 1) + 2;
        else
            if(D>fences(IDX, 1))
                IDX = size(OCs, 1) + 1;
            end
        end
        sequence = [sequence; minFrame maxFrame IDX];
    end
end
