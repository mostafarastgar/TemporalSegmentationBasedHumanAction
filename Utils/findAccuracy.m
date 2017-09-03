function [ originalSegments, segments, accuracy ] = findAccuracy( originalSegments, segments, tolerance )
start = 1;
tmp = [originalSegments(:, 1) originalSegments(:, 2) zeros(size(originalSegments, 1), 1) originalSegments(:, end)];
for(i=1:size(originalSegments, 1))
    tmp(i, 1) = start;
    tmp(i, 3) = tmp(i, 2) - tmp(i, 1) + 1;
    start = tmp(i, 2) + 1;
end
originalSegments = tmp;

start = 1;
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
while(inters(row, col) ~= 0)
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
end

