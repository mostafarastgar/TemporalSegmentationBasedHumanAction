segments = load('../data/break fast/segments.mat');
segments = segments.segments;
labels = load('../data/break fast/labels.mat');
labels = labels.labels;
baseDir = '../data/break fast/clips/';
for(i=1:size(labels, 1))
    mkdir(strcat(baseDir, num2str(i), '-', labels{i}));
end
for(i=1:size(segments, 1))
    obj = VideoReader(segments{i, 1});
    mov = read(obj);
    removes = [];
    for(j=1:size(segments{i, 3}, 1))
        if(segments{i, 3}(j, 1) ~= segments{i, 3}(j, 2) && segments{i, 3}(j, 1)<segments{i, 3}(j, 2)... 
            && segments{i, 3}(j, 1)<size(mov, 4))
            if(segments{i, 3}(j, 2)>size(mov, 4))
                seg = mov(:, :, :, segments{i, 3}(j, 1):end);
                segments{i, 3}(j, 2) = size(mov, 4);
            else
                seg = mov(:, :, :, segments{i, 3}(j, 1):segments{i, 3}(j, 2));
            end
            fileName = strcat(baseDir, num2str(segments{i, 3}(j, 3)), '-', labels{segments{i, 3}(j, 3)}, ...
                '/', num2str(segments{i, 2}(1)), '_', num2str(segments{i, 2}(2)), ...
                '_', num2str(segments{i, 2}(3)), '_', num2str(j), '.avi');
            aviObj = VideoWriter(fileName, 'Uncompressed AVI');
            open(aviObj);
            writeVideo(aviObj,seg);
            close(aviObj);
        else
            removes = [removes j];
        end
    end
    segments{i, 3}(removes, :) = [];
    disp([num2str(i), 'has been completed']);
end
correctSegments = segments;
save('../data/break fast/correctSegments.mat', 'correctSegments', '-v7.3');
