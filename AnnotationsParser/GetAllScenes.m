function [ scenes ] = GetAllScenes( list )
%GETALLSCENES Get list of scenes from list of paths
%   list: list of paths
%   scenes: map where keys are scenes and values are indices to examples

scenes = containers.Map;

for i = 1:length(list)
   scene = GetSceneFromPath(list{i});
   if isKey(scenes, scene)
       scenes(scene) = [scenes(scene); i];
   else
       scenes(scene) = i;
   end
end

end

