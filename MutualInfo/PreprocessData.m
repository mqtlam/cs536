function [ vectorizedData ] = PreprocessData( objectsList, objectsVocab )
% Convert the objects found in each image into vectorized data
% Parameters:
%   - objectsList   : List of objects found in image data set.
%   - objectVocab   : Collection of all the objects found.
% Output:
%   - vectorizedData : Feature in the vector represents object
%   present/absent.
   
    nVocab = size(objectsVocab, 1);
    nSamples = size(objectsList, 1);
    
    vectorizedData = zeros(nVocab, nSamples);
    for i=1:nSamples
       for v=1:nVocab
            % Present = 1; Absent  = 2
            if(isKey(objectsList{i},objectsVocab(v)))
                vectorizedData(v,i) = 1;
            else
                vectorizedData(v,i) = 2;
            end
       end        
    end          
end

