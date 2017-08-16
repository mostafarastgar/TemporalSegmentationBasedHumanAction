function [ STATES, segments ] = testHMM( testSequence, ESTTR, ESTEMIT )
STATES = hmmviterbi(testSequence,ESTTR,ESTEMIT);
initStates = [2:3:17];
finalStates = initStates + 2;
segments = [];
lastState = 0;
segIndex = 1;
for(i=2:size(STATES, 2))
    if(sum(initStates(:) == STATES(i))>0)
        if(sum(finalStates(:) == lastState)>0)
            segments = [segments; i-1 segIndex];
            segIndex = segIndex + 1;
        end
        lastState = STATES(i);
    else
        if(STATES(i) ~= STATES(i - 1))
            if(STATES(i) == STATES(i - 1) + 1)
                lastState=STATES(i);
            else
                lastState = 0;
            end
        end
    end
end
if(sum(finalStates(:) == lastState)>0)
    segments = [segments; i segIndex];
end