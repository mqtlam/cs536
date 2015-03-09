function [ scene ] = GetSceneFromPath( path )
%GETSCENEFROMPATH
%   path:   example:    'a/abbey/sun_aaalbzqrimafwbiv'
%   scene:  example:    'abbey'

scene = fileparts(path(3:end));

end

