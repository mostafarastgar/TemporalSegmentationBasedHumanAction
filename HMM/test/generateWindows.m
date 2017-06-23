function [ windows, segments ] = generateWindows( features, classes_files, windowSize, GMModel, coeff2, pruneIndex2 )
videoVectors = [];
lastFrameSize = 1;
for(i=1:size(classes_files))
    subData = features(any(features(:, end -3)==classes_files(i, 1), 2)...
        & any(features(:, end -2)==classes_files(i, 2), 2), :);
    minFramesNo = min(subData(:, end -1));
    maxFramesNo = max(subData(:, end -1));
    subData(:, end-1) = subData(:, end-1)-minFramesNo + lastFrameSize;
    videoVectors = [videoVectors; subData];
    lastFrameSize = lastFrameSize + maxFramesNo - minFramesNo + 1;
    if(mod(i, 10) == 0)
        disp(num2str(i));
    end
end
windows = [];
segments = [];
maxFramesNo = max(videoVectors(:, end -1));
for(j=1:ceil(maxFramesNo/windowSize))
    minFrame=(j-1)*windowSize + 1;
    maxFrame=j*windowSize;
    maxFrame = min(maxFrame, maxFramesNo);
    cube = videoVectors(any(videoVectors(:, end -1)>=minFrame, 2) & any(videoVectors(:, end -1)<=maxFrame, 2), :);
    [C,ia] = unique(cube(:, end-3));
    if(size(ia,1)>1)
        oldClass = C(C == cube(1, end-3));
         segments = [segments; C(C == cube(1, end-3)) cube(ia(find(C ~= cube(1, end-3))), end-1)-1];
    end
    p = posterior(GMModel, cube(:, 1:end-4));
    vector = sum(p, 1);
    if(sum(vector) ~= 0)
        windows = [windows; [vector minFrame maxFrame]];
    end
end
segments = [segments; cube(end, end-3) cube(end, end-1)];
labels = windows(:, end-1:end);
windows = [windows(:, 1:end-2) * coeff2];
windows = [windows(:, 1:pruneIndex2) labels];
end
