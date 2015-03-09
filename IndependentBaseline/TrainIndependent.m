function [ edgeStructs, nodePots, edgePots ] = TrainIndependent( foundTrainObjectsList, scenes, objectsVocab )
%TRAININDEPENDENT Train graphical model with all marginal independences.
%   Each object node comes from counting presence/absence in images.
%   Each object node also has a uniform prior.
%
%   foundTrainObjectsList:  list of object counts
%                           Each cell is a containers.Map
%                           Each map stores the objects found as keys
%                               and the object counts as values
%   scenes:                 map where keys are scenes and values are indices to examples
%   objectsVocab:           list of objects vocabulary (from training and test sets)
%   edgeStructs:            map where keys are scenes and values are
%                               edgeStructs (UGM)
%   nodePots:               map where keys are scenes and values are 
%                               node potentials (UGM)
%   edgePots:               map where keys are scenes and values are 
%                               edge potentials (UGM)
%
%   note:   edgePots are zeros and edge structs have no edge connections
%           only nodePots are useful here

%% initialization
edgeStructs = containers.Map;
nodePots = containers.Map;
edgePots = containers.Map;

%% control prior here (Laplacian smoothing)
% must be >= 0 where 0 means no prior
% larger values means more data is necessary to overcome prior
PRIOR = 0.1;

%% for convenience: map object name to index
objectsVocabMap = containers.Map;
for i = 1:length(objectsVocab)
    objectsVocabMap(objectsVocab{i}) = i;
end

%% loop through scenes
for s = keys(scenes)
    scene = s{1};
    
    %% construct edge struct
    nNodes = length(objectsVocab);
    nStates = 2;
    edgeStruct = UGM_makeEdgeStruct(zeros(nNodes, nNodes), nStates);
    
    %% construct node potential
    % 1 = present, 2 = absent
    nodePot = PRIOR*ones(nNodes, nStates);
    
    %% loop through all examples of scene
    examples = scenes(scene);
    for ex = 1:length(examples)
        objects = keys(foundTrainObjectsList{examples(ex)});
        presentIndices = [];
        
        %% loop through all objects found in example
        for o = objects
            obj = o{1};
            index = objectsVocabMap(obj);
            presentIndices = union(presentIndices, index);
            nodePot(index, 1) = nodePot(index, 1) + 1;
        end
        
        %% set all non found objects as absent
        for index = setdiff(1:nNodes, presentIndices)
            nodePot(index, 2) = nodePot(index, 2) + 1;
        end
    end
    
    %% construct empty edge potentials
    edgePot = zeros(nStates, nStates, edgeStruct.nEdges);
    
    %% normalize (technically optional but very useful here)
    for index = 1:nNodes
        nodePot(index, :) = nodePot(index, :)./sum(nodePot(index, :));
    end
    
    %% update
    edgeStructs(scene) = edgeStruct;
    nodePots(scene) = nodePot;
    edgePots(scene) = edgePot;
end

end

