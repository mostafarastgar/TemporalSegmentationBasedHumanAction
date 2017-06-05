function [ features ] = hog3d( vox_volume, cell_size, block_size, theta_histogram_bins, phi_histogram_bins, step_size, display)
%hog3d 3D Voxel HOG (3D VHOG) is based on the original Histogram of
%Oriented Gradients "Pedestrian Detection using Histogram of Oriented
%Gradients" By Dalal and Triggs. It extends the method by using voxels
%over pixels and expands the original histograms into 2 dimensions.
%This implementation was developed for local object structure detection,
%for use in a risk analysis framework (see Paper Below) in which it is
%used to classify risk related properties of an object (sharp edges,
%points etc). However the feature has also been used successfully in
%face detection problems.

%If used please reference the following paper
%Rob Dupre, Vasileios Argyriou, D. Greenhill, Georgios Tzimiropoulos:
%A 3D Scene Analysis Framework and Descriptors for Risk Evaluation.
%3DV 2015: 100-108

%
% vox_volume ::             a [n x n x n] matrix defining voxels with
%                           values in the range of 0 - 1.
%
% cell_size ::              spacial size of a 3d cell (integer)
%
% block_size ::             spacial size of a 3d block defined in cells
%                           (interger)
%
% theta_histogram_bins ::   the number of bins to break the angles in the xy
%                           plane. 180 degrees.
%
% phi_histogram_bins ::     the number of bins to break the angles in the xz
%                           plane. 360 degrees
%
% step_size ::              OPTIONAL integer defining number of cells
%                           blocks should overlap by. If same or larger than
%                           block_size, blocks will not overlap.
%
% features ::               a struct containing the the position of a block
%                           and a 3d matrix that holds the theta and phi
%                           information for each cell in that block.
%                           Additionally holders are created to define if that
%                           feature represents a part of an object and defining
%                           marker.
%

%CONVERT vox_volume FROM A LOGIC ARRAY
vox_volume =+vox_volume;

%IF STEPSIZE HAS NOT BE DEFINED SET TO THE WIDTH OF THE BLOCKS. REPRESENTS
%NO OVERLAP IN THE BLOCKS
if(nargin< 6)
    step_size = block_size;
end

%CELL SIZE IN VOXELS
c_size = cell_size;
%BLOCK SIZE IN CELLS
b_size = block_size;

features = struct('Position',[], 'CellPositions', [], 'Features', []);

%GET VOLUME SIZE
[sx, sy, sz] = size(vox_volume);

%GET CELL POSITIONS
num_x_cells = floor(sx / cell_size);
num_y_cells = floor(sy / cell_size);
num_z_cells = floor(sz / cell_size);

x_cell_positions = 1:cell_size:(num_x_cells*c_size);
y_cell_positions = 1:cell_size:(num_y_cells*c_size);
z_cell_positions = 1:cell_size:(num_z_cells*c_size);

%GET THE BLOCK POSITIONS BASED ON THE STEP SIZE.
x_blk_pos = x_cell_positions(1:step_size:num_x_cells);
y_blk_pos = y_cell_positions(1:step_size:num_y_cells);
z_blk_pos = z_cell_positions(1:step_size:num_z_cells);

%ENSURES THAT THE LAST BLOCK START POSITION IN THE x y z DIMENSIONS LEAVES
%ENOUGH VOXELS TO BE A FULL BLOCK.
if(x_blk_pos(end) > ((sx+1) - (cell_size * block_size)))
    x_blk_pos = x_blk_pos(1:(end-1));
end
if(y_blk_pos(end) > ((sy+1) - (cell_size * block_size)))
    y_blk_pos = y_blk_pos(1:(end-1));
end
if(z_blk_pos(end) > ((sz+1) - (cell_size * block_size)))
    z_blk_pos = z_blk_pos(1:(end-1));
end

%WORK OUT NUMBER OF BLOCKS IN EACH DIMENSION
num_x_blocks = length(x_blk_pos);
num_y_blocks = length(y_blk_pos);
num_z_blocks = length(z_blk_pos);

