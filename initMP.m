% Initialize Matlab pool for parallel processing
% Query whether pool exists
if (isempty(gcp('nocreate')) == 0)
    delete(gcp('nocreate'));
end
parpool(2);
