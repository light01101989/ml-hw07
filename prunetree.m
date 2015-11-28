function T=prunetree(T,xTe,y)
% function T=prunetree(T,xTe,y)
%
% Prunes a tree to minimal size such that performance on data xTe,y does not
% suffer.
%
% Input:
% T = tree
% xTe = validation data x (dxn matrix)
% y = labels (1xn matrix)
%
% Output:
% T = pruned tree
%

%% fill in code here

init_acc=analyze('acc',y,evaltree(T,xTe));
best_acc = init_acc;
T_hat = T;

[~,validnodesidx] = find((T(6,:)~=0));
validnodes = T(:,validnodesidx);
[~,leafnodesidx] = find(validnodes(4,:)==0);
leafnodes = validnodes(:,leafnodesidx);

while 1
    if (leafnodes(6,end)==leafnodes(6,end-1))
        % prune and try
        T_hat(:,T_hat(4,leafnodes(6,end))) = zeros(6,1);
        T_hat(:,T_hat(5,leafnodes(6,end))) = zeros(6,1);
        T_hat(4,leafnodes(6,end)) = 0;
        T_hat(5,leafnodes(6,end)) = 0;
    else
        % remove leaf without sibling
        leafnodes(:,end) = [];
        [~,remain] = size(leafnodes);
        if remain<2
            break;
        end
        continue;
    end

    prune_acc=analyze('acc',y,evaltree(T_hat,xTe));
    if prune_acc >= best_acc
        % do prune
        T_lastgood = T_hat;
        new_leafnode = leafnodes(6,end);
        leafnodes(:,end) = [];
        leafnodes(:,end) = [];
        leafnodes = [leafnodes,T_lastgood(:,new_leafnode)];
        [~,idx] = sort(leafnodes(6,:));
        leafnodes = leafnodes(:,idx);
        best_acc = prune_acc;
    else
        % revert prune
        T_hat = T_lastgood;
        leafnodes(:,end) = [];
        leafnodes(:,end) = [];
    end
    [~,remain] = size(leafnodes);
    if remain<2
        break;
    end
end

assert(best_acc>=init_acc,'Pruning Fucked up');
T = T_lastgood;
