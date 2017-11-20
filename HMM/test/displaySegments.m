function [  ] = displaySegments( originalSegments, segments )
img = zeros(50, max(originalSegments(:, end - 2)), 3);
colors = [178,34,34;159,182,205;61,145,64;209,95,238;205,205,0;72,118,205;238,232,170;139,117,0;205,186,150;180,205,205;205,96,144;0,0,205;183,183,183;93,71,139;142,56,142;176,226,255;197,193,170;220,20,60;95,158,160;218,112,214;113,113,198;176,23,31;255,64,64;139,0,0;125,158,192;238,180,34;51,61,201;110,123,139;0,205,102;16,78,139;85,85,85;128,38,205;56,142,142;0,139,69;139,123,139;48,128,20;85,107,47;0,245,255;139,131,134;255,246,143];
colors = colors/255.0;
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

