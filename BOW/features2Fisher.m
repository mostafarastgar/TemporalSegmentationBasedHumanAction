function [ data ] = features2Fisher( features, classNO, GMModel, binsSize, displayIters )
data = [];
for(i=1:classNO)
    fileIndex = 1;
    subData = features(any(features(:, end - 3)==i, 2) & any(features(:, end -2)==fileIndex, 2), :);
    while(size(subData, 1)>0)
        data = [data; zeros(1, binsSize) i fileIndex];
        P = posterior(GMModel, subData(:, 1:end -4));
        data(end, 1:binsSize) = sum(P, 1);
        if(displayIters == 1)
            disp(strcat(['class:', num2str(i), ' file:', num2str(fileIndex)]));
        end
        fileIndex = fileIndex + 1;
        subData = features(any(features(:, end - 3)==i, 2) & any(features(:, end -2)==fileIndex, 2), :);
    end
end
end

