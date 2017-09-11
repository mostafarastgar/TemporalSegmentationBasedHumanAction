function [ HOG3DFeatures ] = HOG3DAPI(video, stips, binSize, cubeSize)
HOG3DFeatures = zeros(size(stips, 1), binSize);
for(i=1:size(stips, 1))
    cuboid = getCuboid(video, stips(i, :), cubeSize);
    theta_histogram_bins = 8;
    phi_histogram_bins = 8;
    cell_size = 4;
    block_size = 2;
    step_size = 2;
    features = hog3d(double(cuboid)/255, cell_size, block_size, theta_histogram_bins, phi_histogram_bins, step_size, 0);
    HOG3DFeatures(i, :) = reshape(features.Features, 1, binSize);
end
end
