features = zeros(2030771, 1552);
index = 1;
for i=0:2031
    partition = load(['C:\Users\mostafa\Desktop\features\NormalizedPartition\features', num2str(i), '.mat']);
    partition = partition.partition;
    features(index:index+size(partition, 1)-1, :) = partition(:, 1:end-2);
    index = index+size(partition, 1);
    display(i);
end