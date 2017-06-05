%LOAD IN THE DATA
% load('Example_Data');

%RUN HOG3D WITH EACH CELL MADE UP OF 8x8x8 VOXELS, IN BLOCKS MADE UP OF
%4x4x4 CELLS WITH AN OVERLAP OF 2 CELLS FOR THE BLOCK POSITIONS.
stips = demo_selective_stip(0, video);
tic;
features = [];
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
    theta_histogram_bins = 9;
    phi_histogram_bins = 18;
    cell_size = 4;
    block_size = 2;
    step_size = 2;
    features = [features; hog3d(double(cuboid)/255, cell_size, block_size, theta_histogram_bins, phi_histogram_bins, step_size, 0)];
end
toc;
% plot_hog3d(features, cell_size, theta_histogram_bins, phi_histogram_bins);
% view([45,45]);