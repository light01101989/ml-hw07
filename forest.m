function F=forest(x,y,nt)
% function F=forest(x,y,nt)
%
% INPUT:
% x | input vectors dxn
% y | input labels 1xn
%
% OUTPUT:
% F | Forest
%

%% fill in code here
[~,n]=size(x);
tt=6;
F=[];
for i=1:nt
    F_new=[];
    idx=randsample(n,n,true);
    D_x = x(:,idx);
    D_y = y(:,idx);
    T=id3tree(D_x,D_y);
    [~,nodeT] = size(T);
    [~,nodeF,~] = size(F);
    if nodeF<nodeT
        % append F
        for k=1:i-1
            F_new(:,:,k) = [F(:,:,k),zeros(tt,nodeT-nodeF)];
        end
        F = F_new;
    elseif nodeF>nodeT
        % append T
        T = [T,zeros(tt,nodeF-nodeT)];
    end
    F(:,:,i) = T;
end

