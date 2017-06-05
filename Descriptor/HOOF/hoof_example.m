stips = demo_selective_stip(0, video);
tic;
binSize = 32;
HOOFfeatures = zeros(size(stips, 1), binSize * 8);
for(i=1:size(stips, 1))
    boundaries = [stips(i, 1)-4 stips(i, 1)+4;stips(i, 2)-4 stips(i, 2)+4;stips(i, 3)-4 stips(i, 3)+4];
    
    boundaries(boundaries(:, 1)<1, 2) = boundaries(boundaries(:, 1)<1, 2) - boundaries(boundaries(:, 1)<1, 1) + 1;
    boundaries(boundaries(:, 1)<1, 1) = 1;
    
    if(boundaries(1, 2)> size(video, 1))
        boundaries(1, 1) = boundaries(1, 1) - (boundaries(1, 2) - size(video, 1));
        boundaries(1, 2) = size(video, 1);
    end
    
    if(boundaries(2, 2)> size(video, 2))
        boundaries(2, 1) = boundaries(2, 1) - (boundaries(2, 2) - size(video, 2));
        boundaries(2, 2) = size(video, 2);
    end
    
    if(boundaries(3, 2)> size(video, 3))
        boundaries(3, 1) = boundaries(3, 1) - (boundaries(3, 2) - size(video, 3));
        boundaries(3, 2) = size(video, 3);
    end
    
    cuboid = double(video(boundaries(1, 1):boundaries(1, 2), boundaries(2, 1):boundaries(2,2), boundaries(3,1):boundaries(3,2)))/255;
    [VX, VY] = OpticalFlow(cuboid, 30,1);
    sz = size(VX);
    hoof = zeros(binSize, sz(3));
    for k = 1 : sz(3)
        hoof(:, k) = gradientHistogram(VX(:,:,k), VY(:,:,k), binSize);
    end
    HOOFfeatures(i, :) = reshape(hoof, 1, binSize * sz(3));
end
toc;
