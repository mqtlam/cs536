function [ logZs ] = ComputeKPartitionFunctions( edgeStructs, nodePots, edgePots, K )
%COMPUTEPARTITIONFUNCTIONS Summary of this function goes here
%   Detailed explanation goes here

logZs = cell(K,1);

%% loop through all K
for k=1:K
    nodePot = nodePots(k);
    edgePot = edgePots(k);
    edgeStruct = edgeStructs(k);

    %% compute partition function
    [~, ~, logZ] = UGM_Infer_Tree(nodePot,edgePot,edgeStruct);
    
    logZs(k) = logZ;
end

end

