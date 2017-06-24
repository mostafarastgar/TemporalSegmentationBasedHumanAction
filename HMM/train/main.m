features = load('../../data/features/pcakmeansfeatures.mat');
features = features.features;
GMModel = load('../../data/features/GMModel.mat');
GMModel = GMModel.GMModel;
pca2ParamsGMM = load('../../data/features/pca2ParamsGMM.mat');
coeff2 = pca2ParamsGMM.coeff2;
pruneIndex2 = pca2ParamsGMM.pruneIndex2;

windows = break2Windows(features, 6, 1, GMModel, coeff2, pruneIndex2);
testWindowsIndices = [];
for(i=1:6)
    for(j=i:40:400)
        test = find(any(features(:, end -3)==i, 2) & any(features(:, end -2)==j, 2), :);
        if(size(test, 1)>0)
            testWindowsIndices = [testWindowsIndices; test];
        else
            break;
        end
    end
end
testWindows = windows(testWindowsIndices, :);
windows(testWindowsIndices, :) = [];
trainWindows = windows;
clear windows;
save('../data/windows.mat', 'testWindows', 'trainWindows', '-v7.3');
display('windows has been created');

opts = statset('MaxIter',20, 'Display', 'iter');
[IDX,OCs] = kmeans(trainWindows(:, 1:end -4),round(size(trainWindows, 1)*0.1),'Options',opts);
save('../data/OCs.mat', 'OCs', '-v7.3');
trainSequences = [trainWindows(:, end-3:end) IDX];
save('../data/trainSequences.mat', 'trainSequences', '-v7.3');
display('sequences has been created');


[ sequences, prior, transmat, obsmat ] = trainHMM(trainSequences, size(OCs, 1), 6, 20, 20);
save('../data/HMMData.mat', 'sequences', 'prior', 'transmat', 'obsmat', '-v7.3');
display('HMM has been trained');
