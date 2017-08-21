% features = load('../../data/features/pcakmeansfeatures.mat');
% features = features.features;
% GMModel = load('../../data/features/GMModel.mat');
% GMModel = GMModel.GMModel;
% pca2ParamsGMM = load('../../data/features/pca2Params.mat');
% coeff2 = pca2ParamsGMM.coeff2;
% pruneIndex2 = pca2ParamsGMM.pruneIndex2;
% 
% windows = break2Windows(features, 6, 10, GMModel, coeff2, pruneIndex2);
% testWindowsIndices = [];
% for(i=1:6)
%     for(j=i:40:400)
%         test = find(any(windows(:, end -3)==i, 2) & any(windows(:, end -2)==j, 2));
%         if(size(test, 1)>0)
%             testWindowsIndices = [testWindowsIndices; test];
%         else
%             break;
%         end
%     end
% end
% testWindows = windows(testWindowsIndices, :);
% windows(testWindowsIndices, :) = [];
% trainWindows = windows;
% save('../data/windows.mat', 'testWindows', 'trainWindows', '-v7.3');
% display('windows has been created');
% 
% windows = [trainWindows; testWindows];
% opts = statset('Display', 'iter');
% [OIDXs,OCs,Osumds,ODs] = kmeans(windows(:, 1:end -4),round(size(windows, 1)*0.01),'Options',opts, 'start', OCs);
% fences = calculateFences(OIDXs,OCs,ODs);
% save('../data/OCs.mat', 'OIDXs','OCs','Osumds','ODs', 'fences', '-v7.3');
% trainSequences = generateTrainSequences(trainWindows(:, end-3:end), OIDXs, ODs, fences);
% save('../data/trainSequences.mat', 'trainSequences', '-v7.3');
% display('sequences has been created');


[ sequences, transmat, emisionmat, ESTTR, ESTEMIT ] = trainHMM(trainSequences, size(OCs, 1)+2, 19, 6);
save('../data/HMMData.mat', 'sequences', 'transmat', 'emisionmat', 'ESTTR', 'ESTEMIT', '-v7.3');
display('HMM has been trained');
