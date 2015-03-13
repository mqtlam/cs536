function [ P, uGamma ] = EStep( edgeStructs, nodePots, edgePots, lambdas, D, K )
% EStep: E step of Expected Maximization: Compute Expectation
%   Parameters:
%   - edgeStructs : edgeStructs of K trees
%   - nodePots    : nodePots of K trees
%   - edgePots    : edgePots of K trees
%   - lambdas     : Mixture coefficient of K trees.
%   - D              : Vectorized Samples.
%   Output:
%   - P              : Distribution over V (all objects)

% Note: lGamma - (Posterior probability P[z(i) = k | V = x(i)] of
% hidden variable = k given the ith observation)
    %% Compute un-normalized lGamma
    
    % Number of nodes
    nNodes = size(D,1);    
    N = size(D,2);
    
    lGamma = zeros(N,K);
    logZs = ComputeKPartitionFunctions(edgeStructs, nodePots, edgePots, K);
    
    for i=1:N
        for k=1:K
            lGamma(i,k) = lambdas(k) * ComputeJointProbability(edgeStructs{k,1}, ...
                nodePots{k,1}, edgePots{k,1}, D(:,i), nNodes, logZs{k,1});
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
            P(i,k) = lGamma(i,k) / uGamma(k);
        end
    end
    
    %P = zeros(nNodes,nNodes,K);
    %for v1=1:nNodes
    %    for v2=v1+1:nNodes        
    %    end
    %end
end

