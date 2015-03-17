% Draw Tree
scene = 'skyscraper';
%% Chow-Liu Tree
CL = 0;
if(CL == 1)
    load('TwoScenes_Params.mat');
    DrawGraph(edgeStructs2(scene), nodePots2(scene), edgePots2(scene), objectsVocab, 'draw_nodepot', 1, 'draw_edgepot', 1);
end
%% Mixture of Trees
MT = 1;
if(MT == 1)
    load 'TwoScenes_MT_Params.mat';
    edgePots = edgePotsMT(scene);
    nodePots = nodePotsMT(scene);
    edgeStructs = edgeStructsMT(scene);
    K = 3;

    for k=3:3
        edgePot = edgePots{k,1};
        nodePot = nodePots{k,1};
        edgeStruct = edgeStructs{k,1};
    end

    % draw graph demo
    DrawGraph(edgeStruct, nodePot, edgePot, objectsVocab, 'draw_nodepot', 1, 'draw_edgepot', 1);
end