function [D, X, labels] = run_vessel12(params)

    % Load volumes, annotations and pre-process
    disp('Loading and pre-processing data...')
    ntv = 2;   % number of training volumes
    V = cell(ntv, 1);
    A = cell(ntv, 1);
    Vlist = cell(ntv, 1);
    Vs = [];
    for i = 1:ntv
        I = load_vessel12(params, 20+i);  % I is a 3D volume
        A{i} = load(sprintf('%s/VESSEL12_%d_Annotations.csv', params.annotsdir, 20+i));
        V{i} = pyramid(I, params);
        Vlist{i} = imagelist(A{i}, params.numscales);  % These are slices which contain annotations
        Vs = [Vs; V{i}];
        clear I;
    end
    
    % Extract patches
    patches = extract_patches(Vs, params);

    % Train dictionary
    D = dictionary(patches, params);

    % Compute first module feature maps on slices with annotations
    disp('Extracting first module feature maps...')
    L = cell(ntv, 1);
    for i = 1:ntv
        L{i} = extract_features(V{i}(Vlist{i}), D, params);  % Only extract features from annotated slices
    end

    % Upsample all feature maps
    disp('Upsampling feature maps...')
    for i = 1:ntv
        L{i} = upsample(L{i}, params.numscales, params.upsample);
    end

    % Compute features for classification
    disp('Computing pixel-level features...')
    X = []; labels = [];
    for i = 1:ntv
        [tr, tl] = convert(L{i}, A{i}, Vlist{i}(params.numscales:params.numscales:end)/params.numscales);
        X = [X; tr];
        labels = [labels; tl];
    end
        
