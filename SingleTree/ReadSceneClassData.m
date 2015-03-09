function [ foundObjectsVocab,  foundObjectsList, sceneIdxMap, sceneList] = ReadSceneClassData( fileFullPath, dataSetPath, scenePathMap )
%ReadSceneClassData: Read all files from all folder name in file
%   Parameter:
%   - fileFullPath  : path of the file with train/test scene folder
%   - dataSetPath   : path to SUN Dataset annotation folder
%   Output:
%   - foundObjectsVocab : union of all objects
%   - foundObjectsList  : all objects from all scenes
%   - sceneIdxMap       : key = scene, value = last index of scene's object
%   - sceneList         : list of all scenes
    %% Read the scene folders name from file  
    fprintf('Reading data ...\n');
    try
       sceneList = textread(fileFullPath, '%s', 'delimiter', '\n');
    catch
       error('Failed to read text file %s.', fileFullPath);
    end
    
    sceneIdxMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');
    idx = 1;
    for i=1:size(sceneList)
        scene = sceneList{i};
        scenePath = scenePathMap(scene);
        % Get all file from folder
        filesList = dir(fullfile(scenePath,'\*.xml'));
        sceneIdxMap(scene) = idx + 20 - 1;

        % Currently read only 20 image files from each scene folder
        for f=1:20
            fileFullPath = fullfile(scenePath,'\',filesList(f).name);
            try
                DOMNode = xmlread(fileFullPath);
            catch
                error('Failed to read text file %s.', fileFullPath);
            end
            objectMap = ParseXML_V2(DOMNode);
            foundObjectsList{idx,1} = objectMap;
            idx = idx + 1;
        end
    end    
    %% get all object class names found during the parsing (smaller vocabulary)
    foundObjectsVocab = GetFoundObjects(foundObjectsList);
    foundObjectsVocab = lower(foundObjectsVocab);
    fprintf('Done!!\n');
end

