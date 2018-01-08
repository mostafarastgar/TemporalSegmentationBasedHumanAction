function [ SVMStructs ] = trainClassifier( arvData )
classes = unique(arvData(:, end-1));
SVMStructs={};
options=statset('Display', 'iter', 'MaxIter', 1000000);
for(i=1:size(classes, 1))
    labels = arvData(:, end-1);
    labels(labels(:, 1) ~= classes(i)) = 0;
    SVMStructs{i} = svmtrain(arvData(:, 1:end-2), labels, 'options', options);
    disp(strcat('i=', num2str(i), ' out of ', num2str(size(classes, 1)), ' has been done.'));
end
end

