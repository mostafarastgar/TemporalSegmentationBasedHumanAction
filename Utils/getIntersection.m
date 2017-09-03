function [ inter ] = getIntersection( originalSegment, segment )
intersection = zeros(1, segment(2));
intersection(originalSegment(1):originalSegment(2)) = 1;
intersection(segment(1):segment(2)) = intersection(segment(1):segment(2)) + 1;
inter = sum(intersection(:) == 2);
end

