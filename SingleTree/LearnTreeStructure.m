function [nodePotMap,edgePotMap,edgeStructMap] = LearnTreeStructure(foundObjectsVocab, foundObjectsList, sceneIdxMap, sceneList)
%LearnTreeStructure: Learn Tree structure and parameters for each scene
% Parameters:
%   - foundObjectsVocab : union of all objects
%   - foundObjectsList  : all objects from all scenes
%   - sceneIdxMap       : key = scene, value = last index of scene's object
%   - sceneList         : list of all scenes
% Output: Key = scene
%   - nodePotMap        : value = node potential
%   - edgePotMap        : value = edge potential
%   - edgeStructMap     : value = edge structure
    %% Number of variables
    nVars = size(foundObjectsVocab, 1);

    % Number of scenes
    nScenes = length(sceneList);
    
    % Number of variable's discrete values
    nStates = 2;

    % Store edgeStruct, edgePot and nodePot for all scenes
    edgeStructMap = containers.Map;
    nodePotMap = containers.Map;
    edgePotMap = containers.Map;

    % Learn tree structure & potentials for each scene class
    objIdxStart = 1;
    for i=1:nScenes
        sceneClass = sceneList{i};
        objIdxEnd = sceneIdxMap(sceneClass);
        idx = 1;
        tempObjectsList = cell(objIdxEnd - objIdxStart + 1, 1);
        while(objIdxStart <= objIdxEnd)
            % Get objectsList corresponding to the current scene class
            tempObjectsList{idx,1} = foundObjectsList{objIdxStart};
            idx = idx + 1;
            objIdxStart = objIdxStart + 1;
        end
        % Vectorize input data
        tempVectorized = PreprocessData(tempObjectsList, foundObjectsVocab);
        objIdxStart = objIdxEnd + 1;

        % Compute weight for all combination of states of two variables
        fUV = CalculateVariableStatesFreq(nStates, nVars, tempVectorized);

        % Compute Mutual Information
        miXY = CalculateMutualInfoMatrix(fUV, nVars);
        disp(miXY);

        % Construct maximum spanning tree
        adjMat = MaxSpan(miXY);

        % Compute Node Potential
        nodePot = ComputeNodePot(tempObjectsList, foundObjectsVocab);
        nodePotMap(sceneClass) = nodePot;

        % Construct Edge structure using adjacency matrix
        edgeStruct = UGM_makeEdgeStruct(adjMat ,nStates);
        edgeStructMap(sceneClass) = edgeStruct;

        % Compute Edge potential
        edgePot = GetEdgePot(edgeStruct, fUV, nStates);
        edgePotMap(sceneClass) = edgePot;

        % Decode: Find the most likely configuration
        %optimalDecoding = UGM_Decode_Tree(nodePot,edgePot,edgeStruct);
    end
end

