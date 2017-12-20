baseDir = '../data/MPII/clips/';
classes = unique(metaData{1, 5});
labels = {};
for(i=1:size(classes, 1))
    mkdir(strcat(baseDir, num2str(classes(i))));
    index = find(metaData{1, 5} == classes(i));
    labels{classes(i), 1} = metaData{1, 6}{index(1)};
end
save('../data/MPII/labels.mat', 'labels', '-v7.3');
movies = unique(metaData{1, 2});
correctSegments = {};
for(i=1:size(movies, 1))
    obj = VideoReader(strcat('../data/MPII/videos/', movies{i}, '.avi'));
    indices = find(strcmp(metaData{1, 2}, movies{i}) == 1);
    for(j=1:size(indices, 1))
        if(metaData{1, 5}(indices(j)) ~= 1)
            segment = read(obj, [metaData{1, 3}(indices(j)) metaData{1, 4}(indices(j))]);
            fileName = strcat(baseDir, num2str(metaData{1, 5}(indices(j))), ...
                '/', metaData{1, 2}(indices(j)), '_', num2str(metaData{1, 3}(indices(j))), ...
                '_', num2str(metaData{1, 4}(indices(j))), '.avi');
            aviObj = VideoWriter(fileName{1}, 'Motion JPEG AVI');
            open(aviObj);
            writeVideo(aviObj,segment);
            close(aviObj);
        end
        disp([num2str(j), ' of ', num2str(size(indices, 1))]);
    end
    correctSegments{i, 1} = movies{i};
    correctSegments{i, 2} = [];
    correctSegments{i, 3} = [metaData{1, 3}(indices) metaData{1, 4}(indices) metaData{1, 5}(indices)];
    disp([num2str(i), 'has been completed']);
end
save('../data/MPII/correctSegments.mat', 'correctSegments', '-v7.3');

