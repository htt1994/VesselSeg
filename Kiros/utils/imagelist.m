function imlist = imagelist(annotations, numscales)

    un = unique(annotations(:,3)) + 1;
    imlist = zeros(numscales * length(un), 1);
    for i = 1:length(un)
        imlist(numscales * (i-1) + 1 : numscales * (i-1) + numscales) = numscales*un(i)-numscales+1:numscales*un(i);
    end

end

