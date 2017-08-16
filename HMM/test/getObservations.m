function [ sequence, segments ] = getObservations( testWindows, classes_files, OCs, fences )
sequence = [];
lastFrameSize = 1;
segments = [];
for(i=1:size(classes_files))
    subData = testWindows(any(testWindows(:, end-3)==classes_files(i, 1), 2)...
        & any(testWindows(:, end-2)==classes_files(i, 2), 2), :);
    minFramesNo = min(subData(:, end -1));
    maxFramesNo = max(subData(:, end -1));
    subData(:, end-1) = subData(:, end-1)-minFramesNo + lastFrameSize;
    sequence = [sequence; subData];
    lastFrameSize = lastFrameSize + maxFramesNo - minFramesNo + 1;
    segments = [segments; size(sequence, 1) classes_files(i, 1)];
    if(mod(i, 10) == 0)
        disp(num2str(i));
    end
end
sequence(:, end) = sequence(:, end -1);
[IDX,D] = knnsearch(OCs, sequence(:, 1:end-4));
for(i=1:size(IDX, 1))
    if(D(i)>fences(IDX(i), 2))
        IDX(i) = size(OCs, 1) + 2;
    else
        if(D(i)>fences(IDX(i), 1))
            IDX(i) = size(OCs, 1) + 1;
        end
    end
end
sequence = [sequence(:, end-3:end) IDX];
end
