function [ fences ] = calculateFences( OIDXs,OCs,ODs )
k = size(OCs, 1);
innerRatio = 1.5;
outerRatio = 3;
fences = zeros(k, 4);
for(i=1:k)
    ind = find(OIDXs(:, 1) == i);
    ds = sort(ODs(ind, i));
    if(size(ds, 1)<4)
        q1 = ds(1, 1);
        q3 = ds(end, 1);
        iqr = q3 - q1;
        fences(i, :) = [q1-(innerRatio*iqr) q3+(innerRatio*iqr) q1-(outerRatio*iqr) q3+(outerRatio*iqr)];
    else
        iq1 = size(ds, 1) * 1/4;
        if(~mod(iq1,1) == 0)
            q1 = (ds(ceil(iq1), 1) + ds(floor(iq1), 1))/2;
        else
            q1 = ds(iq1, 1);
        end
        iq3 = size(ds, 1) * 3/4;
        if(~mod(iq3,1) == 0)
            q3 = (ds(ceil(iq3), 1) + ds(floor(iq3), 1))/2;
        else
            q3 = ds(iq3, 1);
        end
        iqr = q3 - q1;
        fences(i, :) = [q1-(innerRatio*iqr) q3+(innerRatio*iqr) q1-(outerRatio*iqr) q3+(outerRatio*iqr)];
    end
end
end

