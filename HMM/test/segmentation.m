testfeatures = features(any(features(:, end -3)==1, 2) & any(features(:, end -2)==1, 2), :);
maxFramesNo = max(testfeatures(:, end -1));
testfeatures2 = features(any(features(:, end -3)==3, 2) & any(features(:, end -2)==1, 2), :);
minFramesNo = min(testfeatures2(:, end -1));
testfeatures2(:, end -1) = testfeatures2(:, end -1) - minFramesNo + maxFramesNo + 1;
testfeatures = [testfeatures; testfeatures2];
clear testfeatures2;

maxFramesNo = max(testfeatures(:, end -1));
segments = [];
videoVectors = [];
for(j=1:ceil(maxFramesNo/10))
    minFrame=(j-1)*10 + 1;
    maxFrame=j*10;
    if(maxFrame>maxFramesNo)
        maxFrame = maxFramesNo;
    end
    cube = testfeatures(any(testfeatures(:, end -1)>=minFrame, 2) & any(testfeatures(:, end -1)<=maxFrame, 2), :);
    p = posterior(GMModel, cube(:, 1:end-4));
    vector = sum(p, 1);
    videoVectors = [videoVectors; vector minFrame maxFrame];
end
labels = videoVectors(:, end-1:end);
videoVectors = [videoVectors(:, 1:end -2) * coeff2];
videoVectors = [videoVectors(:, 1:pruneIndex2) labels];

hmms = {videoVectors1 obsmat1 transmat1;videoVectors2 obsmat2 transmat2;...
    videoVectors3 obsmat3 transmat3;videoVectors4 obsmat4 transmat4;...
    videoVectors5 obsmat5 transmat5;videoVectors6 obsmat6 transmat6};
loglik = 0;
bestHMM = 0;
for(i=1:size(hmms, 1))
    obs = hmms{i, 1};
    obsmat = hmms{i, 2};
    transmat = hmms{i, 3};
    [ loglik1, D1, Qs1 ] = testHMM(videoVectors(1:5, 1:end-2), obs, obsmat, transmat);
    if(loglik1>loglik)
        loglik = loglik1;
        bestHMM = i;
    end
end
maxVecs = size(videoVectors, 1);
i = 6;
minI = 1;
while(i<=maxVecs)
    obs = hmms{bestHMM, 1};
    obsmat = hmms{bestHMM, 2};
    transmat = hmms{bestHMM, 3};
    [ loglik1, D1, Qs1 ] = testHMM(videoVectors(minI:i, 1:end-2), obs, obsmat, transmat);
    D1 = sum(D1);
    endVec = min([maxVecs i+4]);
    bloglik = 0;
    bbestHMM = 0;
    for(j=1:size(hmms, 1))
        if(j~=bestHMM)
            bobs = hmms{j, 1};
            bobsmat = hmms{j, 2};
            btransmat = hmms{j, 3};
            [ bloglik1, bD1, bQs1 ] = testHMM(videoVectors(i:endVec, 1:end-2), bobs, bobsmat, btransmat);
            bD1= sum(bD1);
            if(bloglik1>bloglik && bD1<D1)
                bloglik = bloglik1;
                bbestHMM = j;
                D1 = bD1;
            end
        end
    end
    if((size(Qs1, 2)>1 && Qs1(1, end)<Qs1(1, end-1)) || bloglik>loglik1)
        segments = [segments; videoVectors(i, end-1) - 1 bestHMM ];
        bestHMM = bbestHMM;
        minI = i;
        i = endVec;
    else
        i = i + 1;
    end
end
segments = [segments; videoVectors(endVec, end) bestHMM ];
