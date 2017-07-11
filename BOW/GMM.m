function [ GMModel ] = GMM( features, C)
data = features(:, 1:end -4);
sizeOfData = size(data, 1);
sizeOfFields = size(data, 2);
covMat = zeros(sizeOfFields, sizeOfFields, 4000);
delete(gcp);
parpool(16);
parfor (i=1:4000)
    innerData = zeros(sizeOfData, sizeOfFields);
    for(j=1:sizeOfFields)
        innerData(:, j) = (data(:, j) - C(i, j));
    end
    values = zeros(sizeOfFields, sizeOfFields);
    for(j=1:sizeOfFields)
        for(k=j:sizeOfFields)
            values(j, k) = sum(innerData(:, j) .* innerData(:, k))/sizeOfData;
            values(k, j) = values(j, k);
        end
    end
    covMat(:, :, i) = values;
end
start = [];
start.mu = C;
start.Sigma = covMat;

display('start fitgmdist');

tic;
GMModel = fitgmdist(features(:, 1:end-4), 4000, 'CovType', 'full', 'Regularize', 1e-5, 'Options',statset('Display','iter','MaxIter',1500), 'Start',start);
save('data/features/GMModel.mat', 'GMModel', '-v7.3');
toc;
