function [ PSTATES, segments, logpseq ] = testHMM( testSequence, ESTTR, ESTEMIT )
[PSTATES,logpseq] = hmmdecode(testSequence, ESTTR, ESTEMIT);
segments = [];
lastClassNo = ceil((PSTATES(2)-1)/3);
for(i=3:size(PSTATES, 1))
    newClassNo = ceil((PSTATES(i)-1)/3);
    if(lastClassNo ~= newClassNo)
        segments(end+1) = [lastClassNo i - 1];
        lastClassNo = newClassNo;
    end
end
segments(end+1) = [newClassNo i];

