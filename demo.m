%% simple demo

%% --- setup
clearvars; % clear workspace
setup; % set up paths

%% --- parse annotations

%% get object counts
datasetPath = 'K:/Datasets/SUNDataset/SUN2012'; % change this
[foundTrainObjectsList, trainList] = ParseSUNAnnotations('Data/SmallTrainList.txt', datasetPath);
[foundTestObjectsList, testList] = ParseSUNAnnotations('Data/SmallTestList.txt', datasetPath);

%% get all object class names found during the parsing (vocabulary)
trainObjectsVocab = GetFoundObjects(foundTrainObjectsList);
testObjectsVocab = GetFoundObjects(foundTestObjectsList);
objectsVocab = union(trainObjectsVocab, testObjectsVocab);

%% get scenes
trainScenes = GetAllScenes(trainList);
testScenes = GetAllScenes(testList);

%% DEMO 1: BASELINE MARGINAL INDEPENDENCE
% train
[edgeStructs, nodePots, edgePots] = TrainIndependent(foundTrainObjectsList, trainScenes, objectsVocab);

% inference
[probs, scenes, bestScene] = Inference(foundTestObjectsList{1}, objectsVocab, edgeStructs, nodePots, edgePots)

% %% DEMO 2: CHOW-LIU TREE TODO
% % train
% [edgeStructs, nodePots, edgePots] = TrainChowLiu(foundTrainObjectsList, trainScenes, objectsVocab);
% 
% % inference
% [probs, scenes, bestScene] = Inference(foundTestObjectsList{1}, objectsVocab, edgeStructs, nodePots, edgePots)
