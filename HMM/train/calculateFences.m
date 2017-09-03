function [ fences ] = calculateFences( OIDXs,OCs,ODs )
k = size(OCs, 1);
softRatio = 4.5;
hardRatio = 5;
fences = zeros(k, 2);
for(i=1:k)
    ind = find(OIDXs(:, 1) == i);
    ds = sort(ODs(ind, i));
    if(size(ds, 1)<4)
        q = ds(end, 1);
        if(q == 0)
            q = 1;
        end
        fences(i, :) = [softRatio*(q) hardRatio*(q)];
    else
        iq1 = size(ds, 1) * 1/4;
        if(~mod(iq1,1) == 0)
            q1 = (ds(ceil(iq1), 1) + ds(floor(iq1), 1))/2;
        else
            q1 = ds(iq1, 1);
        end
        iq2 = size(ds, 1) * 3/4;
        if(~mod(iq2,1) == 0)
            q2 = (ds(ceil(iq2), 1) + ds(floor(iq2), 1))/2;
        else
            q2 = ds(iq2, 1);
        end
        fences(i, :) = [softRatio*(q2-q1) hardRatio*(q2-q1)];
    end
end
end

