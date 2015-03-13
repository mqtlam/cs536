function [ logZs ] = ComputeKPartitionFunctions( edgeStructs, nodePots, edgePots, K )
%COMPUTEPARTITIONFUNCTIONS Summary of this function goes here
%   Detailed explanation goes here

logZs = cell(K,1);

%% loop through all K
for k=1:K
    nodePot = nodePots{k,1};
    edgePot = edgePots{k,1};
    edgeStruct = edgeStructs{k,1};

    %% compute partition function
    [~, ~, logZ] = UGM_Infer_Tree(nodePot,edgePot,edgeStruct);
    
    logZs{k,1} = logZ;
end

end

