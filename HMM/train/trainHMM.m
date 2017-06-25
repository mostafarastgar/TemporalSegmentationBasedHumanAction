% features = pcakmeansfeatures.mat
function [ sequences, ESTTR,ESTEMIT ] = trainHMM(trainSequences, O, maxClassNo, beginStateWindows, endStateWindows)
Q = 18;
emmisionMat = zeros(19, O);
maxVecotorsPerFile = 0;
fileSize = 0;
for(i=2:3:17)
    classNo = ceil((i-1)/3);
    beginningIndices = [];
    middleIndices = [];
    endIndices = [];
    for(j=1:400)
        indices = trainSequences(any(trainSequences(:, 1)==classNo, 2) & any(trainSequences(:, 2)==j, 2), 5);
        if(size(indices, 1)>0)
            if(size(indices, 1)>=beginStateWindows+endStateWindows+1)
                beginningIndices = [beginningIndices;indices(1:beginStateWindows)];
                middleIndices = [middleIndices;indices(beginStateWindows+1:end-endStateWindows)];
                endIndices = [endIndices;indices(end-endStateWindows+1:end)];
            else
                miniSize = round((beginStateWindows+endStateWindows+1)/4);
                beginningIndices = [beginningIndices;indices(1:miniSize)];
                middleIndices = [middleIndices;indices(miniSize+1:end-miniSize)];
                endIndices = [endIndices;indices(end-miniSize+1:end)];
            end
            if(size(indices, 1)>maxVecotorsPerFile)
                maxVecotorsPerFile = size(indices, 1);
            end
            fileSize = fileSize + 1;
        else
            break;
        end
    end
    emmisionMat(i, beginningIndices) = (1/size(beginningIndices, 1));
    emmisionMat(i+1, middleIndices) = (1/size(middleIndices, 1));
    emmisionMat(i+2, endIndices) = (1/size(endIndices, 1));
end

prior = [0 1/6 0 0 1/6 0 0 1/6 0 0 1/6 0 0 1/6 0 0 1/6 0 0];
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
transmat = [zeros(19, 1) transmat];

sequences = zeros(fileSize, maxVecotorsPerFile);
sequenceIndex = 1;
for(classNo=1:maxClassNo)
    for(i=1:400)
        sequence = trainSequences(any(trainSequences(:, 1)==classNo, 2) & any(trainSequences(:, 2)==i, 2));
        noOfObservations = size(sequence, 1);
        if(noOfObservations == 0)
            break;
        end
        sequences(sequenceIndex, 1:noOfObservations) = transpose(sequence(:, 5));
        if(noOfObservations<maxVecotorsPerFile)
            sequences(sequenceIndex, noOfObservations+1:end) = sequence(end, 5);
        end
        sequenceIndex = sequenceIndex + 1;
    end
end
[ESTTR,ESTEMIT] = hmmtrain(sequences, transmat, emmisionMat);
ESTTR([1 4, 7, 10, 13, 16, 19], :) = transmat([1 4, 7, 10, 13, 16, 19], :);
ESTTR(:, 1) = transmat(:, 1);
end