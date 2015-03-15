% Initialize Matlab pool for parallel processing
% Query whether pool exists
if (isempty(gcp('nocreate')) == 0)
    delete(gcp('nocreate'));
end

N = 4;
myCluster=parcluster('local'); 
myCluster.NumWorkers = N;
parpool(myCluster,N)
%parpool(2);
