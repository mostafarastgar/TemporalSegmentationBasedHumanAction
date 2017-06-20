data = features(features(:, end-3)==1, :);
[ videoVectors1, sequences1, prior1, transmat1, obsmat1, LL1, loglik1 ] = trainHMM(data, 1, C, coeff2, pruneIndex2);
save('../../data/features/hmmdata1.mat', 'videoVectors1', 'sequences1','prior1', 'transmat1', 'obsmat1', 'LL1', 'loglik1', '-v7.3');
clear('videoVectors1', 'sequences1', 'prior1', 'transmat1', 'obsmat1', 'LL1', 'loglik1');
display('class 1 has been done.');

data = features(features(:, end-3)==2, :);
[ videoVectors2, sequences2, prior2, transmat2, obsmat2, LL2, loglik2 ] = trainHMM(data, 2, C, coeff2, pruneIndex2);
save('../../data/features/hmmdata2.mat', 'videoVectors2', 'sequences2','prior2', 'transmat2', 'obsmat2', 'LL2', 'loglik2', '-v7.3');
clear('videoVectors2', 'sequences2', 'prior2', 'transmat2', 'obsmat2', 'LL2', 'loglik2');
display('class 2 has been done.');

data = features(features(:, end-3)==3, :);
[ videoVectors3, sequences3, prior3, transmat3, obsmat3, LL3, loglik3 ] = trainHMM(data, 3, C, coeff2, pruneIndex2);
save('../../data/features/hmmdata3.mat', 'videoVectors3', 'sequences3','prior3', 'transmat3', 'obsmat3', 'LL3', 'loglik3', '-v7.3');
clear('videoVectors3', 'sequences3', 'prior3', 'transmat3', 'obsmat3', 'LL3', 'loglik3');
display('class 3 has been done.');

data = features(features(:, end-3)==4, :);
[ videoVectors4, sequences4, prior4, transmat4, obsmat4, LL4, loglik4 ] = trainHMM(data, 4, C, coeff2, pruneIndex2);
save('../../data/features/hmmdata4.mat', 'videoVectors4', 'sequences4','prior4', 'transmat4', 'obsmat4', 'LL4', 'loglik4', '-v7.3');
clear('videoVectors4', 'sequences4', 'prior4', 'transmat4', 'obsmat4', 'LL4', 'loglik4');
display('class 4 has been done.');

data = features(features(:, end-3)==5, :);
[ videoVectors5, sequences5, prior5, transmat5, obsmat5, LL5, loglik5 ] = trainHMM(data, 5, C, coeff2, pruneIndex2);
save('../../data/features/hmmdata5.mat', 'videoVectors5', 'sequences5','prior5', 'transmat5', 'obsmat5', 'LL5', 'loglik5', '-v7.3');
clear('videoVectors5', 'sequences5', 'prior5', 'transmat5', 'obsmat5', 'LL5', 'loglik5');
display('class 5 has been done.');

data = features(features(:, end-3)==6, :);
[ videoVectors6, sequences6, prior6, transmat6, obsmat6, LL6, loglik6 ] = trainHMM(data, 6, C, coeff2, pruneIndex2);
save('../../data/features/hmmdata6.mat', 'videoVectors6', 'sequences6','prior6', 'transmat6', 'obsmat6', 'LL6', 'loglik6', '-v7.3');
clear('videoVectors6', 'sequences6', 'prior6', 'transmat6', 'obsmat6', 'LL6', 'loglik6');
display('class 6 has been done.');