blk_inds = zeros((num_x_blocks * num_y_blocks * num_z_blocks), 3);
for i = 1: (num_x_blocks * num_y_blocks * num_z_blocks),
    [x, y, z] = ind2sub([num_x_blocks num_y_blocks num_z_blocks], i);
    blk_inds(i,:) = [x_blk_pos(x), y_blk_pos(y), z_blk_pos(z)];
end
[num_blocks, ~] = size(blk_inds);

%CREATE 3D GRADIENT VECTORS
%X FILTER AND VECTOR COMPONENT
filter = zeros(3,3,3);
filter(1,2,2) = 1; filter(3,2,2) = -1;
x_vector = imfilter(vox_volume, filter, 0, 'same', 'conv');
%Y FILTER AND VECTOR COMPONENT
filter = zeros(3,3,3);
filter(2,1,1) = 1; filter(2,3,1) = -1;
y_vector = imfilter(vox_volume, filter, 0, 'same', 'conv');
%Z FILTER AND VECTOR COMPONENT
filter = zeros(3,3,3);
filter(2,2,1) = 1; filter(2,2,3) = -1;
z_vector = imfilter(vox_volume, filter, 0, 'same', 'conv');

%GET MAGNITUTE OF EACH VECTOR
magnitudes = sqrt((x_vector).^2 + (y_vector).^2 + (z_vector).^2);

%GET A WEIGHTING FOR EACH VOXEL BASED ON THE VOXELS AROUND IT
kernel_size = 3;
filter = zeros(kernel_size, kernel_size, kernel_size);
filter(:) = 1 / (kernel_size*kernel_size*kernel_size);
weights = imfilter(vox_volume, filter, 0, 'same', 'conv');
weights = weights + 1;

%BUILD THE 3D VECTORS 4D ARRAY
grad_vector = zeros(sx,sy,sz,3);
for i = 1: sx,
    for j = 1: sy,
        for k = 1: sz,
            grad_vector(i,j,k,1) = x_vector(i,j,k);
            grad_vector(i,j,k,2) = y_vector(i,j,k);
            grad_vector(i,j,k,3) = z_vector(i,j,k);
        end
    end
end

%THETA ANGLE FROM THE Z AND RADIUS PLANE IN [0 pi]. WHY DIVIDE BY MAGNITUDE
theta = acos(grad_vector(:,:,:,3));
%ADD SMALL INCREMENT OTHERWISE 0 ANGLES WILL NOT REGISTER WITH A BIN.
theta(theta == 0) = eps;
%PHI ANGLE FROM THE X Y PLANE IN [0 2pi]
phi = atan2(grad_vector(:,:,:,2), grad_vector(:,:,:,1));
phi = phi + pi;

%BINNING
%SIZE OF BLOCK IN VOXELS
b_size_voxels = c_size * b_size;
%BIN SIZE
t_hist_bins = (pi)/theta_histogram_bins;
p_hist_bins = (2*pi)/phi_histogram_bins;

