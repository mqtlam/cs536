function [ jp ] = ComputeJointProbability( edgeStruct, nodePots, edgePots, sample, nNodes, logZ )
%ComputeJointProbability: Compute joint probabiltiy of sample given the
%tree parameters
%   Parameters:
%   - edgeStruct    : Edge Structs
%   - nodePots      : Node Potentials
%   - edgePots      : Edge Potentials
%   - sample        : One sample
%   - logZ          : Partition function
%   Output:
%   - jp            : Joint Probability of ith observation
    %% Compute Joint Probability
    prob = 0;
    % over nodes
    for i=1:nNodes
        prob = prob + log(nodePots(i, sample(i)));
    end
    
    % over edges
    for e = 1:edgeStruct.nEdges 
        edgeEnds = edgeStruct.edgeEnds(e,:);
        prob = prob + log(edgePots(sample(edgeEnds(1)), sample(edgeEnds(2)), e));
    end
    prob = prob - logZ;
    jp = exp(prob);
end

