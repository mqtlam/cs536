function [ logZs ] = ComputePartitionFunctions( edgeStructs, nodePots, edgePots )
%COMPUTEPARTITIONFUNCTIONS Summary of this function goes here
%   Detailed explanation goes here

logZs = containers.Map;

%% loop through all scenes
scenes = keys(nodePots);
for s = scenes
    scene = s{1};
    nodePot = nodePots(scene);
    edgePot = edgePots(scene);
    edgeStruct = edgeStructs(scene);

    %% compute partition function
    [~, ~, logZ] = UGM_Infer_Tree(nodePot,edgePot,edgeStruct);
    
    logZs(scene) = logZ;
end

end

