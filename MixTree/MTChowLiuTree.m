function [edgeStruct, nodePot, edgePot] = MTChowLiuTree( Pk, samples )
   
% Input:    Pk      ->  Probability table: row is one tree & cols are instances/samples
%           samples ->  instances of objects present or absent. size: nVocab * nSamples
% Output:   

%% initialization
nNodes = size(samples,1);
nStates = 2;

PRIOR = 0.1;

%% compute mutual information
sparseTable = samples';
if size(sparseTable,1) ~= length(Pk)
    msg = 'MTChosLiuTree has wrong input!';
    error(msg);
end

fUV = MTmarginalization(sparseTable, Pk, nStates);
miXY = CalculateMutualInfoMatrix(fUV, nNodes);

%% run maximum spanning tree algorithm
Aff = MaxSpan(miXY);

%% construct edge struct
edgeStruct = UGM_makeEdgeStruct(Aff, nStates);

%% construct node potential
% 1 = present, 2 = absent
nodePot = ones(nNodes, nStates);

%% construct edge potentials
edgePot = GetEdgePot(edgeStruct, fUV, nStates);
edgePot = edgePot + PRIOR;

%% (optional: normalize)
for index = 1:nNodes
    nodePot(index, :) = nodePot(index, :)./sum(nodePot(index, :));
end
for e = 1:edgeStruct.nEdges
    edgePot(:, :, e) =  edgePot(:, :, e)./sum(sum(edgePot(:, :, e)));
end
end