function [ foundObjectsList, trainList ] = ParseSUNAnnotations( trainFilePath, datasetPath )
%PARSEANNOTATIONS Parse SUN Dataset annotations into object counts
%   trainFilePath:      path to train file listing training examples per line
%   datasetPath:        path to SUN Dataset folder (SUN2012)
%   foundObjectsList:   list of object counts
%                           Each cell is a containers.Map
%                           Each map stores the objects found as keys
%                               and the object counts as values
%   trainList:          list of training examples parsed

%% constants
ANNOTATIONS_FOLDER = 'Annotations';
XML_EXT = '.xml';

%% read in XML file
try
   trainList = textread(trainFilePath, '%s', 'delimiter', '\n');
catch
   error('Failed to read text file %s.', trainFilePath);
end

%% loop over every image in train list and parse xml file
foundObjectsList = cell(length(trainList), 1);
for i = 1:length(trainList)
    img = trainList{i};
    xmlPath = fullfile(datasetPath, ANNOTATIONS_FOLDER, [img XML_EXT]);
    DOMNode = xmlread(xmlPath);
    objectMap = ParseXML(DOMNode);
    foundObjectsList{i} = objectMap;
end

end

function objectMap = ParseXML(DOMNode)
%PARSEXML Helper function to parse XML

%% create map to store found objects as keys and counts as values
objectMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');

%% get the annotation node
annotationNode = DOMNode.getDocumentElement;

%% get the children of annotation node and find the object node
annotationChildren = annotationNode.getChildNodes;
node = annotationChildren.getFirstChild;
while ~isempty(node)
    %% whenever an object node is found, find the name node
    if strcmpi(node.getNodeName, 'object')
        %% get the children of the object node and find the name node
        objectChildren = node.getChildNodes;
        node2 = objectChildren.getFirstChild;
        while ~isempty(node2)
            if strcmpi(node2.getNodeName, 'name')
                break;
            else
                node2 = node2.getNextSibling;
            end
        end
        
        %% store object name in list
        name = node2.getTextContent;
        name = strtrim(char(name));
        
        if isKey(objectMap, name)
            objectMap(name) = objectMap(name) + 1;
        else
            objectMap(name) = 1;
        end
    end
    node = node.getNextSibling;
end

end

