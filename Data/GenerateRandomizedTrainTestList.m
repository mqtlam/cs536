function GenerateRandomizedTrainTestList(scenesPercent, trainPercent, outTrainFile, outTestFile)
%GENERATERANDOMIZEDTRAINTESTLIST Generate training/test splits
%   scenesPercent:  rough percentage of all scenes to put into training/test
%   trainPercent:   percentage of images in each scene for training
%   outTrainFile:   path to output training file
%   outTestFile:    path to output test file

%% constants
MINIMUM_NUM_EXAMPLES = 10;
ALL_SCENES_FILE = 'AllScenesList.txt';
ANNOTATIONS_PATH = 'Data/Annotations/'; 

%% read in scenes
try
   scenesList = textread(fullfile('Data', ALL_SCENES_FILE), '%s', 'delimiter', '\n');
catch
   error('Failed to read text file %s.', fullfile('Data', ALL_SCENES_FILE));
end

%% only process a subset of the scenes based on scenesPercent
nTotalScenes = length(scenesList);
nScenes = floor(scenesPercent * nTotalScenes);

scenesList = scenesList(randperm(nTotalScenes));
scenesList = scenesList(1:nScenes, :);

%% process the scenes' image examples
trainList = {};
testList = {};
for ic = 1:1:length(scenesList)
    foldersList = dir([ANNOTATIONS_PATH scenesList{ic,1} '/*.xml']);
    imagelist = {foldersList.name};
    
    if length(imagelist) <= MINIMUM_NUM_EXAMPLES
        continue;
    end
    
    % follow the convention of 'SmallTrainList.txt'
    count = 0;
    examplesList = {};
    for i = imagelist
        count = count + 1;
        xmlname = cell2mat(i);
        examplesList{count} = [scenesList{ic,1} '/' xmlname(1:end-4)]; 
    end
    examplesList = examplesList';
    examplesList = examplesList(randperm(size(examplesList,1)));
    
    nTraining = floor(trainPercent * size(examplesList,1));
    
    trainList = vertcat(trainList, examplesList(1:nTraining, :));
    testList  = vertcat(testList, examplesList(nTraining+1:end, :));
end

%% save to file
fid1 = fopen(outTrainFile,'w');  
format = '%s\n';
for j = 1:1:size(trainList,1)
    fprintf(fid1,format,trainList{j,1});
end
fclose(fid1);

fid2 = fopen(outTestFile,'w');  
format = '%s\n';
for j = 1:1:size(testList,1)
    fprintf(fid2,format,testList{j,1});
end
fclose(fid2);

end