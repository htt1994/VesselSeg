function [model, scaleparams] = learn_classifier(X, labels, numfolds)

    % Values to search over
    vals = [2^0, 2^-1, 2^-2, 2^-3, 2^-4, 2^-5, 2^-6, 2^-7, 2^-8, 2^-9];
    
    % First permute the data
    indperm = randperm(size(X, 1));
    X = X(indperm,:);
    labels = labels(indperm);

    % Apply cross-validation
    disp('Performing cross validation...')
    [optval, acc] = xval(X, labels, vals, numfolds);
    disp(['Accuracy: ' num2str(max(acc) * 100) '%']);

    % Scale the data and train
    disp('Training Logistic Regression...')
    [X, scaleparams] = standard(X);
    scaleparams.optval = optval;
    model = softmax_regression(X, labels, 2, optval);

