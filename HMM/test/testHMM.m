function [ STATES, segments ] = testHMM( testSequence, ESTTR, ESTEMIT, windowSize )
observations = transpose(testSequence(:, end));
STATES = hmmviterbi(observations,ESTTR,ESTEMIT);
initStates = [2:3:size(ESTTR, 1)-3];
finalStates = initStates + 2;
segments = [];
segIndex = 1;
currentMin = testSequence(1, 1);
for(i=2:size(STATES, 2))
    if(STATES(i) ~= STATES(i-1))
        if(sum(initStates(:) == STATES(i))>0 && (sum(finalStates(:) == STATES(i-1))>0 ...
                || size(ESTEMIT, 1) == STATES(i-1)))
            segments = [segments; currentMin testSequence(i-1, 2) segIndex];
            segIndex = segIndex + 1;
            currentMin = testSequence(i-1, 2) + 1;
        end
    end
end
segments = [segments; currentMin testSequence(end, end -1) segIndex];
