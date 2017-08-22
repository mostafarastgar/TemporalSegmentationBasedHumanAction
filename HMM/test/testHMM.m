function [ STATES, segments ] = testHMM( testSequence, ESTTR, ESTEMIT, windowSize )
observations = transpose(testSequence(:, end));
STATES = hmmviterbi(observations,ESTTR,ESTEMIT);
initStates = [2:3:17];
finalStates = initStates + 2;
segments = [];
lastState = 0;
segIndex = 1;
currentMin = 0;
for(i=2:size(STATES, 2))
    if(sum(initStates(:) == STATES(i))>0)
        if(currentMin == 0)
            currentMin = testSequence(i, 1);
        end
        if(sum(finalStates(:) == lastState)>0)
            segments = [segments; currentMin testSequence(i-1, 2) segIndex];
            segIndex = segIndex + 1;
            currentMin = testSequence(i-1, 2) + 1;
        end
        lastState = STATES(i);
    else
        if(STATES(i) ~= STATES(i - 1))
            if(STATES(i) ~= size(ESTEMIT, 1))
                lastState=STATES(i);
            else
                if(testSequence(i-1, 2) - currentMin > windowSize)
                    segments = [segments; currentMin testSequence(i-1, 2) segIndex];
                    segIndex = segIndex + 1;
                end
                lastState = 0;
                currentMin = 0;
            end
        end
    end
end
if(segments(end, 1) ~= testSequence(end, end -1) && currentMin ~= 0)
    segments = [segments; currentMin testSequence(end, end -1) segIndex];
end