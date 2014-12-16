function [ res ] = classifyByRealstrong( dataset, label, realClassifier )
% Use the strong classifier calculated by Realboost to classify the dataset

    feature_num = size(realClassifier, 2);
    data_num = size(dataset, 2);
    b_min = -3000;
    b_max = 3000;
    scale = 200;    
    spaces = linspace(b_min, b_max, scale+1);
    
    res = zeros(data_num, 1);
    for i = 1 : feature_num
        feature = realClassifier(i).feature;
        output = classifyByFeature(dataset, feature);
        for j = 1 : data_num
            id = size(find(spaces <= output(j)), 2);
            res(j) = res(j) + realClassifier(i).htb(id+1);
        end
        
    end
    pos = res >= 0;
    neg = res < 0;
    judge = pos + neg*-1;
    
    
    
    size(find(judge == label), 1) / data_num
end

