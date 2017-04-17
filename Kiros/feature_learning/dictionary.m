function D = dictionary(patches, params)


    % Parameters
    nfeats = params.nfeats;
    rfSize = params.rfSize;
    
    D.mean = mean(patches);
    nX = bsxfun(@minus, patches, D.mean);
    
    % Train dictionary
    disp('Training Dictionary...');
    D.codes = run_omp1(nX, nfeats, 50);
    
end

