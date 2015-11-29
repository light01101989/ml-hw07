function preds=evalforest(F,xTe)
% function preds=evalforest(F,xTe);
%
% Evaluates a random forest on a test set xTe.
%
% input:
% F   | Forest of decision trees
% xTe | matrix of m input vectors (matrix size dxm)
%
% output:
%
% preds | predictions of labels for xTe
%

%% fill in code here
[~,~,nTrees]=size(F);

for i=1:nTrees
    y(i,:)=evaltree(F(:,:,i),xTe);
end
preds = mode(y,1);

