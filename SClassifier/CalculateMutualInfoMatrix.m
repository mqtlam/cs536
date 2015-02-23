function [ miXY ] = CalculateMutualInfoMatrix( fUV, nVar )
%   Generate Mutual Information Matrix
    % Mutual Information
    miXY = zeros(nVar, nVar);
    for i=1:nVar
        for j=i+1:nVar
            miXY(i,j) = ComputeMI(i, j, fUV);
        end
    end

    % Symmetric Matrix (Undirected graph)
    miXY = miXY + miXY';
end

