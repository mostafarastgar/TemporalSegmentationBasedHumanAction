function [ data ] = features2BOW( features, classNO, BOWBins, displayIters )
data = [];
for(i=1:classNO)
    fileIndex = 1;
    subData = features(any(features(:, end - 3)==i, 2) & any(features(:, end -2)==fileIndex, 2), :);
    while(size(subData, 1)>0)
        data = [data; zeros(1, BOWBins) i fileIndex];
        for(bin=1:BOWBins)
            data(end, bin) = size(subData(any(subData(:, end)==bin, 2), :), 1);
        end
        if(displayIters == 1)
            disp(strcat(['class:', num2str(i), ' file:', num2str(fileIndex)]));
        end
        fileIndex = fileIndex + 1;
        subData = features(any(features(:, end - 3)==i, 2) & any(features(:, end -2)==fileIndex, 2), :);
    end
end
end

