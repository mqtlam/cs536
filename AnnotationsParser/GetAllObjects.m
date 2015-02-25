function [ objectList ] = GetAllObjects( filename )
%GETALLOBJECTS Get the names of all objects from the object names file
%   filename:   file with every object class name per line
%   objectList: Nx1 cell of strings where N=# objects

try
   objectList = textread(filename, '%s', 'delimiter', '\n');
catch
   error('Failed to read text file %s.', filename);
end

% convert entries to lower case
objectList = lower(objectList);

end

