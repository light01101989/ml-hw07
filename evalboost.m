function preds=evalboost(BDT,xTe)
% function preds=evalboost(BDT,xTe);
%
% Evaluates a boosted decision tree on a test set xTe.
%
% input:
% BDT | Boosted Decision Trees
% xTe | matrix of m input vectors (matrix size dxm)
%
% output:
%
% preds | predictions of labels for xTe
%

%% fill in code here
[~,~,nTrees]=size(BDT.trees);

for i=1:nTrees
    y(i,:)=evaltree(BDT.trees(:,:,i),xTe);
end
[~,c] = size(y);
[C,ia,ic] = unique(y);

% reshape alpha
alp = BDT.alpha.';
alp = repmat(alp,1,c);

for i=1:length(C)
    wgt(i,:) = sum((C(i)==y).*alp,1);
end

[~,idx] = max(wgt,[],1);
preds = C(idx)';
