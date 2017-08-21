HMMData = load('../data/HMMData.mat');
ESTTR = HMMData.transmat;
ESTEMIT = HMMData.emisionmat;

GMModel = load('../../data/features/GMModel.mat');
GMModel = GMModel.GMModel;

OCs = load('../data/OCs.mat');
fences = OCs.fences;
OCs = OCs.OCs;

features = load('../../data/features/pcakmeansfeatures.mat');
features = features.features;
pca2ParamsGMM = load('../../data/features/pca2Params.mat');
coeffGMM = pca2ParamsGMM.coeff2;
pruneGMM = pca2ParamsGMM.pruneIndex2;

windowSize = 10;
tolerance = 5;
tic;
confuseItems = {
%     [1 161; 4 364; 2 42; 1 241],
%     [1 1; 4 44; 5 85; 2 42],
%     [5 245; 1 161; 2 82; 3 123; 4 164; 5 245; 6 326],
%     [3 83; 5 45; 1 121],
%     [4 124; 2 82; 3 363; 2 42; 1 161],
%     [1 81; 2 42; 3 163; 5 85; 4 284; 1 321],
%     [1 81; 3 363; 5 125],
    
    [3 243; 5 365; 4 324; 2 82],
    [3 363; 2 282; 1 161],
    [5 85; 3 123; 4 164; 2 162; 5 325],

    [1 121; 5 365; 4 84; 2 82; 5 45],
    [5 165; 3 323; 6 366; 1 41; 2 82; 4 44],
    [2 42; 3 83; 4 124; 5 165; 6 206; 1 241; 2 282; 3 323; 4 364],
    [6 46; 2 82; 1 121; 6 146],
    [5 45; 2 162; 1 121; 6 366],
    [5 125; 6 46; 1 41; 2 162],
    [1 81; 6 46; 3 163; 4 204],
    [5 245; 1 81; 6 46],
    [2 42; 3 83; 1 121; 4 244],
    [3 83; 1 121; 2 82; 5 125; 6 366]
    };
orgSegs = {};
segs = {};
accuracies = zeros(length(confuseItems), 1);
for(i=1:length(confuseItems))
    [testSequence, originalSegments] = getObservations(features, confuseItems{i}, windowSize, GMModel, coeffGMM, pruneGMM, OCs, fences);
    [ STATES, segments ] = testHMM(testSequence, ESTTR, ESTEMIT);
    [originalSegments, segments, accuracy] = findAccuracy(originalSegments, segments, tolerance);
    orgSegs{i} = originalSegments;
    segs{i} = segments;
    accuracies(i) = accuracy;
end
accuracy = mean(accuracies);
toc;
[~, idx] = max(accuracies);
displaySegments(orgSegs{idx}, segs{idx});