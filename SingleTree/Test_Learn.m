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
% draw graph demo
object_to_draw = 'bedroom';
DrawGraph(edgeStructMap(object_to_draw), nodePotMap(object_to_draw), edgePotMap(object_to_draw), foundObjectsVocab, 'draw_nodepot', 1, 'draw_edgepot', 1);

