function [ results ] = KFoldObservation( k, windows, labels, segments, matDirPrefix )
test=[];
for(i=1:size(labels, 1))
    mkdir(strcat(matDirPrefix, 'clips/') , num2str(i));
end
for(i=1:size(segments, 1))
    for(j=1:size(segments{i, 3}, 1))
        save(strcat(matDirPrefix, 'clips/', num2str(segments{i, 3}(j, 3)),...
            '/', num2str(segments{i, 2}(1)), '_', num2str(segments{i, 2}(2)),...
            '_', num2str(segments{i, 2}(3)), '_', num2str(j), '.mat'), 'test', '-v7.3');
    end
end
opts = statset('Display', 'iter', 'MaxIter', 1500);
results = {};
randData = randi([0, 1], size(segments, 1), 1);
CV0=cvpartition(randData, 'k', k);
for(i=1:CV0.NumTestSets)
    disp(['>>>>>>starting iteration ', num2str(i)]);
    trIdx = find(CV0.training(i));
    teIdx = find(CV0.test(i));
    trainWindows = windows;
    for(j=1:size(teIdx, 1))
        for(k=1:size(segments{j, 3}, 1))
            files = dir(strcat(matDirPrefix, 'clips/', num2str(segments{j, 3}(k, 3)),...
                '/*.mat'));
            files = {files.name};
            found = 0;
            for(file_index=1:size(files, 2))
                if(strcmp(files{file_index}, strcat(num2str(segments{j, 2}(1)),...
                        '_', num2str(segments{j, 2}(2)), '_',...
                        num2str(segments{j, 2}(3)), '_', num2str(k), '.mat')))
                    found = 1;
                    break;
                end
            end
            if(found == 1)
                trainWindows(any(trainWindows(:, end-3) == segments{j, 3}(k, 3) & trainWindows(:, end-2) == file_index), :) = [];
            end
        end
    end
    disp(['>>>>>>starting kmeans on iteration', num2str(i), ' windows count is ', num2str(size(trainWindows, 1)), ' ', num2str(size(trIdx, 1))]);
    tic;
    [OIDXs,OCs,Osumds,ODs] = kmeans(trainWindows(:, 1:end -4),300,'Options',opts);
    toc;
    disp(['>>>>>>starting calculating fences on iteration', num2str(i)]);
    tic;
    fences = calculateFences(OIDXs,OCs,ODs);
    toc;
    disp(['>>>>>>starting generate sequences on iteration', num2str(i)]);
    tic;
    trainSequences = generateTrainSequences(trainWindows(:, end-3:end), OIDXs, ODs, fences);
    toc;
    
    results{i, 1} = teIdx;
    results{i, 2} = trainSequences;
    results{i, 3} = fences;
    results{i, 4} = OIDXs;
    results{i, 5} = OCs;
    results{i, 6} = Osumds;
    results{i, 7} = ODs;
    
    disp(['>>>>>>starting hmm train on iteration ', num2str(i)]);
    tic;
    results{i, 2}(:, 1) = results{i, 2}(:, 1) - 1;
    
    [ sequences, transmat, emisionmat, ESTTR, ESTEMIT ] = trainHMM(results{i, 2}, size(results{i, 5}, 1)+2, size(labels, 1)-1);
    toc;
    results{i, 8} = sequences;
    results{i, 9} = transmat;
    results{i, 10} = emisionmat;
    results{i, 11} = ESTTR;
    results{i, 12} = ESTEMIT;
    save(strcat(matDirPrefix, 'HMMData.mat'), 'results', '-v7.3');
end
end

