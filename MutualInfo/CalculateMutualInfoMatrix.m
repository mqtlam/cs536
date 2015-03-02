function [ miXY ] = CalculateMutualInfoMatrix( fUV, nVar )
%  Generate Mutual Information Matrix
%  Parameters:
%   - fUV   : pairwise variable frequency of all possible states
%   - nVar  : # variables/nodes
%  Output:
%   - miXY  : Mutual Information matrix

    miXY = zeros(nVar, nVar);
    for i=1:nVar
        for j=i+1:nVar
            miXY(i,j) = ComputeMI(i, j, fUV);
        end
    end

    % Symmetric Matrix (Undirected graph)
    miXY = miXY + miXY';
end

