function Aff = MaxSpan( M ) 
% CS536 Final Project
% Kruskal Algorithm for maximum spanning tree
% -------------------------------------------------------------------------
% Input: Matrix of mutual info over all nodes
% Output: Adjacency matrix of MST
%--------------------------------------------------------------------------

Aff = zeros(size(M));
M_half = triu(M,0);
V_half = reshape(M_half,[],1);
[V_sort, V_idx] = sort(V_half,'descend');

% Initialize the disjoint sets
diag_ele = ones(size(M,1),1);
sets = diag(diag_ele);

for i = 1:1:size(V_idx)
    idx = V_idx(i,1);
    [ix,iy] = ind2sub(size(M),idx); % ix, iy are the index in M
    
    % check if start and end points of current edge have already being
    % counted
    ind_x = find(sets(:,ix) ~= 0); %ind_x is the index of 1 in 'ix'th row of sets
    ind_y = find(sets(:,iy) ~= 0); %ind_y is the index of 1 in 'iy'th row of sets
    if size(sets,1) == 1
        disp('All nodes traversed!');break;
    elseif ind_x == ind_y
        continue;
    else
        set_combine = sets(ind_x,:) | sets(ind_y,:);
        sets = removerows(sets,'ind',[ind_x,ind_y]);
        sets(size(sets,1)+1,:) = set_combine;
        Aff(ix,iy) = 1;
        Aff(iy,ix) = 1;
    end
end
