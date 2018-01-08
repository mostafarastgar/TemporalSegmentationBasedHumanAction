function [ originalSegments, segments, accuracy, confusionMat, meanClass, correct ] = findAccuracy( originalSegments, segments, tolerance, SVMStructs, confusionMat, features, GMModel, coeff2, pruneIndex2, labels)
originalSegments = sortrows(originalSegments, 1);
segments = sortrows(segments, 1);

start = min(originalSegments(:, 1));
originalSegments(:, 1) = originalSegments(:, 1) - start + 1;
originalSegments(:, 2) = originalSegments(:, 2) - start + 1;
start = min(originalSegments(:, 1));
tmp = [originalSegments(:, 1) originalSegments(:, 2) zeros(size(originalSegments, 1), 1) originalSegments(:, end)];
for(i=1:size(originalSegments, 1))
    tmp(i, 1) = start;
    tmp(i, 3) = tmp(i, 2) - tmp(i, 1) + 1;
    start = tmp(i, 2) + 1;
end
originalSegments = tmp;
mainSegments = originalSegments;

start = min(segments(:, 1));
segments(:, 1) = segments(:, 1) - start + 1;
segments(:, 2) = segments(:, 2) - start + 1;
start = min(segments(:, 1));
tmp = [segments(:, 1) segments(:, 2) zeros(size(segments, 1), 1) segments(:, end)];
for(i=1:size(segments, 1))
    tmp(i, 1) = start;
    tmp(i, 3) = tmp(i, 2) - tmp(i, 1) + 1;
    start = tmp(i, 2) + 1;
end
segments = tmp;
tmpOrg = [];
tmpIn = [];
faults = ones(1, max(originalSegments(:, 2)));
slabel = 1;
inters = zeros(size(originalSegments, 1), size(segments, 1));
for(i=1:size(originalSegments, 1))
    for(j=1:size(segments, 1))
        inters(i, j) = getIntersection(originalSegments(i, :), segments(j, :));
    end
end
[row, col] = findMaxRowCol(inters);
while(row~=0 && col~=0 && inters(row, col)~=0)
    orgSeg = originalSegments(row, :);
    seg=segments(col, :);
    startIndex = max(seg(1), orgSeg(1));
    conflict = abs(seg(1) - orgSeg(1));
    if(conflict<=tolerance)
        startIndex = min(seg(1), orgSeg(1));
    end
    
    endIndex = min(seg(2), orgSeg(2));
    conflict = abs(seg(2) - orgSeg(2));
    if(conflict<=tolerance)
        endIndex = max(seg(2), orgSeg(2));
    end
    faults(startIndex:endIndex) = 0;
    
    tmpOrg = [tmpOrg; orgSeg];
    tmpOrg(end, 4) = slabel;
    tmpIn = [tmpIn; seg];
    tmpIn(end, 4) = slabel;
    slabel = slabel + 1;
    
    inters(row, :) = [];
    inters(:, col) = [];
    originalSegments(row, :) = [];
    segments(col, :) = [];
    [row, col] = findMaxRowCol(inters);
end
for(i=1:size(originalSegments, 1))
    tmpOrg = [tmpOrg; originalSegments(i, 1:end-1) slabel];
    slabel = slabel + 1;
end
for(i=1:size(segments, 1))
    tmpIn = [tmpIn; segments(i, 1:end-1) slabel];
    slabel = slabel + 1;
end
originalSegments = tmpOrg;
segments = tmpIn;
faults = sum(faults);
accuracy = 100*(max(originalSegments(:, 2)) - faults)/max(originalSegments(:, 2));

orgClasses = zeros(1, max(mainSegments(:, 2)));
classes = orgClasses;
for(i=1:size(mainSegments, 1))
    orgClasses(mainSegments(i, 1):mainSegments(i, 2)) = mainSegments(i, 4);
end
for(i=1:size(segments, 1))
    cube = features(any(features(:, end)>=segments(i, 1), 2) & any(features(:, end)<=segments(i, 2), 2), 1:end-1);
    p = posterior(GMModel, cube);
    vector = sum(p, 1);
    class = 0;
    if(sum(vector) ~= 0)
        vector = vector * coeff2;
        vector = vector(:, 1:pruneIndex2);
        class = findClass(vector, SVMStructs);
    end
    classes(segments(i, 1):segments(i, 2)) = class+1;
end

for(i=1:size(orgClasses, 2))
    if(orgClasses(i)~=1 && classes(i)~=1)
        if(labels{orgClasses(i), 2} == labels{classes(i), 2})
            confusionMat(orgClasses(i)-1, orgClasses(i)-1) = confusionMat(orgClasses(i)-1, orgClasses(i)-1) + 1;
        else
            confusionMat(orgClasses(i)-1, classes(i)-1) = confusionMat(orgClasses(i)-1, classes(i)-1) + 1;
        end
    end
end
correct = 0;
for(i=1:size(confusionMat, 1))
    correct = correct + confusionMat(i, i);
end
meanClass = correct/sum(sum(confusionMat));
end