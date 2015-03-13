% Test: Mutual Information
clear
clc
% Simulate m samples with n variables
% m = 20
% n = 10
% Elements of vector represents presence/absence of variable in sample
% Present   = 1
% Absent    = 0;

samples = randi([1,2], 10, 300);

% Number of variables
nVar = size(samples, 1);

% Number of variable's discrete values
nStates = 2;

fUV = CalculateVariableStatesFreq(nStates, nVar, samples);
disp(fUV);
miXY = CalculateMutualInfoMatrix(fUV, nVar);
disp(miXY);