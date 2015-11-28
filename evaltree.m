function [ypredict]=evaltree(T,xTe)
% function [ypredict]=evaltree(T,xTe);
%
% input:
% T0  | tree structure
% xTe | Test data (dxn matrix)
%
% output:
%
% ypredict : predictions of labels for xTe
%

%% fill in code here
[d,n] = size(xTe);
[~,temp] = size(T);

for i=1:n
    j=1;
    % check if not leaf
    while (T(4,j)~=0 && T(5,j)~=0)
        if (xTe(T(2,j),i)<=T(3,j))
            % left
            j = T(4,j);
        else
            % right
            j = T(5,j);
        end
        if (j>temp)
            error('CHECK CHECK');
        end
    end
    ypredict(i) = T(1,j);
end
