% features = pcakmeansfeatures.mat
function [ sequences, prior, transmat1, obsmat ] = trainHMM(trainSequences, O, maxClassNo, beginStateWindows, endStateWindows)
Q = 18;
prior = [1/6;0;0;1/6;0;0;1/6;0;0;1/6;0;0;1/6;0;0;1/6;0;0];
obsmat = zeros(18, O);
maxVecotorsPerFile = 0;
fileSize = 0;
for(i=1:3:16)
    classNo = floor(i/3) + 1;
    beginningIndices = [];
    middleIndices = [];
    endIndices = [];
    for(j=1:400)
        indices = find(any(trainSequences(:, 1)==classNo, 2) & any(trainSequences(:, 2)==j, 2));
        if(size(indices, 1)>0)
            if(size(indices, 1)>=beginStateWindows+endStateWindows+1)
                beginningIndices = [beginningIndices;indices(1:beginStateWindows)];
                middleIndices = [middleIndices;indices(beginStateWindows+1:end-endStateWindows)];
                endIndices = [endIndices;indices(end-endStateWindows+1:end)];
            else
                beginningIndices = [beginningIndices;indices(1)];
                middleIndices = [middleIndices;indices(2:end-1)];
                endIndices = [endIndices;indices(end)];
            end
            if(size(indices, 1)>maxVecotorsPerFile)
                maxVecotorsPerFile = size(indices, 1);
            end
            fileSize = fileSize + 1;
        else
            break;
        end
    end
    obsmat(i, beginningIndices) = (1/size(beginningIndices, 1));
    obsmat(i+1, middleIndices) = (1/size(middleIndices, 1));
    obsmat(i+2, endIndices) = (1/size(endIndices, 1));
end

sequences = zeros(fileSize, maxVecotorsPerFile);
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
[~, prior, transmat1] = dhmm_em(sequences, prior, transmat, obsmat, 'max_iter', 10);
transmat1([3, 6, 9, 12, 15, 18], :) = transmat([3, 6, 9, 12, 15, 18], :);
end