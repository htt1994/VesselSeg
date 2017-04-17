function [patches, params] = extract_patches(V, params)

    
    % Parameters
    rfSize = params.rfSize;
    npatches = params.npatches;

    % Main loop
    patches = zeros(npatches, rfSize(1) * rfSize(2) * rfSize(3));
    for i=1:npatches     
        patch = double(V{mod(i-1,length(V))+1});
        patch = squeeze(patch);
        [nrows, ncols, nmaps] = size(patch);
        % Extract random block
        r = random('unid', nrows - rfSize(1) + 1);
        c = random('unid', ncols - rfSize(2) + 1);
        patch = patch(r:r+rfSize(1)-1,c:c+rfSize(2)-1,:);
        patches(i,:) = patch(:)';   
    end

    patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2) + 10));%Contrast normalization

end

