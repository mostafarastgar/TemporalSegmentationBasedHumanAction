for(i=0:2031)
    partition = load(strcat(['C:\Users\mostafa\Desktop\features\partition\features', num2str(i), '.mat']));
    partition = partition.partition;
    partition(:, 1:1296) = (partition(:, 1:1296)-minhog)/(maxhog - minhog);
    save(strcat(['C:\Users\mostafa\Desktop\features\NormalizedPartition\features', num2str(i), '.mat']), 'partition');
    disp(i);
end