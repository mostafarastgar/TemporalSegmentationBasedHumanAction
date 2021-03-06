% features = pcakmeansfeatures.mat
function [ sequences, transmat, emisionmat, ESTTR, ESTEMIT ] = trainHMM(trainSequences, trainWindows, O, maxClassNo)
Q = 3*maxClassNo+1;
finalInitStateIndex = (maxClassNo-1)*3+2;
emisionmat = zeros(Q, O);
finalBeginningIndices = [];
maxFileIndex = max(trainSequences(:, 2));
opts = statset('Display', 'iter', 'MaxIter', 1500);
for(i=2:3:finalInitStateIndex)
    classNo = ceil((i-1)/3);
    beginningIndices = [];
    middleIndices = [];
    endIndices = [];
    for(j=1:maxFileIndex)
        indices = trainSequences(any(trainSequences(:, 1)==classNo, 2) & any(trainSequences(:, 2)==j, 2), 5);
        sizeOfIndices = size(indices, 1);
        if(sizeOfIndices>0)
            init_end=1;
            end_first=sizeOfIndices;
            if(sizeOfIndices>3)
                windows = trainWindows(any(trainWindows(:, end-3)==classNo, 2) & any(trainWindows(:, end-2)==j, 2), :);
                IDX = kmeans(windows(:, 1:end-4), 3, 'Options', opts);
                for(k=2:sizeOfIndices)
                    if(IDX(k-1) ~= IDX(k))
                        init_end = k-1;
                        break;
                    end
                end
                for(k=sizeOfIndices:-1:2)
                    if(IDX(k-1) ~= IDX(k))
                        end_first=k;
                        break;
                    end
                end
            end
            beginningIndices = [beginningIndices;indices(1:init_end)];
            middleIndices = [middleIndices;indices(init_end+1:end_first-1)];
            endIndices = [endIndices;indices(end_first:end)];
            disp(['i: ', num2str(i), ' j: ', num2str(j)]);
        end
    end
    finalBeginningIndices = [finalBeginningIndices; beginningIndices];
    uniqueValues = unique(beginningIndices(:));
    numberOfElement = size(beginningIndices, 1);
    for(j=1:size(uniqueValues, 1))
        emisionmat(i, uniqueValues(j)) = sum(beginningIndices(:) == uniqueValues(j))/numberOfElement;
    end
    
    uniqueValues = unique(middleIndices(:));
    numberOfElement = size(middleIndices, 1);
    for(j=1:size(uniqueValues, 1))
        emisionmat(i+1, uniqueValues(j)) = sum(middleIndices(:) == uniqueValues(j))/numberOfElement;
    end
    
    uniqueValues = unique(endIndices(:));
    numberOfElement = size(endIndices, 1);
    for(j=1:size(uniqueValues, 1))
        emisionmat(i+2, uniqueValues(j)) = sum(endIndices(:) == uniqueValues(j))/numberOfElement;
    end
end
uniqueValues = unique(finalBeginningIndices(:));
numberOfElement = size(finalBeginningIndices, 1);
for(j=1:size(uniqueValues, 1))
    emisionmat(1, uniqueValues(j)) = sum(finalBeginningIndices(:) == uniqueValues(j))/numberOfElement;
end

prior = zeros(1, 3*maxClassNo);
prior(1, 1:3:end-2)= 1/maxClassNo;
transmat = zeros(3*maxClassNo, 3*maxClassNo);
transmat(3:3:end, 1:3:finalInitStateIndex-1) = 0.5/maxClassNo;
for(i=1:3:finalInitStateIndex-1)
    transmat(i, i) = 0.5;
    transmat(i, i+1) = 0.5;
    transmat(i+1, i+1) = 0.5;
    transmat(i+1, i+2) = 0.5;
    transmat(i+2, i+2) = 0.5;
end
transmat = [prior;transmat];
transmat = [zeros(Q, 1) transmat];

sequences = {};
lastIndex = 1;
for(classNo=1:maxClassNo)
    for(i=1:400)
        sequence = trainSequences(any(trainSequences(:, 1)==classNo, 2) & any(trainSequences(:, 2)==i, 2), :);
        noOfObservations = size(sequence, 1);
        if(noOfObservations > 0)
            sequences{lastIndex} = transpose(sequence(:, 5));
            lastIndex = lastIndex + 1;
        end
    end
end
% [ESTTR, ESTEMIT] = hmmtrain(sequences, transmat, emisionmat, 'Maxiterations', 10);
% [ESTTR, ESTEMIT] = hmmtrain(sequences, transmat, emisionmat);
% ESTTR(1, :) = transmat(1, :);
% ESTTR(4:3:end, :) = transmat(4:3:end, :);
% ESTEMIT(1, :) = emisionmat(1, :);

% ESTTR(:, :) = ESTTR(:, :)*0.5;
% ESTTR = [ESTTR zeros(Q, 1)+0.5];
% ESTTR = [ESTTR;zeros(1, Q+1)];
% ESTTR(end, 2:3:finalInitStateIndex) = 0.5/maxClassNo;
% ESTTR(end, end) = 0.5;
transmat(:, :) = transmat(:, :)*0.5;
transmat = [transmat zeros(Q, 1)+0.5];
transmat = [transmat;zeros(1, Q+1)];
transmat(end, 2:3:finalInitStateIndex) = 0.5/maxClassNo;
transmat(end, end) = 0.5;

% ESTEMIT = [ESTEMIT; zeros(1, O)];
% ESTEMIT(end, end-1) = 0.2;
% ESTEMIT(end, end) = 0.8;
emisionmat = [emisionmat; zeros(1, O)];
emisionmat(end, end-1) = 0.2;
emisionmat(end, end) = 0.8;

% [ESTTR, ESTEMIT] = hmmtrain(sequences, transmat, emisionmat, 'Maxiterations', 10);
ESTTR = transmat;
ESTEMIT = emisionmat;
end