function [ originalSegments, segments, accuracy ] = findAccuracy( originalSegments, segments )
tmpOrg = [];
tmpIn = [];
[~, idx] = sort(segments(:, 3), 'descend');
faults = 0;
slabel = 1;
for(i=1:size(idx, 1))
    segment = segments(idx(i), :);
    index = findNearestSegment(segment, originalSegments);
    if(index > 0)
        faults = faults + abs(originalSegments(index, 1) - segment(1));
        faults = faults + abs(originalSegments(index, 2) - segment(2));
        tmpOrg = [tmpOrg; originalSegments(index, :)];
        tmpOrg(end, 4) = slabel;
        tmpIn = [tmpIn; segments(idx(i), :)];
        tmpIn(end, 4) = slabel;
        originalSegments(index, :) = [];
        slabel = slabel +1;
    else
        faults = faults + segment(3);
        tmpIn = [tmpIn; segments(idx(i), :)];
        tmpIn(end, 4) = 0;
    end
end
if(size(originalSegments, 1) >0)
    faults = faults + sum(originalSegments(:, 3));
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

