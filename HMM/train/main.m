features = load('../../data/features/pcakmeansfeatures.mat');
features = features.features;
GMModel = load('../../data/features/GMModel.mat');
GMModel = GMModel.GMModel;
pca2ParamsGMM = load('../../data/features/pca2ParamsGMM.mat');
coeff2 = pca2ParamsGMM.coeff2;
% pruneIndex2 = pca2ParamsGMM.pruneIndex2;
pruneIndex2 = 100;

windows = break2Windows(features, 6, 1, GMModel, coeff2, pruneIndex2);
testWindowsIndices = [];
for(i=1:6)
    for(j=i:40:400)
        test = find(any(windows(:, end -3)==i, 2) & any(windows(:, end -2)==j, 2));
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
save('../data/windows.mat', 'testWindows', 'trainWindows', '-v7.3');
display('windows has been created');

windows = [trainWindows; testWindows];
opts = statset('MaxIter',10, 'Display', 'iter');
[~,OCs] = kmeans(windows(:, 1:end -4),round(size(windows, 1)*0.01),'Options',opts);
save('../data/OCs.mat', 'OCs', '-v7.3');
IDX = knnsearch(OCs, trainWindows(:, 1:end -4))
trainSequences = [trainWindows(:, end-3:end) IDX];
save('../data/trainSequences.mat', 'trainSequences', '-v7.3');
display('sequences has been created');


[ sequences, ESTTR,ESTEMIT ] = trainHMM(trainSequences, size(OCs, 1), 6, 40, 40);
save('../data/HMMData.mat', 'sequences', 'ESTTR', 'ESTEMIT', '-v7.3');
display('HMM has been trained');
