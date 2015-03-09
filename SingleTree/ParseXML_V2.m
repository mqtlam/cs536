function objectMap = ParseXML_V2(DOMNode)
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

