function [MT_edgeStructs,MT_nodePots,MT_edgePots] = GenerateInitMT( nNodes, nStates, m, fUV, option )

% Input:    nNodes -> # of nodes 
%           m      -> # of mixture trees
%           fUV    -> pairwise frequency over all nodes
%           option -> 1. generate the MI mat, then shuffle rows and cols
%                     2. split the scene instances into 'm' groups, then build tree seperately
% Output:   MT_edgeStructs -> m*1 cell array stores structures of 'm' trees
%           MT_nodePots    -> m*1 cell array stores node potential of 'm' trees
%           MT_edgePots    -> m*1 cell array stores edge potentail of 'm' trees

MT_edgeStructs = container.Map;
MT_nodePots = containers.Map;
MT_edgePots = containers.Map;

if option == 1
    % generate the MI mat first
    miXY = CalculateMutualInfoMatrix(fUV, nNodes);
    % run maximum spanning tree algorithm on randomly shuffled MI matrix
    for is = 1:m
        ridx = randperm(nNodes);
        cidx = randperm(nNodes);
        miXY = miXY(ridx,:);
        miXY = miXY(:,cidx);
        mi_half = triu(miXY,1);
        Aff = MaxSpan(mi_half + mi_half');
        % graph struct
        MT_edgeStructs(is) = UGM_makeEdgeStruct(Aff, nStates);
        % graph node potential
        MT_nodePots(is) = ones(nNodes, nStates);
        % graph edge potentail
        MT_edgePots(is) = GetEdgePot(MT_edgeStructs(is), fUV, nStates);
    end
    
else % option == 2
    
end


