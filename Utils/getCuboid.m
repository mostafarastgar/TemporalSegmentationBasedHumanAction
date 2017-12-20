function [ cuboid ] = getCuboid( video, stip, cubeSize )
    cubeSize = floor(cubeSize / 2);
    boundaries = [stip(1)-cubeSize stip(1)+cubeSize;stip(2)-cubeSize stip(2)+cubeSize;stip(3)-cubeSize stip(3)+cubeSize];

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
        if(boundaries(3, 1)<1)
            boundaries(3, 1) = 1;
        end
        boundaries(3, 2) = size(video, 3);
    end
    
    cuboid = double(video(boundaries(1, 1):boundaries(1, 2), boundaries(2, 1):boundaries(2,2), boundaries(3,1):boundaries(3,2)))/255;
    if(size(cuboid, 1) ~= size(cuboid, 3))
        newCube = zeros(size(cuboid, 1), size(cuboid, 1), size(cuboid, 1));
        newCube(:, :, 1:size(cuboid, 3)) = cuboid;
        lastFrame = cuboid(:, :, end);
        for(k=size(cuboid, 3)+1:size(cuboid, 1))
            newCube(:, :, k) = lastFrame;
        end
        cuboid = newCube;
    end
end

