HMMData = load('../data/HMMData.mat');
prior = HMMData.prior;
obsmat = HMMData.obsmat;
transmat = HMMData.transmat;

OCs = load('../data/OCs.mat');
OCs = OCs.OCs;

windows = load('../data/windows.mat');
testWindows = windows.testWindows;

confuseItems = [1 1; 4 44; 5 85; 2 42];
[sequence, originalSegments] = getObservations(testWindows, confuseItems, OCs);

[ loglik, D, Qs, segments ] = testHMM(sequence, prior, obsmat, transmat);
