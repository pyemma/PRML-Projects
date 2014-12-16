% This script is an implemention of the Adaboost algorithm
% 
% load Dataset;
% 
% if exist('dataset', 'var') == 0
%     face = readImage('newface16', 'bmp');
%     nonface = readImage('nonface16', 'bmp');
%     dataset = [face, nonface];
% end
% % 
% label = [ones(size(face, 2), 1); -1*ones(size(nonface, 2), 1)];
% weight = [ones(size(face, 2), 1) / (size(face, 2)*2); ones(size(nonface, 2), 1) / (size(nonface, 2)*2)];

% load Haar_Features_16_n;
feature_num = 500;

% Haar_Features1 = Haar_Features1(:, randperm(size(Haar_Features1, 2)));
% Haar_Features1 = Haar_Features1(:, 1 : feature_num);
% Haar_Features2 = Haar_Features2(:, randperm(size(Haar_Features2, 2)));
% Haar_Features2 = Haar_Features2(:, 1 : feature_num);
% Haar_Features3 = Haar_Features3(:, randperm(size(Haar_Features3, 2)));
% Haar_Features3 = Haar_Features3(:, 1 : feature_num);
% Haar_Features4 = Haar_Features4(:, randperm(size(Haar_Features4, 2)));
% Haar_Features4 = Haar_Features4(:, 1 : feature_num);

% Haar_Features1 = Haar_Features1(randperm(size(Haar_Features1, 2)));
% Haar_Features1 = Haar_Features1(1 : feature_num);
% Haar_Features2 = Haar_Features2(randperm(size(Haar_Features2, 2)));
% Haar_Features2 = Haar_Features2(1 : feature_num);
% Haar_Features3 = Haar_Features3(randperm(size(Haar_Features3, 2)));
% Haar_Features3 = Haar_Features3(1 : feature_num);
% Haar_Features4 = Haar_Features4(randperm(size(Haar_Features4, 2)));
% Haar_Features4 = Haar_Features4(1 : feature_num);

% Classifier = [];

total_time = 230;

for i = 221 : total_time
    display(['The ', num2str(i), ' iteration']);
    % Find the minimum error rate
    display('Computing the first kind of features');
    feature1_errors = zeros(feature_num, 2);
    for j = 1 : feature_num
%         feature = Haar_Features1(:, j);
        feature = Haar_Features1(j).feature;
        [e, decision] = computeError(dataset, label, weight, feature);
        feature1_errors(j, 1) = e;
        feature1_errors(j, 2) = decision;
%         display(['The error for the ', num2str(j), ' of 1st kind of feature']);
%         e        
    end
    display('Computing the second kind of features');
    feature2_errors = zeros(feature_num, 2);
    for j = 1 : feature_num
%         feature = Haar_Features2(:, j);
        feature = Haar_Features2(j).feature;
        [e, decision] = computeError(dataset, label ,weight, feature);
        feature2_errors(j, 1) = e;
        feature2_errors(j ,2) = decision;
%         display(['The error for the ', num2str(j), ' of 2nd kind of feature']);
%         e
    end
    display('Computing the third kind of features');
    feature3_errors = zeros(feature_num, 2);
    for j = 1 : feature_num
%        feature = Haar_Features3(:, j);
        feature = Haar_Features3(j).feature;
        [e, decision] = computeError(dataset, label, weight, feature);
        feature3_errors(j, 1) = e;
        feature3_errors(j, 2) = decision;
%         display(['The error for the ', num2str(j), ' of 3rd kind of feature']);
%         e
    end
    display('Computing the forth kind of features');
    feature4_errors = zeros(feature_num, 2);
    for j = 1 : feature_num
%        feature = Haar_Features4(:, j);
        feature = Haar_Features4(j).feature;
        [e, decision] = computeError(dataset, label, weight, feature);
        feature4_errors(j, 1) = e;
        feature4_errors(j, 2) = decision;
%         display(['The error for the ', num2str(j), ' of 4th kind of feature']);
%         e
    end
    
%     if i == 1 || i == 25 || i == 50 || i == 75 || i == 100
%         totale= [feature1_errors(:,1); feature2_errors(:,1); feature3_errors(:,1); feature4_errors(:,1)];
%         Y = sort(totale);
%         figure;
%         plot(Y(1:4*feature_num));
%     end
        
    
    [mi1, id1] = min(feature1_errors(:, 1));
    [mi2, id2] = min(feature2_errors(:, 1));
    [mi3, id3] = min(feature3_errors(:, 1));
    [mi4, id4] = min(feature4_errors(:, 1));
    
    mis = [mi1; mi2; mi3; mi4];
    mi = min(mis);
    best_t = [];
    best_thresh = 0;
    
    if mi == mi1
        best_t = Haar_Features1(id1).feature;
        best_thresh = feature1_errors(id1, 2);
    elseif mi == mi2
        best_t = Haar_Features2(id2).feature;
        best_thresh = feature2_errors(id2, 2);
    elseif mi == mi3
        best_t = Haar_Features3(id3).feature;
        best_thresh = feature3_errors(id3, 2);
    else
        best_t = Haar_Features4(id4).feature;
        best_thresh = feature4_errors(id4, 2);
    end
    
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
    [output] = classifyByFeature(dataset, best_t);
    
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
    
%     if i == 1
%         save Feature_2000_Time_1_new1;
%     elseif i == 10
%         save Feature_2000_Time_10_new1;
%     elseif i == 50
%         save Feature_2000_Time_50_new1;
%     elseif i == 100
%         save Feature_2000_Time_100_new1;
%     end
end
    