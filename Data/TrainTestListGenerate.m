% Generate the Train and Test list for MT model

% the path to data annotation folder, change it
path = 'C:\Users\collwe\Desktop\cs536FinalProj\CS536\cs536\Data\Annotations\'; 

% choose the scene you like, change subfolder path here.
scene{1,1} = 'b/beach';  % 97 images
scene{2,1} = 's/street';  % 291 images
scene{3,1} = 'c/conference_room';  % 88 images 

MT_trainlist = {};
MT_testlist = {}; 
T = 10; % each scene has T test images, rest are training

for ic = 1:1:length(scene)
    foldersList = dir([path scene{ic,1} '/*.xml']);
    imagelist = {foldersList.name};
    
    % follow the convention of 'SmallTrainList.txt'
    count = 0;
    list = {};
    for i = imagelist
        count = count + 1;
        xmlname = cell2mat(i);
        list{count} = [scene{ic,1} '/' xmlname(1:end-4)]; 
    end
    list = list';
    
    if size(list,1) <= 10
        fprintf('Not enough training samples of current scene:%s\n',scene{ic,1});
        break;
    else
        trainlist = list(1:end-T,:);
        testlist = list(end-T+1:end,:);
        MT_trainlist = vertcat(MT_trainlist,trainlist);
        MT_testlist  = vertcat(MT_testlist,testlist);
    end
end

fid1 = fopen('MT_trainlist.txt','w');  
format = '%s\n';
for j = 1:1:size(MT_trainlist,1)
    fprintf(fid1,format,MT_trainlist{j,1});
end
fclose(fid1);

fid2 = fopen('MT_testlist.txt','w');  
format = '%s\n';
for j = 1:1:size(MT_testlist,1)
    fprintf(fid2,format,MT_testlist{j,1});
end
fclose(fid2);
