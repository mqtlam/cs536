% Test Preprocess Data to obtain vectorized data and compute Node Potential

% Preprocess Data
vData = PreprocessData(foundObjectsList, foundObjectsVocab);
disp(vData);

% Node Potential
nodePot = ComputeNodePot(foundObjectsList, foundObjectsVocab);
disp(nodePot);