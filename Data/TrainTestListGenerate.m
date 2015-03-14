% Generate the Train and Test list for MT model

% the path to data annotation folder, change it
path = 'Data\Annotations\'; 

% choose the scene you like, change subfolder path here.
% % scene{1,1} = 'b/beach';  % 97 images
% % scene{2,1} = 's/street';  % 291 images
% % scene{3,1} = 'c/conference_room';  % 88 images 
scene{1,1} = 'b/bedroom';
scene{2,1} = 'h/highway';
scene{3,1} = 's/street';
scene{4,1} = 'l/living_room';
scene{5,1} = 'b/beach';
scene{6,1} = 'c/coast';
scene{7,1} = 'v/valley';
scene{8,1} = 'm/mountain';
scene{9,1} = 'h/home_office';
scene{10,1} = 'c/conference_room';
scene{11,1} = 's/skyscraper';
scene{12,1} = 'r/river';
scene{13,1} = 'c/creek';
scene{14,1} = 's/staircase';
scene{15,1} = 's/shoe_shop';
scene{16,1} = 'c/childs_room';
scene{17,1} = 'a/art_gallery';
scene{18,1} = 'c/clothing_store';
scene{19,1} = 'a/airport_terminal';
scene{20,1} = 'b/building_facade';

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

fid1 = fopen('MT_trainlist_20.txt','w');  
format = '%s\n';
for j = 1:1:size(MT_trainlist,1)
    fprintf(fid1,format,MT_trainlist{j,1});
end
fclose(fid1);

fid2 = fopen('MT_testlist_20.txt','w');  
format = '%s\n';
for j = 1:1:size(MT_testlist,1)
    fprintf(fid2,format,MT_testlist{j,1});
end
fclose(fid2);
