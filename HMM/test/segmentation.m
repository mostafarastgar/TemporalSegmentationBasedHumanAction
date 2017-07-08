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
inntersection = zeros(1, segments(end, 1));
start = 1;
tmp = [zeros(size(originalSegments, 1), 1) originalSegments(:, 1) zeros(size(originalSegments, 1), 1) originalSegments(:, end)];
for(i=1:size(originalSegments, 1))
    tmp(i, 1) = start;
    tmp(i, 3) = tmp(i, 2) - tmp(i, 1) + 1;
    start = tmp(i, 2) + 1;
end
originalSegments = tmp;

start = 1;
tmp = [zeros(size(segments, 1), 1) segments(:, 1) zeros(size(segments, 1), 1) segments(:, end)];
for(i=1:size(segments, 1))
    tmp(i, 1) = start;
    tmp(i, 3) = tmp(i, 2) - tmp(i, 1) + 1;
    start = tmp(i, 2) + 1;
end
segments = tmp;
[originalSegments, segments, accuracy] = findAccuracy(originalSegments, segments);