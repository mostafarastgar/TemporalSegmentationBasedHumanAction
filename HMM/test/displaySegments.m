function [  ] = displaySegments( originalSegments, segments, colors)
img = zeros(50, max(originalSegments(:, end - 2)), 3);
for(i=1:size(originalSegments, 1))
   img(1:20, originalSegments(i, 1):originalSegments(i, 2), 1) = colors(originalSegments(i, end), 1);
   img(1:20, originalSegments(i, 1):originalSegments(i, 2), 2) = colors(originalSegments(i, end), 2);
   img(1:20, originalSegments(i, 1):originalSegments(i, 2), 3) = colors(originalSegments(i, end), 3);
end
img(21:30, :, 1) = 255;
img(21:30, :, 2) = 255;
img(21:30, :, 3) = 255;
for(i=1:size(segments, 1))
   img(31:50, segments(i, 1):segments(i, 2), 1) = colors(segments(i, end), 1);
   img(31:50, segments(i, 1):segments(i, 2), 2) = colors(segments(i, end), 2);
   img(31:50, segments(i, 1):segments(i, 2), 3) = colors(segments(i, end), 3);
end
imshow(img);
end

