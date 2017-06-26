% features = pcakmeansfeatures.mat
function [ sequences, ESTTR,ESTEMIT ] = trainHMM(trainSequences, O, maxClassNo, randomSizePerClass)
Q = 19;
ESTEMIT = zeros(Q, O);
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
    numberOfElement = numel(uniqueValues);
    for(j=1:numberOfElement)
        ESTEMIT(i, uniqueValues(j)) = sum(beginningIndices(:) == uniqueValues(j))/numberOfElement;
    end
    
    uniqueValues = unique(middleIndices(:));
    numberOfElement = numel(uniqueValues);
    for(j=1:numberOfElement)
        ESTEMIT(i+1, uniqueValues(j)) = sum(middleIndices(:) == uniqueValues(j))/numberOfElement;
    end
    
    uniqueValues = unique(endIndices(:));
    numberOfElement = numel(uniqueValues);
    for(j=1:numberOfElement)
        ESTEMIT(i+2, uniqueValues(j)) = sum(endIndices(:) == uniqueValues(j))/numberOfElement;
    end
end
uniqueValues = unique(finalBeginningIndices(:));
numberOfElement = numel(uniqueValues);
for(j=1:numberOfElement)
    ESTEMIT(1, uniqueValues(j)) = sum(finalBeginningIndices(:) == uniqueValues(j))/numberOfElement;
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

sequences = zeros(fileSize, maxVecotorsPerFile);
sequenceIndex = 1;
for(classNo=1:maxClassNo)
    items = randperm(400, randomSizePerClass+10);
    fillItems = 0;
    for(i=1:400)
        if(sum(items == i)>0 && fillItems<randomSizePerClass) %random select%
            fillItems = fillItems + 1;
            sequence = trainSequences(any(trainSequences(:, 1)==classNo, 2) & any(trainSequences(:, 2)==i, 2), :);
            noOfObservations = size(sequence, 1);
            if(noOfObservations > 0)
                sequences(sequenceIndex, 1:noOfObservations) = transpose(sequence(:, 5));
                if(noOfObservations<maxVecotorsPerFile)
                    sequences(sequenceIndex, noOfObservations+1:end) = sequence(end, 5);
                end
                sequenceIndex = sequenceIndex + 1;
            end
        end
    end
end
sequences(sequenceIndex:end, :) = [];
maxColumn = 0;
for(i=1:size(sequences, 1))
    for(j=maxVecotorsPerFile:-1:2)
        if(sequences(i, j) ~= sequences(i, j-1))
            if(j>maxColumn)
                maxColumn = j;
            end
            break;
        end
    end
end
sequences = sequences(:, 1:maxColumn);
ESTTR = hmmtrain(sequences, transmat, ESTEMIT, 'Maxiterations',10);
ESTTR([1:3:Q], :) = transmat([1:3:Q], :);
end