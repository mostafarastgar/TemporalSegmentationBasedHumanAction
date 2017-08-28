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
[~, idx] = sort(originalSegments(:, 3), 'descend');
faults = 0;
slabel = 1;
for(i=1:size(idx, 1))
    segment = originalSegments(idx(i), :);
    index = findNearestSegment(segment, segments);
    if(index > 0)
        conflict = abs(segments(index, 1) - segment(1));
        if(conflict<=tolerance)
            conflict = 0;
        end
        faults = faults + conflict;
        
        conflict = abs(segments(index, 2) - segment(2));
        if(conflict<=tolerance)
            conflict = 0;
        end
        faults = faults + conflict;
        tmpOrg = [tmpOrg; originalSegments(idx(i), :)];
        tmpOrg(end, 4) = slabel;
        tmpIn = [tmpIn; segments(index, :)];
        tmpIn(end, 4) = slabel;
        segments(index, :) = [];
    else
        conflict = segment(3);
        if(conflict<=tolerance)
            conflict = 0;
        end
        faults = faults + conflict;
        tmpOrg = [tmpOrg; originalSegments(idx(i), :)];
        tmpOrg(end, 4) = slabel;
    end
    slabel = slabel +1;
end
for(i=1:size(segments, 1))
    tmpIn = [tmpIn; [segments(i, 1:3) slabel]];
    slabel = slabel +1;
end
accuracy = 100*(originalSegments(end, 2) - faults)/originalSegments(end, 2);
originalSegments = tmpOrg;
segments = tmpIn;
end

