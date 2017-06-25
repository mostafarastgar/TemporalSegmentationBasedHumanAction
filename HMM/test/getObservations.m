function [ sequence, segments ] = getObservations( testWindows, classes_files, OCs )
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
    segments = [segments; lastFrameSize - 1 classes_files(i, 1)];
    if(mod(i, 10) == 0)
        disp(num2str(i));
    end
end
sequence(:, end) = sequence(:, end -1);
IDX = knnsearch(OCs, sequence(:, 1:end-4));
sequence = [sequence(:, end-3:end) IDX];
end
