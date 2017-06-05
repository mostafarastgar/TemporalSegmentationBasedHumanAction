function [] = plot_hog3d( features, cell_size, theta_histogram_bins, phi_histogram_bins )
    %plot_hog3d plots the features defined by the hog3d. 
%
% features ::           a struct containing the the position of a block
%                       and a 3d matrix that holds the theta and phi 
%                       information for each cell in that block.
%                       Additionally holders are created to define if that
%                       feature represents a part of an object and defining
%                       marker.
%
% cell_size ::          size in voxels of a cell in one axis. 
%
% theta_histogram_bins ::  the number of bins to break the angles in the xy
%                       plane. 180 degrees. (MUST BE THE SAME AS USED IN
%                       FEATURE DEFINITION (hog3d))
%
% phi_histogram_bins :: the number of bins to break the angles in the xz
%                       plane. 360 degrees. (MUST BE THE SAME AS USED IN
%                       FEATURE DEFINITION (hog3d))
%

[num_features] = length(features);
[num_cells_per_block, ~] = size([features().Features]);
his_theta = theta_histogram_bins; his_phi = phi_histogram_bins;

x = zeros(1,2); y = zeros(1,2); z = zeros(1,2);

half_vox_per_cell = cell_size / 2;
block_dimension = nthroot(num_cells_per_block,3);


%FOR EACH BLOCK
for i = 1: num_features,
    %IF FEATURE IS NOT EMPTY
    if(sum(sum(features(i).Features)) ~= 0)
        %FOR EACH CELL IN THE BLOCK
        for j = 1: num_cells_per_block,
            %GET THE CELL IND AND TAKE THAT CELLS FEATURE
            [cell_x, cell_y, cell_z] = ind2sub([block_dimension, block_dimension, block_dimension],j);
            temp = reshape(features(i).Features, num_cells_per_block, his_theta, his_phi);
            %FOR THE VARIOUS ANGLES
            for k = 1: his_theta,
                for l = 1: his_phi,
                    %GET THE VALUE FOR HISTORGRAM BIN IF ITS GREATER THAN
                    %THE THRESHOLD THEN DISPLAY IT. THRESHOLD FOUND THROUGH
                    %ANALYSIS OF alpha. MAY NEED ADJUSTMENTS BASED ON YOUR
                    %DATA.
                    alpha = temp(j,k,l);
                    if (alpha > 1.49011611938477e-08)
                        
                        %GET THE x,y,z COORDINATES AND THE INTENDED ALPHA
                        x(2) = (1 * sin(k * (pi/his_theta)) * cos(l * ((2*pi)/his_phi)));
                        y(2) = (1 * sin(k * (pi/his_theta)) * sin(l * ((2*pi)/his_phi)));
                        z(2) = (1 * cos(k * (pi/his_theta)));
                        x(1) = -x(2);
                        y(1) = -y(2);
                        z(1) = -z(2);

                        %CREATE AN OFFSET BASED ON WHICH CELL ITS IN TAKEN FROM STRUCT INPUT.
                        x_offset = features(i).Position(1) +  (half_vox_per_cell + ((cell_x - 1) * (half_vox_per_cell*2)));
                        y_offset = features(i).Position(2) +  (half_vox_per_cell + ((cell_y - 1) * (half_vox_per_cell*2)));
                        z_offset = features(i).Position(3) +  (half_vox_per_cell + ((cell_z - 1) * (half_vox_per_cell*2)));

                        %SCALE THE THE VECTORS AND ADD OFFSETS
                        x = (x * half_vox_per_cell)  + x_offset;
                        y = (y * half_vox_per_cell)  + y_offset;
                        z = (z * half_vox_per_cell)  + z_offset;

                        %PLOT
                        hold on;
                        if(alpha < 0) 
                            alpha = 0;
                        elseif(alpha > 0)
                            %alpha = 1;
                        elseif (alpha > 1)
                            alpha = 1;
                        end
                        fig = patch(x, y, z, 'r.', 'EdgeAlpha', alpha, 'FaceColor', 'none');
                        set(fig, 'LineWidth', 4);
                        set(fig, 'LineStyle', '-');
                    end
                end
            end
        end
    end
end
end