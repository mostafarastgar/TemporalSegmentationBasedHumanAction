function [ STATES, segments ] = testHMM( testSequence, ESTTR, ESTEMIT )
STATES = hmmviterbi(testSequence,ESTTR,ESTEMIT);
segments = [];
lastClassNo = ceil((STATES(2)-1)/3);
for(i=3:size(STATES, 2))
    newClassNo = ceil((STATES(i)-1)/3);
    if(lastClassNo ~= newClassNo)
        segments = [segments; i - 1 lastClassNo];
        lastClassNo = newClassNo;
    end
end
segments = [segments; i newClassNo];

