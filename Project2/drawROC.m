function [ ] = drawROC( input, label, color )
% Help function to draw the ROC curve

    mi = min(input);
    ma = max(input);
    
    positive = input(find(label == 1));
    negative = input(find(label == -1));
    
    Tp = [];
    Fp = [];
    
    scale = 1000;
    for decision = mi : (ma - mi)/scale: ma
        tp = size(find(positive >= decision), 1);
        fp = size(find(negative >= decision), 1);
        Tp = [Tp; tp/size(positive, 1)];
        Fp = [Fp; fp/size(negative, 1)];
    end
    plot(Fp, Tp, color);

end

