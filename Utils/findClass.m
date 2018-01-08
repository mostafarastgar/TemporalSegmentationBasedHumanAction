function [ class ] = findClass( vecotr, SVMStructs )
scores = zeros(size(SVMStructs, 2), 2);
maxScore=0;
minScore=0;
class1=0;
class2=0;
for(i=1:size(SVMStructs, 2))
    [outclass,f] = svmfindClass(SVMStructs{1, i},vecotr);
    scores(i, :) = [outclass f];
    if(outclass==1)
        if(maxScore<f)
            maxScore = f;
            class1=i;
        end
    else
        if(minScore>f || minScore == 0)
            minScore = f;
            class2=i;
        end
    end
end
if(class1~=0)
    class=class1;
else
    class=class2;
end
