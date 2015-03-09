% Test
% 1. Preprocess Data to obtain vectorized data
% 2. Compute Node Potential

% Preprocess Data
vData = PreprocessData(foundObjectsList, foundObjectsVocab);
disp(vData);

% Node Potential
nodePot = ComputeNodePot(foundObjectsList, foundObjectsVocab);
disp(nodePot);