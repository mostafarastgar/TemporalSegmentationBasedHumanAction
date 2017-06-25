HMMData = load('../data/HMMData.mat');
ESTTR = HMMData.ESTTR;
ESTEMIT = HMMData.ESTEMIT;

OCs = load('../data/OCs.mat');
OCs = OCs.OCs;

windows = load('../data/windows.mat');
testWindows = windows.testWindows;

confuseItems = [1 1; 4 44; 5 85; 2 42];
[testSequence, originalSegments] = getObservations(testWindows, confuseItems, OCs);

[ STATES, segments ] = testHMM(transpose(testSequence(:, 5)), ESTTR, ESTEMIT);