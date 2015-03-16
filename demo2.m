%% simple demo

%% --- setup
clearvars; % clear workspace
clc
setup; % set up paths

s = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(s);

%% --- parse annotations

%% get object counts
datasetPath = 'Data'; % change this
[foundTrainObjectsList, trainList] = ParseSUNAnnotations('Data/MT_trainlist_6.txt', datasetPath);
[foundTestObjectsList, testList] = ParseSUNAnnotations('Data/MT_testlist_6.txt', datasetPath);

%% get all object class names found during the parsing (vocabulary)
trainObjectsVocab = GetFoundObjects(foundTrainObjectsList);
testObjectsVocab = GetFoundObjects(foundTestObjectsList);
objectsVocab = union(trainObjectsVocab, testObjectsVocab);

%% get scenes
trainScenes = GetAllScenes(trainList);
testScenes = GetAllScenes(testList);
testSceneList = cell(length(testList), 1);
for i = 1:length(testList)
   testSceneList{i} = GetSceneFromPath(testList{i}); 
end

%% DEMO 3: Mixture CHOW-LIU TREE
%% training
K = 3;
trainTic = tic;
fprintf('training (MT)... ');
[edgeStructsMT, nodePotsMT, edgePotsMT, mCoeffsMT] = TrainMixTrees(foundTrainObjectsList, trainScenes, objectsVocab, K);
fprintf('(%fs)\n', toc(trainTic));

%% inference on all test images
bestScenes3 = cell(length(foundTestObjectsList), 1);
hamming3 = zeros(length(foundTestObjectsList), 1);
% zTic = tic;
% fprintf('computing logZ (MT)... ');
% fprintf('(%fs)\n', toc(zTic));
scenes = keys(testScenes);
nScenes = length(scenes);
sceneIdxMap = containers.Map;
for s=1:nScenes
    sceneIdxMap(scenes{s}) = s;
end
CM3 = zeros(nScenes,nScenes);
MT_prob = {};
for i = 1:length(foundTestObjectsList)
    testTic = tic;
    fprintf('testing (MT) on image %d... ', i);  
    [probs3, scenes3, bestScene3, idx] = InferenceMT(foundTestObjectsList{i}, objectsVocab, edgeStructsMT, nodePotsMT, edgePotsMT, mCoeffsMT, K);
    CM3(sceneIdxMap(testSceneList{i}),idx) = CM3(sceneIdxMap(testSceneList{i}),idx) + 1; 
    bestScenes3{i} = bestScene3{1};
    hamming3(i) = strcmp(bestScenes3{i}, testSceneList{i});
    MT_prob{i} = probs3;
    fprintf('correct=%d (%fs)\n', hamming3(i), toc(testTic));
end
fprintf('accuracy (MT)=%f\n', sum(hamming3)/numel(hamming3));
disp(CM3);