error_count = 0;
for i = 1: num_blocks,
    %     fprintf_r('Processing Block: %i of %i', [i, num_blocks]);
    if(i == 1793)
        disp('HERE');
    end
    %FEATURE STRUCTURE
    feature = zeros((b_size*b_size*b_size), (theta_histogram_bins*phi_histogram_bins));
    full_empty = vox_volume(blk_inds(i,1):(blk_inds(i,1)+b_size_voxels-1), blk_inds(i,2):(blk_inds(i,2)+b_size_voxels-1), blk_inds(i,3):(blk_inds(i,3)+b_size_voxels-1));
    
    if (sum(sum(sum(full_empty))) ~= 0 && sum(sum(sum(full_empty))) ~= numel(full_empty))
        feature = zeros(b_size, b_size, b_size, theta_histogram_bins, phi_histogram_bins);
        %GET THE THETA, PHI, WEIGHT AND MAGNITUTES FOR THE BLOCK
        t_weights    =    weights(blk_inds(i,1):(blk_inds(i,1)+b_size_voxels-1), blk_inds(i,2):(blk_inds(i,2)+b_size_voxels-1), blk_inds(i,3):(blk_inds(i,3)+b_size_voxels-1));
        t_magnitudes = magnitudes(blk_inds(i,1):(blk_inds(i,1)+b_size_voxels-1), blk_inds(i,2):(blk_inds(i,2)+b_size_voxels-1), blk_inds(i,3):(blk_inds(i,3)+b_size_voxels-1));
        t_theta      =      theta(blk_inds(i,1):(blk_inds(i,1)+b_size_voxels-1), blk_inds(i,2):(blk_inds(i,2)+b_size_voxels-1), blk_inds(i,3):(blk_inds(i,3)+b_size_voxels-1));
        t_phi        =        phi(blk_inds(i,1):(blk_inds(i,1)+b_size_voxels-1), blk_inds(i,2):(blk_inds(i,2)+b_size_voxels-1), blk_inds(i,3):(blk_inds(i,3)+b_size_voxels-1));
        
        for l = 1: b_size_voxels,
            for m = 1: b_size_voxels,
                for n = 1: b_size_voxels,
                    %feature WILL HOLD A 2D HISTORGRAMS (nx1:9 AND nx10:27)
                    %ABOUT EACH CELL OF THE BLOCK
                    %FIND THE CELL THAT THIS VOXEL SITS IN
                    cell_pos_x = ceil(l / c_size);
                    cell_pos_y = ceil(m / c_size);
                    cell_pos_z = ceil(n / c_size);
                    %ASSIGN THE GRADIENT ANGLE TO THE CORRESPONDING BIN
                    hist_pos_theta = ceil(t_theta(l,m,n)/t_hist_bins);
                    hist_pos_phi = ceil(t_phi(l,m,n)/p_hist_bins);
                    %CHECK THAT THE VALUES FALL INTO ONE OF THE DEFINED
                    %BINS
                    if (hist_pos_phi <= phi_histogram_bins && hist_pos_theta <= theta_histogram_bins && hist_pos_phi > 0 && hist_pos_theta > 0)
                        %UPDATE THE 2D HISTOGRAM
                        feature(cell_pos_x,cell_pos_y,cell_pos_z, hist_pos_theta, hist_pos_phi) = feature(cell_pos_x,cell_pos_y,cell_pos_z, hist_pos_theta, hist_pos_phi)...
                            + (t_magnitudes(l,m,n) * t_weights(l,m,n));
                    else
                        error_count = error_count + 1;
                    end
                end
            end
        end
        %RESHAPE feature INTO A n X m ARRAY OF CELLS AND THEIR
        %HISTOGRAMS FOR NORMALISATION (L2)
        feature = reshape(feature,(b_size*b_size*b_size), theta_histogram_bins, phi_histogram_bins);
        t_feature = feature(:);
        feature = (feature+eps)./ sqrt((sum(t_feature.*t_feature))+eps);
        %RESHAPE INTO 162 DIMENSION FEATURE
        feature = reshape(feature,(b_size*b_size*b_size), (theta_histogram_bins*phi_histogram_bins));
    end
    
    %GET THE CELL POSITIONS(NOT REQUIRED FOR ANYTHING SPECIFIC.)
    cell_positions = zeros(b_size*b_size*b_size,3);
    for t = 1: b_size*b_size*b_size,
        [l, m, n] = ind2sub([b_size, b_size, b_size],t);
        x = blk_inds(i,1) + (c_size * (l-1)); y = blk_inds(i,2) + (c_size * (m-1)); z = blk_inds(i,3) + (c_size * (n-1));
        cell_positions(t, 1:3) = [x y z];
    end
    %POPULATE THE STRUCT
    features(i).Features = feature;
    features(i).Position = blk_inds(i,:);
    features(i).CellPositions = cell_positions;
    
end
if(display)
    disp('NO OF VALUES THAT DIDNT FIT INTO A DEFINED BIN');
    disp(error_count);
    disp('FEATURES DEFINED');
end
end