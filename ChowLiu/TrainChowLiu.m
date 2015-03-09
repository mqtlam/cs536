function [ edgeStructs, nodePots, edgePots ] = TrainChowLiu( foundTrainObjectsList, scenes, objectsVocab )
%TRAINCHOWLIU Train graphical model by Chow Liu algorithm.
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

%% initialization
edgeStructs = containers.Map;
nodePots = containers.Map;
edgePots = containers.Map;

nNodes = length(objectsVocab);
nStates = 2;

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
    
    %% preprocess
    samples = PreprocessData(foundTrainObjectsList, objectsVocab);
    % TODO: use scene information
    
    %% compute mutual information
    fUV = CalculateVariableStatesFreq(nStates, nNodes, samples);
    miXY = CalculateMutualInfoMatrix(fUV, nNodes);
    
    %% run maximum spanning tree algorithm
    Aff = MaxSpan(miXY);
    
    %% construct data structures for UGM:
    
    %% construct edge struct
    edgeStruct = UGM_makeEdgeStruct(Aff, nStates);
    
    %% construct node potential
    % 1 = present, 2 = absent
    nodePot = ones(nNodes, nStates);
    
    %% construct edge potentials
    edgePot = GetEdgePot(edgeStruct, fUV, nStates);
    edgePot = edgePot + PRIOR;
    
    %% update
    edgeStructs(scene) = edgeStruct;
    nodePots(scene) = nodePot;
    edgePots(scene) = edgePot;
end

end

