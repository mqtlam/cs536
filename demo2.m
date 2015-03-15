%% simple demo

%% --- setup
clearvars; % clear workspace
clc
setup; % set up paths

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
for i = 1:length(foundTestObjectsList)
    testTic = tic;
    fprintf('testing (MT) on image %d... ', i);  
    [probs, scenes, bestScene, idx] = InferenceMT(foundTestObjectsList{i}, objectsVocab, edgeStructsMT, nodePotsMT, edgePotsMT, mCoeffsMT, K);
    bestScenes3{i} = bestScene{1};
    hamming3(i) = strcmp(bestScenes3{i}, testSceneList{i});
    fprintf('correct=%d (%fs)\n', hamming3(i), toc(testTic));
end
fprintf('accuracy (MT)=%f\n', sum(hamming3)/numel(hamming3));