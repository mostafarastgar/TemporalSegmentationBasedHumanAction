% features = pcakmeansfeatures.mat
function [ videoVectors, sequences, prior, transmat, obsmat, LL, loglik ] = trainHMM( features, classNo, codeBook, coeff2, pruneIndex2)
videoVectors = [];
maxVecotorsPerFile = 0;
for(i=1:400)
    subData = features(features(:, end -2) == i, :);
    if(size(subData, 1)==0)
        break;
    end
    maxFramesNo = max(subData(:, end -1));
    for(j=1:ceil(maxFramesNo/10))
        minFrame=(j-1)*10 + 1;
        maxFrame=j*10;
        if(maxFrame>maxFramesNo)
            maxFrame = maxFramesNo;
        end
        cube = subData(any(subData(:, end -1)>=minFrame, 2) & any(subData(:, end -1)<=maxFrame, 2), :);
        cube = transpose(cube(:, 1:end-4));
        dists = transpose(dist(codeBook, cube));
        [~, codeWords] = min(dists, [], 2);
        vector = zeros(1, 4000);
        for(k=1:4000)
            vector(1, k) = sum(any(codeWords == k, 2));
        end
        videoVectors = [videoVectors; vector classNo i minFrame maxFrame];
    end
    if(j>maxVecotorsPerFile)
        maxVecotorsPerFile = j;
    end
end
labels = videoVectors(:, end-3:end);
videoVectors = [videoVectors(:, 1:end -4) * coeff2];
videoVectors = [videoVectors(:, 1:pruneIndex2) labels];
fileSize = i;
Q = 3;
prior = [1;0;0];
transmat = [0.5 0.5 0; 0 0.5 0.5; 0 0 1];
obsmat = mk_stochastic(rand(Q,size(videoVectors, 1)));
sequences = zeros(i, maxVecotorsPerFile);
lastIndex = 1;
for(i=1:fileSize)
    NoVectors = sum(videoVectors(:, end-2) == i);
    sequences(i, 1:NoVectors) = [lastIndex:lastIndex+NoVectors-1];
    if(NoVectors<maxVecotorsPerFile)
        sequences(i, NoVectors+1:end) = lastIndex+NoVectors-1;
    end
    lastIndex = lastIndex+NoVectors;
end
[LL, prior, transmat, obsmat] = dhmm_em(sequences, prior, transmat, obsmat);
loglik = dhmm_logprob(sequences, prior, transmat, obsmat)
end

