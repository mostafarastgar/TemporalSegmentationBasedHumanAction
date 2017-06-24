function [ loglik, D, Qs, segments ] = interactiveTestsHMM( features, classes_files, windowSize, windows, GMModel, coeff2, pruneIndex2, prior, obsmat, transmat )
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
end
maxFramesNo = max(videoVectors(:, end -1));
beginFrameNo = 1;
shiftWindow = windowSize;
while(1)
    endFrameNo = beginFrameNo + shiftWindow -1;
    endFrameNo = min(endFrameNo, maxFramesNo);
    if(endFrameNo < beginFrameNo)
        break;
    end
    cube = videoVectors(any(videoVectors(:, end -1)>=beginFrameNo, 2) & any(videoVectors(:, end -1)<=endFrameNo, 2), :);
    p = posterior(GMModel, cube(:, 1:end-4));
    input = sum(p, 1);
    if(sum(input) ~= 0)
        input = input(:, :) * coeff2;
        input = [input(:, 1:pruneIndex2) beginFrameNo endFrameNo];
        [IDX, D] = knnsearch(windows(:, 1:end-4), input(:, 1:end-2));
        if(beginFrameNo == 1)
            obsMatInd = ((windows(IDX(1), end-3)-1)*3) + 1;
            loglik = prior(obsMatInd) * obsmat(obsMatInd, IDX(1));
            lastQ = obsMatInd;
            Qs = [lastQ];
            segments = [];
        else
            [C, indice] = max(transmat(lastQ, :) .* transpose(obsmat(:, IDX(1))));
            if(C == 0)
                [C, indice] = max(transmat(lastQ, :) .* transpose(obsmat(:, IDX(1)-1)));
            end
            loglik = loglik + C;
            
            newClass = floor((indice-1)/3)+1;
            lastClass = floor((lastQ-1)/3)+1;
            if(newClass ~= lastClass)
                segments = [segments; lastClass input(1, end -1) - 1 - floor(shiftWindow/2)];
                shiftWindow = -1 * floor(shiftWindow/2);
            end
            lastQ = indice;
            Qs = [Qs lastQ];
        end
        
    end
    if(endFrameNo == maxFramesNo)
        break;
    end
    beginFrameNo = beginFrameNo + shiftWindow;
    shiftWindow = windowSize;
end
segments = [segments; lastClass input(1, end)];

