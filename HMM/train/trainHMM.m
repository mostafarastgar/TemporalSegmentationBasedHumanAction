% features = pcakmeansfeatures.mat
function [ sequences, transmat, emisionmat, ESTTR, ESTEMIT ] = trainHMM(trainSequences, O, Q, maxClassNo)
emisionmat = zeros(Q, O);
maxVecotorsPerFile = 0;
fileSize = 0;
finalBeginningIndices = [];
for(i=2:3:17)
    classNo = ceil((i-1)/3);
    beginningIndices = [];
    middleIndices = [];
    endIndices = [];
    for(j=1:400)
        indices = trainSequences(any(trainSequences(:, 1)==classNo, 2) & any(trainSequences(:, 2)==j, 2), 5);
        sizeOfIndices = size(indices, 1);
        if(sizeOfIndices>0)
            miniSize = round(sizeOfIndices/4);
            beginningIndices = [beginningIndices;indices(1:miniSize)];
            middleIndices = [middleIndices;indices(miniSize+1:end-miniSize)];
            endIndices = [endIndices;indices(end-miniSize+1:end)];
            if(sizeOfIndices>maxVecotorsPerFile)
                maxVecotorsPerFile = sizeOfIndices;
            end
            fileSize = fileSize + 1;
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

prior = [1/6 0 0 1/6 0 0 1/6 0 0 1/6 0 0 1/6 0 0 1/6 0 0];
transmat = [0.500000000000000,0.500000000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0,0.500000000000000,0.500000000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0.100000000000000,0,0.400000000000000,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0;...
    0,0,0,0.500000000000000,0.500000000000000,0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0,0,0,0,0.500000000000000,0.500000000000000,0,0,0,0,0,0,0,0,0,0,0,0;...
    0.100000000000000,0,0,0.100000000000000,0,0.400000000000000,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0;...
    0,0,0,0,0,0,0.500000000000000,0.500000000000000,0,0,0,0,0,0,0,0,0,0;...
    0,0,0,0,0,0,0,0.500000000000000,0.500000000000000,0,0,0,0,0,0,0,0,0;...
    0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0.400000000000000,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0;...
    0,0,0,0,0,0,0,0,0,0.500000000000000,0.500000000000000,0,0,0,0,0,0,0;...
    0,0,0,0,0,0,0,0,0,0,0.500000000000000,0.500000000000000,0,0,0,0,0,0;...
    0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0.400000000000000,0.100000000000000,0,0,0.100000000000000,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0.500000000000000,0.500000000000000,0,0,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0.500000000000000,0.500000000000000,0,0,0;...
    0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0.400000000000000,0.100000000000000,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.500000000000000,0.500000000000000,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.500000000000000,0.500000000000000;...
    0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0,0.100000000000000,0,0.400000000000000];
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
% [ESTTR, ESTEMIT] = hmmtrain(sequences, transmat, emisionmat, 'Maxiterations', 250);
[ESTTR, ESTEMIT] = hmmtrain(sequences, transmat, emisionmat);
ESTTR(1, :) = transmat(1, :);
ESTEMIT(1, :) = emisionmat(1, :);

ESTTR(:, :) = ESTTR(:, :)*0.5;
ESTTR = [ESTTR zeros(Q, 1)+0.5];
ESTTR = [ESTTR;zeros(1, Q+1)];
ESTTR(end, 2:end-1) = 0.5/(Q-1);
ESTTR(end, end) = 0.5;
transmat(:, :) = transmat(:, :)*0.5;
transmat = [transmat ESTTR(1:end-1, end)];
transmat = [transmat; ESTTR(end, :)];

ESTEMIT = [ESTEMIT; zeros(1, O)];
ESTEMIT(end, end-1) = 0.2;
ESTEMIT(end, end) = 0.8;
emisionmat = [emisionmat; ESTEMIT(end, :)];
end