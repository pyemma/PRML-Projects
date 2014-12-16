% This script is an implemention of the Adaboost algorithm
clc, clear;
load newDataset;

label = [ones(size(face, 2), 1); -1*ones(size(nonface, 2), 1)];
weight = [ones(size(face, 2), 1) / (size(face, 2)*2); ones(size(nonface, 2), 1) / (size(nonface, 2)*2)];

% load BestFeatures;
% load Haar_Features_16_n;
% load Feature;
load newFeature;

projection = Haar'*dataset;

feature_num = 100;
data_size = size(dataset, 2);
ind = randperm(size(Haar, 2));
ind = ind(1:feature_num);
Feature = Haar(:, ind);
projection = projection(ind, :);

% Features = [Haar_Features1, Haar_Features2, Haar_Features3, Haar_Features4];
% Features = Features(randperm(size(Features, 2)));
% Features = Features(1:feature_num);

% for i = 1 : feature_num
%     i
%     feature = Features(i).feature;
%     for j = 1 : data_size
%         integral = dataset(j).integral;
%         temp = 0;
%         for k = 1 : size(feature, 1)
%             temp = temp + (integral(feature(k,3)+1, feature(k,4)+1) - integral(feature(k,1), feature(k,4)+1) - integral(feature(k,3)+1, feature(k,2)) + integral(feature(k,1), feature(k,2)))*feature(k,5);
%         end
%         projection(i, j) = temp;
%     end
% end

Classifier = [];

total_time = 100;

for i = 1 : total_time
    display(['The ', num2str(i), ' iteration']);
    tic
    
    errors = zeros(feature_num, 2);
    for j = 1 : feature_num
        
        [e, decision] = computeError(projection(j,:)', label, weight);
        errors(j, 1) = e;
        errors(j, 2) = decision;
      
    end
    
    
    mi = min(errors(:,1));
    inds = find(errors(:,1) == mi);
    inds = inds(randperm(size(inds, 1)));
    ind = inds(1);
    ind
    best_t = Feature(:, ind);
    best_thresh = errors(ind, 2);
    
    mi
    % Select the classifer with minimum error
    Classifier(i).feature = best_t;
    Classifier(i).threshold = best_thresh;
    
    % flag indicate which side of the decision boundary we choose as
    % positive sample and which side we choose as negative sample
    if mi > 0.5
        mi = 1 - mi;
        Classifier(i).flag = -1;
    else
        Classifier(i).flag = 1;
    end
    
    alpha = 1/2 * log((1 - mi) / mi);
    Classifier(i).alpha = alpha;
    
    % Update the weight for each data
    output = projection(ind,:)';
    
    pos = output >= best_thresh;
    neg = output < best_thresh;
    
    if Classifier(i).flag == -1
        pos = ones(size(pos, 1), 1) - pos;
        neg = ones(size(neg, 1), 1) - neg;
    end
    
    % The label that is classified correctly will be assigned negative
    % coefficent, otherwise positive coefficent
    judge = pos + neg*-1;
    e1 = (judge ~= label);
    e2 = (judge == label);
    e = e1 + e2*-1;
    coef = exp(alpha*e);
    weight = weight.*coef;
    norm = sum(weight);
    weight = weight / norm;
    
    classifyByStrong(dataset, label, Classifier);
    
%     if i == 150
%         save Feature_2000_Time_150
%     elseif i == 200
%         save Feature_2000_Time_200
%     end
    
    if i == 1
        save Feature_2000_Time_1_new;
    elseif i == 10
        save Feature_2000_Time_10_new;
    elseif i == 50
        save Feature_2000_Time_50_new;
    elseif i == 100
        save Feature_2000_Time_100_new;
    end
    toc
end
    