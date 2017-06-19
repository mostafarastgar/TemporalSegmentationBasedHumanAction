% features = pcafeatures.mat
function [ videoVectors, prior, transmat, obsmat, LL, loglik ] = trainHMM( features, classNo, codeBook)
videoVectors = [];
for(i=1:400)
    subData = features(features(:, end -1) == i);
    if(size(subData, 1)==0)
        break;
    end
    maxFramesNo = max(subData(:, end));
    for(j=1:ceil(maxFramesNo/10))
        minFrame=(j-1)*10 + 1;
        maxFrame=j*10;
        if(maxFrame>maxFramesNo)
            maxFrame = maxFramesNo;
        end
        cube = subData(any(subData(:, end)>=minFrame, 2) & any(subData(:, end)<=maxFrame, 2), :);
        cube = transpose(cube(:, 1:end-3));
        dists = transpose(dist(codeBook, cube));
        [~, codeWords] = min(dists, [], 2);
        vector = zeros(1, 4000);
        for(k=1:4000)
            vector(1, k) = sum(any(codeWords == k, 2));
        end
        videoVectors = [videoVectors; vector classNo i minFrame maxFrame];
    end
end
fileSize = i;
Q = 3;
prior = normalise(rand(Q,1));
transmat = [0.5 0.5 0; 0 0.5 0.5; 0 0 1];
obsmat = mk_stochastic(rand(Q,size(videoVectors, 1)));
for(i=1:fileSize)
    observations = videoVectors(videoVectors(:, end-2) <= i, :);
    [LL, prior, transmat, obsmat] = dhmm_em(observations, prior, transmat, obsmat);
    loglik = dhmm_logprob(data, prior, transmat, obsmat)
end
end

