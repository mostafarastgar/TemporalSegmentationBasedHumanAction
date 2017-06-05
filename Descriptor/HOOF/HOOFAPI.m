function [ HOOFfeatures ] = HOOFAPI( video, stips, binSize, cubeSize )
HOOFfeatures = zeros(size(stips, 1), binSize * 8);
for(i=1:size(stips, 1))
    cuboid = getCuboid(video, stips(i, :), cubeSize);
    [VX, VY] = OpticalFlow(cuboid, 30,1);
    sz = size(VX);
    hoof = zeros(binSize, sz(3));
    for k = 1 : sz(3)
        hoof(:, k) = gradientHistogram(VX(:,:,k), VY(:,:,k), binSize);
    end
    HOOFfeatures(i, :) = reshape(hoof, 1, binSize * sz(3));
end
end

