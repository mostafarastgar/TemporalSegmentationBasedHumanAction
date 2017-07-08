function [ index ] = findNearestSegment( segment, originalSegments )
maxInter = 0;
index = 0;
for(i=1:size(originalSegments, 1))
    intersection = zeros(1, originalSegments(end, 2));
    intersection(segment(1):segment(2)) = 1;
    intersection(originalSegments(i, 1):originalSegments(i, 2)) = intersection(originalSegments(i, 1):originalSegments(i, 2)) + 1;
    inter = sum(intersection(:) == 2);
    if(inter > maxInter)
        maxInter = inter;
        index = i;
    end
end
end

