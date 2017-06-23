% features = pcakmeansfeatures.mat
function [ windows ] = break2Windows( features, maxClassNo, windowSize, GMModel, coeff2, pruneIndex2)
videoVectors = [];
for(classNo=1:maxClassNo)
    maxVecotorsPerFile = 0;
    for(i=1:400)
        subData = features(any(features(:, end -3)==classNo, 2) & any(features(:, end -2)==i, 2), :);
        if(size(subData, 1)==0)
            break;
        end
        maxFramesNo = max(subData(:, end -1));
        for(j=1:ceil(maxFramesNo/windowSize))
            minFrame=(j-1)*windowSize + 1;
            maxFrame=j*windowSize;
            if(maxFrame>maxFramesNo)
                maxFrame = maxFramesNo;
            end
            cube = subData(any(subData(:, end -1)>=minFrame, 2) & any(subData(:, end -1)<=maxFrame, 2), :);
            p = posterior(GMModel, cube(:, 1:end-4));
            vector = sum(p, 1);
            if(sum(vector) ~= 0)
                videoVectors = [videoVectors; vector classNo i minFrame maxFrame];
            end
        end
        if(j>maxVecotorsPerFile)
            maxVecotorsPerFile = j;
        end
        if(mod(i, 10) == 0)
            disp(num2str(i));
        end
    end
    display(strcat(['class ', num2str(classNo), 'has been done.']));
end
labels = videoVectors(:, end-3:end);
videoVectors = [videoVectors(:, 1:end -4) * coeff2];
videoVectors = [videoVectors(:, 1:pruneIndex2) labels];
windows = videoVectors;
end