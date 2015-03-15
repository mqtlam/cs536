%% simple demo

%% --- setup
clearvars; % clear workspace
setup; % set up paths

%% --- parse annotations

%% get object counts
datasetPath = 'Data'; % change this
[foundTrainObjectsList, trainList] = ParseSUNAnnotations('Data/MT_trainlist.txt', datasetPath);
[foundTestObjectsList, testList] = ParseSUNAnnotations('Data/MT_testlist.txt', datasetPath);

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

%% DEMO 1: BASELINE MARGINAL INDEPENDENCE
%% training
trainTic = tic;
fprintf('training (marginal independence)... ');
[edgeStructs1, nodePots1, edgePots1] = TrainIndependent(foundTrainObjectsList, trainScenes, objectsVocab);
fprintf('(%fs)\n', toc(trainTic));

%% inference on all test images
bestScenes1 = cell(length(foundTestObjectsList), 1);
hamming1 = zeros(length(foundTestObjectsList), 1);
zTic = tic;
fprintf('computing logZ (marginal independence)... ');
logZs1 = ComputePartitionFunctions(edgeStructs1, nodePots1, edgePots1);

% Create a scene map index
scenes = keys(nodePots1);
nScenes = length(scenes);
sceneIdxMap = containers.Map;
for s=1:nScenes
    sceneIdxMap(scenes{s}) = s;
end
CM1 = zeros(nScenes,nScenes);

%% Start Inference
fprintf('(%fs)\n', toc(zTic));
for i = 1:length(foundTestObjectsList)
    testTic = tic;
    fprintf('testing (marginal independence) on image %d... ', i);
    [probs1, scenes1, bestScene1, idx] = Inference(foundTestObjectsList{i}, objectsVocab, edgeStructs1, nodePots1, edgePots1, logZs1);
    CM1(sceneIdxMap(testSceneList{i}),idx) = CM1(sceneIdxMap(testSceneList{i}),idx) + 1; 
    bestScenes1{i} = bestScene1{1};
    hamming1(i) = strcmp(bestScenes1{i}, testSceneList{i});
    fprintf('correct=%d (%fs)\n', hamming1(i), toc(testTic));
end
disp(CM1);
fprintf('accuracy (marginal independence)=%f\n', sum(hamming1)/numel(hamming1));

%% DEMO 2: CHOW-LIU TREE
%% training
trainTic = tic;
fprintf('training (chow-liu tree)... ');
[edgeStructs2, nodePots2, edgePots2] = TrainChowLiu(foundTrainObjectsList, trainScenes, objectsVocab);
fprintf('(%fs)\n', toc(trainTic));

%% inference on all test images
% Create a scene map index
scenes = keys(nodePots2);
nScenes = length(scenes);
sceneIdxMap = containers.Map;
for s=1:nScenes
    sceneIdxMap(scenes{s}) = s;
end
CM2 = zeros(nScenes,nScenes);
bestScenes2 = cell(length(foundTestObjectsList), 1);
hamming2 = zeros(length(foundTestObjectsList), 1);
zTic = tic;
fprintf('computing logZ (chow-liu tree)... ');
logZs2 = ComputePartitionFunctions(edgeStructs2, nodePots2, edgePots2);
fprintf('(%fs)\n', toc(zTic));
for i = 1:length(foundTestObjectsList)
    testTic = tic;
    fprintf('testing (chow-liu tree) on image %d... ', i);
    
    [probs2, scenes2, bestScene2, idx] = Inference(foundTestObjectsList{i}, objectsVocab, edgeStructs2, nodePots2, edgePots2, logZs2);
    CM2(sceneIdxMap(testSceneList{i}),idx) = CM2(sceneIdxMap(testSceneList{i}),idx) + 1; 
    bestScenes2{i} = bestScene2{1};
    hamming2(i) = strcmp(bestScenes2{i}, testSceneList{i});
    fprintf('correct=%d (%fs)\n', hamming2(i), toc(testTic));
end
fprintf('accuracy (chow-liu tree)=%f\n', sum(hamming2)/numel(hamming2));
disp(CM2);
% % draw graph demo
% object_to_draw = 'beach';
% DrawGraph(edgeStructs2(object_to_draw), nodePots2(object_to_draw), edgePots2(object_to_draw), objectsVocab, 'draw_nodepot', 1, 'draw_edgepot', 1);
