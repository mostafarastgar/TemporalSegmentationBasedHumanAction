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
tmp = [zeros(size(segments, 1), 1) segments(:, 1) zeros(size(segments, 1), 1) segments(:, end)];
for(i=1:size(segments, 1))
    tmp(i, 1) = start;
    tmp(i, 3) = tmp(i, 2) - tmp(i, 1) + 1;
    start = tmp(i, 2) + 1;
end
segments = tmp;
tmpOrg = [];
tmpIn = [];
[~, idx] = sort(segments(:, 3), 'descend');
faults = 0;
slabel = 1;
for(i=1:size(idx, 1))
    segment = segments(idx(i), :);
    index = findNearestSegment(segment, originalSegments);
    if(index > 0)
        conflict = abs(originalSegments(index, 1) - segment(1));
        if(conflict<=tolerance)
            conflict = 0;
        end
        faults = faults + conflict;
        
        conflict = abs(originalSegments(index, 2) - segment(2));
        if(conflict<=tolerance)
            conflict = 0;
        end
        faults = faults + conflict;
        tmpOrg = [tmpOrg; originalSegments(index, :)];
        tmpOrg(end, 4) = slabel;
        tmpIn = [tmpIn; segments(idx(i), :)];
        tmpIn(end, 4) = slabel;
        originalSegments(index, :) = [];
        slabel = slabel +1;
    else
        conflict = segment(3);
        if(conflict<=tolerance)
            conflict = 0;
        end
        faults = faults + conflict;
        tmpIn = [tmpIn; segments(idx(i), :)];
        tmpIn(end, 4) = 0;
    end
end
if(size(originalSegments, 1) >0)
    conflict = sum(originalSegments(:, 3));
    if(conflict<=tolerance)
        conflict = 0;
    end
    faults = faults + conflict;
    for(i=1:size(originalSegments, 1) >0)
        tmpOrg = [tmpOrg; originalSegments(i, :)];
        tmpOrg(end, 4) = slabel;
        slabel = slabel +1;
    end
end
accuracy = 100*(segments(end, 2) - faults)/segments(end, 2);
originalSegments = tmpOrg;
segments = tmpIn;
end

