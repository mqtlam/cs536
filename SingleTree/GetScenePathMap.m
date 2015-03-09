function [ scenePathMap ] = GetScenePathMap( dataSetPath )
%GetScenePathMap Summary of this function goes here
%   Detailed explanation goes here
    %% Read all folders in dataset annotation folder
    scenePathMap = containers.Map('KeyType', 'char', 'ValueType', 'char');
    foldersList = dir(fullfile(dataSetPath, '\*'));
    % Only folders in directory
    foldersList = foldersList(~strncmpi('.', {foldersList.name}, 1));
    for i=1:size(foldersList)
        folderName = foldersList(i).name;
        subFoldersList = dir(fullfile(dataSetPath,'\',folderName));
        % Only folders
        subFoldersList = subFoldersList(~strncmpi('.', {subFoldersList.name}, 1));
        for j=1:size(subFoldersList)
            sceneFolderName = subFoldersList(j).name;
            if (isKey(scenePathMap, sceneFolderName) == 0)
                scenePathMap(sceneFolderName) = fullfile(dataSetPath,'\',folderName,'\',sceneFolderName);
            end
        end
    end
end

