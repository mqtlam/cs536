% Test: Mutual Information
%clear all
clc
% Simulate m samples with n variables
% m = 20
% n = 10
% Elements of vector represents presence/absence of variable in sample
% Present   = 1
% Absent    = 0;

samples = randi([0,1], 10, 300);

% Number of variables
nVar = size(samples, 1);

% Number of variable's discrete values
nStates = 2;

nUV = zeros(nStates, nStates, nVar, nVar);
fUV = zeros(nStates, nStates, nVar, nVar);

% Pairwise comparison between variables = n(n-1)/2 edges
for i=1:nVar
    for j=i+1:nVar
        % Calculate # samples for all combination of states
        nUV(:,:,i,j) = CountV1V2s1s2(i, j, nStates, samples);
        
        % (*) Can remove the line below and change (**)
        nUV(:,:,j,i) = nUV(:,:,i,j)';
        
        % Maximum Likelihood Estimator for p(V1, V2)
        sumUV = sum(sum(nUV(:,:,i,j)));
        fUV(:,:,i,j) = nUV(:,:,i,j)/sumUV;
        fUV(:,:,j,i) = nUV(:,:,j,i)/sumUV;
        % (**) Add the line below
        % fUV(:,:,j,i) = nUV(:,:,i,j)'/sumUV;
    end
end

% Mutual Information
miXY = zeros(nVar, nVar);
for i=1:nVar
    for j=i+1:nVar
        miXY(i,j) = ComputeMI(i, j, fUV);
    end
end

miXY = miXY + miXY';
miXY
