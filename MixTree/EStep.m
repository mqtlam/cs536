function [ P, uGamma ] = EStep( edgeStructsMap, nodePotsMap, edgePotsMap, lambdaMap, D, K )
% EStep: E step of Expected Maximization: Compute Expectation
%   Parameters:
%   - edgeStructsMap : edgeStructs of K trees
%   - nodePotsMap    : nodePots of K trees
%   - edgePotsMap    : edgePots of K trees
%   - lambdaMap      : Mixture coefficient of K trees.
%   - D              : Vectorized Samples.
%   Output:
%   - P              : Distribution over V (all objects)

% Note: lGamma - (Posterior probability P[z(i) = k | V = x(i)] of
% hidden variable = k given the ith observation)
    %% Compute un-normalized lGamma
    
    % Number of nodes
    nNodes = size(D,1);    
    N = size(D);
    
    lGamma = zeros(N,K);
    logZMap = ComputePartitionFunctions(edgeStructsMap, nodePotsMap, edgePotsMap);
    
    for i=1:N
        for k=1:K
            lGamma(i,k) = lambdaMap(k) * ComputeJointProbability(edgeStructsMap(k), ...
                nodePotsMap(k), edgePotsMap(k), D(:,i), nNodes, logZMap);
        end
        % Normalize lGamma
        lGamma(i,:) = lGamma(i,:)/sum(lGamma(i,:));
    end
   
    uGamma = zeros(1,K); 
    for k=1:K
        uGamma(k) = sum(lGamma(:,k));
    end
    
    P = zeros(N,K);
    for k=1:K
        for i=1:N
            P(i,k) = lgamma(i,k) / uGamma(k);
        end
    end
    
    %P = zeros(nNodes,nNodes,K);
    %for v1=1:nNodes
    %    for v2=v1+1:nNodes        
    %    end
    %end
end

