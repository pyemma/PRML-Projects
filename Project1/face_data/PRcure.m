function [] = PRcure( Positive, Negitive, range)
% A helper function to draw the PR curve for determine the desicion
% boundary, which is on one dimensional
% Here to ease the discussion, we assume that the point greater than
% the decision boundary would be 
%   Positive: Positive samples
%   Negitive: Negitive samples
%   range: A user defined range to try the decision boundary
    
    TP = zeros(size(range, 2), 1);
    FP = zeros(size(range, 2), 1);
    FN = zeros(size(range, 2), 1);
    
    for i = 1 : size(range, 2)
        tp = size(find(Positive > range(i)), 1);
        fp = size(find(Negitive > range(i)), 1);
        fn = size(Positive, 1) - tp;
        TP(i) = tp;
        FP(i) = fp;
        FN(i) = fn;
    end
    
    Percision = TP ./ (TP + FP);
    Recall = TP ./ (TP + FN);
    [Percision, Recall]
    
    plot(Recall, Percision);

end

