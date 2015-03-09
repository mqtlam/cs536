% Test
% Test ReadSceneClassData
clear
clc
datasetPath = 'E:\PGM\SUN2012\Annotations';
scenePathMap = GetScenePathMap(datasetPath);

% Load training data
[foundObjectsVocab, foundObjectsList, sceneIdxMap, sceneList] = ReadSceneClassData('E:\PGM\Project\cs536\SingleTree\TrainScenes_3_Scene.txt', datasetPath, scenePathMap);

% Start training: Learn: NodePot, EdgePot, EdgeStruct for each scene class
[nodePotMap,edgePotMap,edgeStructMap] = LearnTreeStructure(foundObjectsVocab, foundObjectsList, sceneIdxMap, sceneList);

% Test: How to do inference??

