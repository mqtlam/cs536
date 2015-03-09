%% simple demo

%% setup paths
setup;

%% --- parse annotations

%% get object counts
datasetPath = 'K:/Datasets/SUNDataset/SUN2012'; % change this
[foundObjectsList, trainList] = ParseSUNAnnotations('Data/SmallTrainList.txt', datasetPath);

%% get all object class names found during the parsing (smaller vocabulary)
foundObjectsVocab = GetFoundObjects(foundObjectsList);

%% get all possible object class names in the entire dataset
objectsVocab = GetAllObjects('Data/AllObjectsList.txt');
