function T=id3tree(xTr,yTr,maxdepth,weights)
% function T=id3tree(xTr,yTr,maxdepth,weights)
%
% The maximum tree depth is defined by "maxdepth" (maxdepth=2 means one split).
% Each example can be weighted with "weights".
%
% Builds an id3 tree
%
% Input:
% xTr | dxn input matrix with n column-vectors of dimensionality d
% yTr | 1xn input matrix
% maxdepth = maximum tree depth
% weights = 1xn vector where weights(i) is the weight of example i
%
% Output:
% T = decision tree
%

%% fill in code here
[d,n] = size(xTr);

if ~exist('maxdepth','var')
    %maxdepth = ceil(log2(n))+1;
    maxdepth = Inf;
else
nnodes = 2^maxdepth - 1;
T = zeros(6,nnodes);
end

if ~exist('weights','var')
    weights=ones(1,n)./n;
end

% Initialise
pointer = [0 n];
data = xTr;
label = yTr;
wgts = weights;

%for i=1:maxdepth
i=1;
while i<=maxdepth
    pos = zeros(1,2^(i)+1);
    n_xTr = [];
    n_yTr = [];
    n_weights = [];
    start_node = 2^(i-1);
    cnt=0;
    for j=1:2^(i-1)
        cur_node = start_node+(j-1);
        parent = floor(cur_node/2);
        if parent && T(4,parent) == 0 % parent is leaf
            cnt = cnt+1;
            continue;
        end

        a = pointer(j)+1; b = pointer(j+1);
        cdata = data(:,a:b);
        clabel = label(:,a:b);
        cwgts = wgts(:,a:b);

        % when maxdepth is reached:make every node as leaf
        if i == maxdepth
            T(1,cur_node) = mode(clabel); %split
            T(6,cur_node) = parent;
            cnt = cnt+1;
            continue;
        end

        if range(clabel) == 0
            feature = 0; cut = 0; Hbest = Inf; % data is pure
        else
            [feature,cut,Hbest] = entropysplit(cdata,clabel,cwgts); % split with data for this node
        end
        T(1,cur_node) = mode(clabel); %split
        T(2,cur_node) = feature;
        T(3,cur_node) = cut;
        T(6,cur_node) = parent;
        if Hbest == Inf
            % no attribute left to split/ or data is pure
            % Create leaf node
            T(4,cur_node) = 0;
            T(5,cur_node) = 0;
            cnt = cnt+1;
            continue; % no more data split required
        else
            T(4,cur_node) = 2*cur_node;
            T(5,cur_node) = 2*cur_node+1;
        end

        % Split data for next iteration with the cut value
        l_idx = find(cdata(feature,:)<=cut);
        r_idx = find(cdata(feature,:)>cut);
        l_xTr = cdata(:,l_idx);
        r_xTr = cdata(:,r_idx);
        l_yTr = clabel(:,l_idx);
        r_yTr = clabel(:,r_idx);
        l_weights = cwgts(:,l_idx);
        r_weights = cwgts(:,r_idx);
        [~,pos(2*j)] = size(l_xTr);
        [~,pos(2*j+1)] = size(r_xTr);
        n_xTr = [n_xTr,l_xTr,r_xTr];
        n_yTr = [n_yTr,l_yTr,r_yTr];
        n_weights = [n_weights,l_weights,r_weights];
    end
    if (cnt == 2^(i-1))
        break;
    end
    % Update
    pointer = cumsum(pos);
    data = n_xTr;
    label = n_yTr;
    wgts = n_weights;
    i=i+1;
end
