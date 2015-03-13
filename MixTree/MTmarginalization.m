function [Puv] = MTmarginalization(sparseTable, Pk, nStates)

nVar = size(sparseTable,2);
Puv = zeros(nStates, nStates, nVar, nVar);

for i=1:nVar
    for j=i+1:nVar
        % Calculate # samples for all combination of states
        Puv(:,:,i,j) = Pmargin(i,j,nStates,sparseTable, Pk);
        
        % (*) Can remove the line below and change (**)
        Puv(:,:,j,i) = Puv(:,:,i,j)';
        
        % Maximum Likelihood Estimator for p(V1, V2)
        sumUV = sum(sum(Puv(:,:,i,j)));
        Puv(:,:,i,j) = Puv(:,:,i,j)/sumUV;
        Puv(:,:,j,i) = Puv(:,:,j,i)/sumUV;
        % (**) Add the line below
        % fUV(:,:,j,i) = nUV(:,:,i,j)'/sumUV;
    end
end


end

function [puv] = Pmargin(v1,v2,nStates, sparseTable, Pk)

puv = zeros(nStates);
for s1=1:nStates
    for s2=1:nStates
        puv_idx = find( sparseTable(:,v1) == s1 & sparseTable(:,v2) == s2 );
        puv(s1,s2) = sum(Pk(puv_idx)); 
    end
end

end