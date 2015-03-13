function [MT_edgeStructs, MT_nodePots, MT_edgePots] = GenerateInitMT( nNodes, nStates, K, samples, option )

% Input:    nNodes  -> # of nodes 
%           K       -> # of mixture trees
%           samples -> pairwise frequency over all nodes
%           option  -> 1. generate the MI mat, then shuffle rows and cols
%                      2. split the scene instances into 'm' groups, then build tree seperately
% Output:   MT_edgeStructs -> m*1 cell array stores structures of 'm' trees
%           MT_nodePots    -> m*1 cell array stores node potential of 'm' trees
%           MT_edgePots    -> m*1 cell array stores edge potentail of 'm' trees

MT_edgeStructs = cell(K,1);
MT_nodePots = cell(K,1);
MT_edgePots = cell(K,1);

PRIOR = 0.1;
if option == 1
    fUV = CalculateVariableStatesFreq(nStates, nNodes, samples);
    % generate the MI mat first
    miXY = CalculateMutualInfoMatrix(fUV, nNodes);
    % run maximum spanning tree algorithm on randomly shuffled MI matrix
    for k=1:K
        ridx = randperm(nNodes);
        cidx = randperm(nNodes);
        miXY = miXY(ridx,:);
        miXY = miXY(:,cidx);
        mi_half = triu(miXY,1);
        Aff = MaxSpan(mi_half + mi_half');
        % graph struct
        edgeStruct = UGM_makeEdgeStruct(Aff, nStates);
        % graph node potential
        nodePot = ones(nNodes, nStates);
        % graph edge potential
        edgePot = GetEdgePot(edgeStruct, fUV, nStates);
        edgePot = edgePot + PRIOR;
        %% (optional: normalize)
        for index = 1:nNodes
            nodePot(index, :) = nodePot(index, :)./sum(nodePot(index, :));
        end
        for e = 1:edgeStruct.nEdges
            edgePot(:, :, e) =  edgePot(:, :, e)./sum(sum(edgePot(:, :, e)));
        end
        MT_edgeStructs{k,1} = edgeStruct;
        MT_nodePots{k,1} = nodePot;
        MT_edgePots{k,1} = edgePot;
    end 
end
%% Option #2: Randomize the data and pick 30% of data for each tree
if(option == 2)
    N = size(samples,2);
    n = int64(N * 0.3);
    for k=1:K
        randOrder = randperm(N);
        indeces = randOrder(1:n);
        newSample = samples(:,indeces);
        fUV = CalculateVariableStatesFreq(nStates, nNodes, newSample);
        % Calculate MI
        miXY = CalculateMutualInfoMatrix(fUV, nNodes);
        Aff = MaxSpan(miXY);
        % graph struct
        edgeStruct = UGM_makeEdgeStruct(Aff, nStates);
        % graph node potential
        nodePot = ones(nNodes, nStates);
        % graph edge potential
        edgePot = GetEdgePot(edgeStruct, fUV, nStates);
        edgePot = edgePot + PRIOR;
        %% (optional: normalize)
        for index = 1:nNodes
            nodePot(index, :) = nodePot(index, :)./sum(nodePot(index, :));
        end
        for e = 1:edgeStruct.nEdges
            edgePot(:, :, e) =  edgePot(:, :, e)./sum(sum(edgePot(:, :, e)));
        end
        MT_edgeStructs{k,1} = edgeStruct;
        MT_nodePots{k,1} = nodePot;
        MT_edgePots{k,1} = edgePot;
    end
end
%% Option #3: Partition samples into groups of different sizes, use group proportion as mixture coefficients
if(option == 3)
    
end
end


