function DrawGraph( edgeStruct, nodePot, edgePot, objectsVocab, varargin )
%DRAWGRAPH Draw graphical model
%   edgeStruct:            UGM edge structure
%   nodePot:               UGM node potentials
%   edgePot:               UGM edge potentials
%   objectsVocab:          list of objects vocabulary (from training and test sets)
%
%   Optional arguments should be passed as name/value pairs at the end
%   'draw_nodepot':         1 = if draw node potentials, 0 otherwise (default)
%   'draw_edgepot':         1 = if draw edge potentials, 0 otherwise (default)
%   'output_file':          path to output PDF visualization file
%                               default is 'graph.pdf'

%% constants
DRAW_NODE_POTENTIALS = 0;
DRAW_EDGE_POTENTIALS = 0;

DOT_PROGRAM = '"C:\\Program Files (x86)\\Graphviz2.38\\bin\\dot"';
TEMP_DOT_FILE = 'tmp.dot';
OUTPUT_PDF_FILE = 'graph.pdf';

%% parse optional arguments
for i = 1:2:nargin-4
    switch varargin{i}
        case 'draw_nodepot', DRAW_NODE_POTENTIALS = varargin{i+1};
        case 'draw_edgepot', DRAW_EDGE_POTENTIALS = varargin{i+1};
        case 'output_file', OUTPUT_PDF_FILE = varargin{i+1};
        case 'dot_path', DOT_PROGRAM = varargin{i+1};
        case 'temp_file', TEMP_DOT_FILE = varargin{i+1};
    end
end

%% variables
[nNodes, ~] = size(nodePot);
nEdges = size(edgeStruct.edgeEnds, 1);

%% construct adjacency matrix
adjMat = zeros(nNodes, nNodes);
for i = 1:nEdges
    adjMat(edgeStruct.edgeEnds(i, 1), edgeStruct.edgeEnds(i, 2)) = 1;
    adjMat(edgeStruct.edgeEnds(i, 2), edgeStruct.edgeEnds(i, 1)) = 1;
end

%% construct 
nodePotLabels = cell(1, nNodes);
for i = 1:nNodes
    if DRAW_NODE_POTENTIALS
        nodePotLabels{i} = [objectsVocab{i} '\n'...
            'P=' num2str(nodePot(i, 1)) '\n'...
            'A=' num2str(nodePot(i, 2))];
    else
        nodePotLabels{i} = objectsVocab{i};
    end
end

edgePotLabels = cell(nNodes, nNodes);
for e = 1:nEdges
    label = ['PP=' num2str(edgePot(1, 1, e)) ' '...
        'PA=' num2str(edgePot(1, 2, e)) '\n'...
        'AP=' num2str(edgePot(2, 1, e)) ' '...
        'AA=' num2str(edgePot(2, 2, e))];
    
    edgePotLabels{edgeStruct.edgeEnds(e, 1), edgeStruct.edgeEnds(e, 2)} = label;
    edgePotLabels{edgeStruct.edgeEnds(e, 2), edgeStruct.edgeEnds(e, 1)} = label;
end

%% save to temp dot file
if DRAW_EDGE_POTENTIALS
    graph_to_dot(adjMat, 'node_label', nodePotLabels, ...
        'arc_label', edgePotLabels, 'directed', 0, 'filename', TEMP_DOT_FILE);
else
    graph_to_dot(adjMat, 'node_label', nodePotLabels, ...
        'directed', 0, 'filename', TEMP_DOT_FILE);
end

%% create PDF from dot file
dos([DOT_PROGRAM ' -Tpdf ' TEMP_DOT_FILE ' -o ' OUTPUT_PDF_FILE]);
winopen(OUTPUT_PDF_FILE);
delete(TEMP_DOT_FILE);

end

