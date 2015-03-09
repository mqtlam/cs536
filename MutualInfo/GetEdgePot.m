function [ edgePot ] = GetEdgePot( edgeStruct, fUV, nStates )
%GetEdgePot: Compute the edge potential
%   Parameter:
%       - edgeStruct : edges of the tree
%       - fUV        : frequency of all states of pairwise variables
%   Output:
%       - edgePot    : edge potential
    %% Update edge potential array
    edgePot = zeros(nStates,nStates,edgeStruct.nEdges);
    for e = 1:edgeStruct.nEdges
        edgeEnds = edgeStruct.edgeEnds(e,:);
        edgePot(:,:,e) = fUV(:,:,edgeEnds(1),edgeEnds(2));
    end
end


