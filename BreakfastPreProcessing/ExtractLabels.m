labels = {};
segments = {};
baseDirPrefix = '../data/break fast';
peopleDir = dir(baseDirPrefix);
peopleDir = {peopleDir.name};
for(i=3:size(peopleDir, 2))
    camPreDir = dir(strcat(baseDirPrefix, '/', peopleDir{i}));
    camPreDir = {camPreDir.name};
    for(j=3:size(camPreDir, 2))
        labelFiles = dir(strcat(baseDirPrefix, '/', peopleDir{i}, '/', camPreDir{j}, '/*.labels'));
        labelFiles = {labelFiles.name};
        for(k=1:size(labelFiles, 2))
            filePath = strcat(baseDirPrefix, '/', peopleDir{i}, '/', camPreDir{j}, '/', labelFiles{k});
            fid = fopen(filePath,'rt');
            C = textscan(fid, '%d-%d %s', 'Delimiter',' ');
            fclose(fid);
            C{1}(2:end) = C{1}(2:end)+1;
            parts = [];
            for(ii=1:size(C{3}, 1))
                [~, idx] = ismember(C{3}{ii}, labels);
                if(idx == 0)
                    labels{end+1, 1} = C{3}{ii};
                    idx = size(labels, 1);
                end
                parts = [parts;[C{1}(ii), C{2}(ii), idx]];
            end
            segments = [segments; {filePath(1:end-7), [i, j, k], parts}];
        end
    end
    display(['person', num2str(i), 'has been completed']);
end
save(strcat(baseDirPrefix, '/', 'labels.mat'), 'labels', '-v7.3');
save(strcat(baseDirPrefix, '/', 'segments.mat'), 'segments', '-v7.3');
