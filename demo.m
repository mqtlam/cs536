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
[edgeStructs1, nodePots1, edgePots1] = TrainIndependent(foundTrainObjectsList, trainScenes, objectsVocab);

% inference
[probs1, scenes1, bestScene1] = Inference(foundTestObjectsList{1}, objectsVocab, edgeStructs1, nodePots1, edgePots1)

%% DEMO 2: CHOW-LIU TREE
% train
[edgeStructs2, nodePots2, edgePots2] = TrainChowLiu(foundTrainObjectsList, trainScenes, objectsVocab);

% inference
[probs2, scenes2, bestScene2] = Inference(foundTestObjectsList{1}, objectsVocab, edgeStructs2, nodePots2, edgePots2)
