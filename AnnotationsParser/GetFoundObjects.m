function [ foundObjectsVocab ] = GetFoundObjects( foundObjectsList )
%GETFOUNDOBJECTS Get the names of all objects that were found after parsing
%   foundObjectsList:   list of object counts
%                           Each cell is a containers.Map
%                           Each map stores the objects found as keys
%                               and the object counts as values
%   foundObjectsVocab:  list of all object names found in foundObjectsList

foundObjectsVocab = {};
for i = 1:length(foundObjectsList)
    foundObjectsVocab = union(foundObjectsVocab, keys(foundObjectsList{i}));
end

end

