function [] = PRcure2( Positive, Negitive, range, k )
% Helper function to help draw the PR curve for a two-dimensional decision
% boundary with the form of y = kx + b
%   Positive: Positive samples
%   Neigitve: Neigitve samples
%   range: the range of k to determine the decision boundary
%   b: the fixed b
    
    TP = zeros(size(range, 2), 1);
    FP = zeros(size(range, 2), 1);
    FN = zeros(size(range, 2), 1);
    
    for i = 1 : size(range, 2)
        b = range(i);
        tp = size(find(Positive(:, 1)*k + b - Positive(:, 2) <= 0), 1);
        fp = size(find(Negitive(:, 1)*k + b - Negitive(:, 2) <= 0), 1);
        fn = size(Positive, 1) - tp;
        TP(i) = tp;
        FP(i) = fp;
        FN(i) = fn;
    end
    
    Precision = TP ./ (TP + FP);
    Recall = TP ./ (TP + FN);
    
    [range', Precision, Recall]
    
    plot(Recall, Precision);
end

