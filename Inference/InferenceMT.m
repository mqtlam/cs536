function [ probs, scenes, bestScene ] = InferenceMT( foundObjects, objectsVocab, edgeStructsMT, nodePotsMT, edgePotsMT, mCoeffsMT, K)
%INFERENCE Perform inference by finding the scene that maximizes probability.
%   foundObjects:   list of object counts
%                           Each cell is a containers.Map
%                           Each map stores the objects found as keys
%                               and the object counts as values
%   objectsVocab:   list of objects vocabulary (from training and test sets)
%   edgeStructsMT:  map where keys are scenes and values are
%                   edgeStructs (UGM) for each tree
%   nodePotsMT:     map where keys are scenes and values are 
%                   node potentials (UGM) for each tree
%   edgePotsMT:     map where keys are scenes and values are 
%                   node potentials (UGM) for each tree
%   K:              number of Trees for a scene
%   probs:          probabilities for each scene
%   scenes:         list of scenes (in order for probs)
%   bestScene:      scene with maximum probability

    nNodes = length(objectsVocab);

    %% for convenience: map object name to index
    objectsVocabMap = containers.Map;
    for i = 1:nNodes
        objectsVocabMap(objectsVocab{i}) = i;
    end

    %% loop through all scenes
    scenes = keys(nodePotsMT);
    probs = zeros(length(scenes), 1);
    sceneIndex = 1;
    for s = scenes
        scene = s{1};
        nodePots = nodePotsMT(scene);
        edgePots = edgePotsMT(scene);
        edgeStructs = edgeStructsMT(scene);
        mCoeffs = mCoeffsMT(scene);
        
        %% Compute Partition function
        logZs = ComputeKPartitionFunctions(edgeStructs, nodePots, edgePots, K);
        %% compute configuration
        configuration = zeros(nNodes, 1);
        objects = keys(foundObjects);
        presentIndices = [];

        %% loop through all objects found in example
        for o = objects
            obj = o{1};
            index = objectsVocabMap(obj);
            presentIndices = union(presentIndices, index);
            configuration(index) = 1;
        end

        %% set all non found objects as absent
        for index = setdiff(1:nNodes, presentIndices)
            configuration(index) = 2;
        end
        
        prob = 0;
        %% For all trees compute joint probability
        parfor k=1:K
            prob = prob + mCoeffs(k) * ComputeJointProbability(edgeStructs{k,1}, ...
                nodePots{k,1}, edgePots{k,1}, configuration, nNodes, logZs{k,1});            
        end
        
        probs(sceneIndex) = prob;
        sceneIndex = sceneIndex + 1;
    end
    %% set the best scene
    [~, index] = max(probs);
    bestScene = scenes(index);

    scenes = scenes';
end
