%LOAD IN THE DATA
% load('Example_Data');

%RUN HOG3D WITH EACH CELL MADE UP OF 8x8x8 VOXELS, IN BLOCKS MADE UP OF
%4x4x4 CELLS WITH AN OVERLAP OF 2 CELLS FOR THE BLOCK POSITIONS.
stips = demo_selective_stip(0, video);
tic;
binSize = 8*162;
HOG3DFeatures = zeros(size(stips, 1), binSize);
for(i=1:size(stips, 1))
    cuboid = getCuboid(video, stips(i, :), 9);
    theta_histogram_bins = 9;
    phi_histogram_bins = 18;
    cell_size = 4;
    block_size = 2;
    step_size = 2;
    features = hog3d(double(cuboid)/255, cell_size, block_size, theta_histogram_bins, phi_histogram_bins, step_size, 0);
    HOG3DFeatures(i, :) = reshape(features.Features, 1, binSize);
end
toc;
% plot_hog3d(features, cell_size, theta_histogram_bins, phi_histogram_bins);
% view([45,45]);