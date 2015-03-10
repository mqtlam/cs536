function [ scenePathMap ] = GetTopKScenes( dataSetPath, K )
%GetTopKScenes: Print the top K scences in terms of # image files
%   Parameter:
%   - dataSetPath   : path to SUN Dataset annotation folder
%   - K             : top K scenes
 %% Read all folders in dataset annotation folder
    sceneMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');
    scenePathMap = containers.Map('KeyType', 'char', 'ValueType', 'char');
    scene = containers.Map('KeyType', 'int32', 'ValueType', 'char');
    foldersList = dir(fullfile(dataSetPath, '\*'));
    % Only folders in directory
    foldersList = foldersList(~strncmpi('.', {foldersList.name}, 1));
    avgImgs = 0;
    sceneCount = 0;
    sceneImgsCount = zeros(1,1);
    idx = 1;
    for i=1:size(foldersList)
        folderName = foldersList(i).name;
        subFoldersList = dir(fullfile(dataSetPath,'\',folderName));
        % Only folders
        subFoldersList = subFoldersList(~strncmpi('.', {subFoldersList.name}, 1));
        for j=1:size(subFoldersList)
            sceneFolderName = subFoldersList(j).name;
            fileList = dir(fullfile(dataSetPath,'\',folderName,'\',sceneFolderName,'\*.xml'));
            if (isKey(sceneMap, sceneFolderName) == 0)
                imgCount = length(fileList);
                sceneMap(sceneFolderName) = imgCount;
                scenePathMap(sceneFolderName) = fullfile(dataSetPath,'\',folderName,'\',sceneFolderName);
                sceneImgsCount(idx) = imgCount;
                scene(idx) = sceneFolderName;
                % Ignore sub-scenes for now
                if(imgCount ~= 0)
                    avgImgs = avgImgs + imgCount;
                    sceneCount = sceneCount + 1;
                end
                idx = idx + 1;
            end
        end
    end
    
    % Average number of images for each scene class
    avgImgs = int16(avgImgs/sceneCount);
    fprintf('\nAverage number of images per scene: %i\n', avgImgs);

    [sorted, sIdx] = sort(sceneImgsCount, 'descend');
    
    % Top K scenes
    for s=1:K
        fprintf('\n%s : %d',scene(sIdx(s)), sorted(s));
    end
    fprintf('\nDone!\n');
end

