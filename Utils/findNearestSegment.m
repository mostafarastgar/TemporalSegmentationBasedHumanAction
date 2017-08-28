function [ index ] = findNearestSegment( segment, segments )
maxInter = 0;
index = 0;
for(i=1:size(segments, 1))
    intersection = zeros(1, segments(end, 2));
    intersection(segment(1):segment(2)) = 1;
    intersection(segments(i, 1):segments(i, 2)) = intersection(segments(i, 1):segments(i, 2)) + 1;
    inter = sum(intersection(:) == 2);
    if(inter > maxInter)
        maxInter = inter;
        index = i;
    end
end
end

