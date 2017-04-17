function [optval, acc] = xval(X, L, vals, numfolds)

    % Split into folds
    foldsize = floor(size(X, 1) / numfolds);
    train_folds = cell(numfolds, 1);
    test_folds = cell(numfolds, 1);
    train_L = cell(numfolds, 1);
    test_L = cell(numfolds, 1);
    for i = 1:numfolds
        te = X((i - 1) * foldsize + 1 : i * foldsize, :);
        tr = [X(1 : (i - 1) * foldsize, :); X(i * foldsize + 1 : end, :)];
        [train_folds{i}, scaleparams] = standard(tr);
        test_folds{i} = standard(te, scaleparams);
        test_L{i} = L((i - 1) * foldsize + 1 : i * foldsize);
        train_L{i} = [L(1 : (i - 1) * foldsize); L(i * foldsize + 1 : end)];
    end
    
    % Loop over values
    acc = zeros(length(vals), 1);
    for i = 1:length(vals)
        
        % Loop over folds
        accfold = zeros(length(numfolds), 1);
        parfor j = 1:numfolds
            
            theta = softmax_regression(train_folds{j}, train_L{j}, 2, vals(i));
            [~, M] = predict(theta, test_folds{j});
            yhat = (M(2,:) >= 0.5)' + 1;
            
            accfold(j) = mean(yhat == test_L{j});
            
        end
        acc(i) = mean(accfold);
        disp(['Mean accuracy with parameter ' num2str(vals(i)) ': ' num2str(acc(i))]);
        
    end
    
    % Return optimal parameter
    [foo, ind] = max(acc);
    optval = vals(ind);
    disp(' ');
   
    


