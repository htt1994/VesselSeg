function yhat = annotate_rf(image, model, mask, scaleparams)

% Mask should be a binary image
[m,n,p] = size(image);
image = bsxfun(@times, image, mask);
image = reshape(image, m * n, p);
image = standard_my(image, scaleparams);
% labels=ones(m*n,1);
yhat = classRF_predict(image,model);
% [yhat, accuracy, dec_values] =svmpredict(labels,image, model,'-b 1 -q');
yhat = reshape(yhat, m, n, 1);
% save dec_values;
end

