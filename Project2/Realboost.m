% This script is an implemention of the Realboost algorithm? the result is
% continue with the Adaboost's result in T = 10, 50 and 100

% if exist('dataset', 'var') == 0
%     face = readImage('newface16', 'bmp');
%     nonface = readImage('nonface16', 'bmp');
%     dataset = [face, nonface];
% end
% load Feature_2000_Time_100;
weight = [ones(size(face, 2), 1) / (size(face, 2)*2); ones(size(nonface, 2), 1) / (size(nonface, 2)*2)];
epslion = 1e-5;

feature_num = size(Classifier, 2);
Featrue = [];
for i = 1 : feature_num
    Feature(i).feature = Classifier(i).feature;
end

% feature_num = size(Feature, 2);
% feature_num = 1;
RealClassifier = [];

scale = 200;
T = feature_num;
for i = 1 : T
    Z = zeros(feature_num, 1);
    Htb = zeros(scale+2, feature_num);
%     Spaces = zeros(scale+1, feature_num);

    pos_weight = weight(label == 1);
    neg_weight = weight(label == -1);
    
    b_min = -3000;
    b_max = 3000;
        
    spaces = linspace(b_min, b_max, scale+1);
    for j = 1 : feature_num
        output = classifyByFeature(dataset, Feature(j).feature);
        pos_res = output(label == 1);
        neg_res = output(label == -1);
        
%         pos_min = min(pos_res);
%         neg_min = min(neg_res);
%         pos_max = max(pos_res);
%         neg_max = max(neg_res);
        
%         b_min = max(pos_min, neg_min);
%         b_max = min(pos_max, neg_max);
%         b_min = -3000;
%         b_max = 3000;
%         
%         spaces = linspace(b_min, b_max, scale+1);
        htb = zeros(scale+2, 1);
        qt = zeros(scale+2, 1);
        pt = zeros(scale+2, 1);
        
        sump = 0;
        sumq = 0;
        
        for k = 1 : size(spaces, 2)
            if k == 1
                pt(k) = sum(pos_weight(find(pos_res <= spaces(k))));
                qt(k) = sum(neg_weight(find(neg_res <= spaces(k))));
            else
                pt(k) = sum(pos_weight(find(pos_res > spaces(k-1) & pos_res <= spaces(k))));
                qt(k) = sum(neg_weight(find(neg_res > spaces(k-1) & neg_res <= spaces(k))));
            end
        end
        pt(end) = sum(pos_weight(find(pos_res > spaces(end))));
        qt(end) = sum(neg_weight(find(neg_res > spaces(end))));
        
        htb = log((pt + epslion) ./ (qt + epslion)) / 2;
        Htb(:, j) = htb;
%         Spaces(:, j) = spaces;
        z = 2 * sum(sqrt(pt.*qt));
        Z(j) = z;
    end
    
    [z_min, ind] = min(Z);
    ind
    RealClassifier(i).feature = Feature(ind).feature;
    RealClassifier(i).htb = Htb(:, ind);
%     RealClassifier(i).spaces = Spaces(:, ind);
    
    htb = Htb(:, ind);
%     spaces = Spaces(:, ind);
    
    output = classifyByFeature(dataset, Feature(ind).feature);
    pos_res = output(label == 1);
    neg_res = output(label == -1);
    pos_weight = weight(label == 1);
    neg_weight = weight(label == -1);
    
    for k = 1 : size(htb, 1)
        if k == 1
            pos_weight(find(pos_res <= spaces(k))) = pos_weight(find(pos_res <= spaces(k)))*exp(-htb(k));
            neg_weight(find(neg_res <= spaces(k))) = neg_weight(find(neg_res <= spaces(k)))*exp(htb(k));
        elseif k == size(htb, 1)
            pos_weight(find(pos_res > spaces(k-1))) = pos_weight(find(pos_res > spaces(k-1)))*exp(-htb(k));
            neg_weight(find(neg_res > spaces(k-1))) = neg_weight(find(neg_res > spaces(k-1)))*exp(htb(k));
        else
            pos_weight(find(pos_res > spaces(k-1) & pos_res <= spaces(k))) = pos_weight(find(pos_res > spaces(k-1) & pos_res <= spaces(k)))*exp(-htb(k));
            neg_weight(find(neg_res > spaces(k-1) & neg_res <= spaces(k))) = neg_weight(find(neg_res > spaces(k-1) & neg_res <= spaces(k)))*exp(htb(k));
        end
    end
    
    weight = [pos_weight; neg_weight];
    norm = sum(weight);
    weight = weight / norm;
end
            
        