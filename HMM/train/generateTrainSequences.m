function [ trainSequences ] = generateTrainSequences(trainWindows, OIDXs, ODs, fences)
trainSequences = [trainWindows zeros(size(trainWindows, 1), 1)];
o = size(ODs, 2);
for(i=1:size(trainWindows, 1))
    d = ODs(i, OIDXs(i));
    if(d>fences(OIDXs(i), 2))
        trainSequences(i, end) = o + 2;
    else
        if(d>fences(OIDXs(i), 1))
            trainSequences(i, end) = o + 1;
        else
            trainSequences(i, end) = OIDXs(i);
        end
    end
end
end

