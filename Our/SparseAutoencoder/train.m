function[W1]=train(patches,params)
visibleSize =params.rfSize(1)*params.rfSize(2);% number of input units 
hiddenSize = params.nfeats; % number of hidden units 
sparsityParam = 0.05; 
%sparsityParam = 0.01;   % desired average activation of the hidden units.
                     % (This was denoted by the Greek alphabet rho, which looks like a lower-case "p",
		     %  in the lecture notes). 
%lambda = 0.0001;     % weight decay parameter   
lambda = 0.0001;
beta =3;            % weight of sparsity penalty term       
theta = initializeParameters(hiddenSize, visibleSize);
options.Method = 'lbfgs'; % Here, we use L-BFGS to optimize our cost
                          % function. Generally, for minFunc to work, you
                          % need a function pointer with two outputs: the
                          % function value and the gradient. In our problem,
                          % sparseAutoencoderCost.m satisfies this.
options.maxIter =400;	  % Maximum number of iterations of L-BFGS to run 
options.display = 'on';
[opttheta, cost] = minFunc( @(p) sparseAutoencoderCost(p, ...
                                   visibleSize, hiddenSize, ...
                                   lambda, sparsityParam, ...
                                   beta, patches'), ...
                              theta, options);
W1 = reshape(opttheta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
display_network(W1', 12); 


