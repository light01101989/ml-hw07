function BDT=boosttree(x,y,nt,maxdepth)
% function BDT=boosttree(x,y,nt,maxdepth)
%
% Learns a boosted decision tree on data x with labels y.
% It performs at most nt boosting iterations. Each decision tree has maximum depth "maxdepth".
%
% INPUT:
% x  | input vectors dxn
% y  | input labels 1xn
% nt | number of trees (default = 100)
% maxdepth | depth of each tree (default = 3)
%
% OUTPUT:
% BDT | Boosted DTree
%


%% fill in code here
if ~exist('nt','var')
    nt = 100;
end

if ~exist('maxdepth','var')
    maxdepth = 3;
end

[d,n]=size(x);
weights = ones(1,n)./n;

for i=1:nt
    T(:,:,i)=id3tree(x,y,maxdepth,weights);
    ypredict=evaltree(T(:,:,i),x);
    % weighted error
    epsi = sum((y~=ypredict).*weights,2);
    if epsi>0.5
        break;
    end
    alpha(i) = 0.5.*log((1-epsi)/epsi);
    % update weights
    weights = weights.*(exp(alpha(i).*(2.*(y~=ypredict)-1)));
    % normalization
    weights = weights./sum(weights,2);
end
% Boosted Tree
BDT.trees=T(:,:,1:length(alpha));
BDT.alpha = alpha;
