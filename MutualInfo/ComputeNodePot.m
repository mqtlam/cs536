function [ nodePot ] = ComputeNodePot( objectsList, objectsVocab )
% Calculate the node potential: Frequency of presence/absence of object in
% the data set.
% Parameters:
%   - objectsList   : List of objects found in image data set.
%   - objectVocab   : Collection of all the objects found.
% Output:
%   - nodePot        : Potential of each node

    % # discrete states of variable
    nStates = 2;
    nVocab = size(objectsVocab, 1);
    nSamples = size(objectsList, 1);
    
    % Current Implementation of Node Potential:
    % The frequencey of presence and absence of an object in the data set
    % Node potential: 
    nodePot = zeros(nVocab, nStates);
    for v=1:nVocab
        count = 0;
        for i=1:nSamples            
            if(isKey(objectsList{i}, objectsVocab(v)))
                count = count + 1;
            end            
        end
        nodePot(v,1) = count/nSamples;
        nodePot(v,2) = 1 - nodePot(v,1);
    end      
end

