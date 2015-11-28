%
function visdata(X,Y)
symbols = {'o','x'};
classvals = [1 2];
%classvals = [-1 1];

hold on;
for c = 1:2
    idx = find(Y==classvals(c));
    hp=plot(X(1,idx), X(2,idx), symbols{c}, 'Color','black','LineWidth',2,'markersize',4);
    view(2);    
end

