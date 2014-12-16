function [res] = classifyByStrong( dataset, label, Classifier )
% Use the strong classifier to test the performance of Adaboost

    data_size = size(dataset, 2);
    res = zeros(data_size, 1);
    feature_size = size(Classifier, 2);
    
    for i = 1 : feature_size
        feature = Classifier(i).feature;
        threshold = Classifier(i).threshold;
        flag = Classifier(i).flag;
        alpha = Classifier(i).alpha;
        
        [output] = classifyByFeature(dataset, feature);
%         output = feature'*dataset;
%         output = output';
        
        pos = output >= threshold;
        neg = output < threshold;
        
        if flag == -1
            pos = ones(size(pos, 1), 1) - pos;
            neg = ones(size(neg, 1), 1) - neg;
        end
        
        judge = pos + neg*-1;
        res = res + judge*alpha;
    end
    
    face_res = res(find(label == 1));
    nonface_res = res(find(label == -1));
    
    figure, subplot(1, 2, 1);
    hist(face_res, 50);
    subplot(1, 2, 2);
    hist(nonface_res, 50);
    N1 = histc(face_res, min(face_res):0.5:max(face_res));
    N2 = histc(nonface_res, min(nonface_res):0.5:max(nonface_res));
    
    figure;
    plot(min(face_res):0.5:max(face_res), N1, 'r');
    hold on;
    plot(min(nonface_res):0.5:max(nonface_res), N2, 'g');
    
    pos = face_res >= 0;
    neg = nonface_res >= 0;
%     judge = pos + neg*-1;
    
    correct = size(find(pos), 1);
    rate = correct / size(face_res, 1)
    false_alarm = size(find(neg), 1) / size(find(res >= 0), 1)
    
    error = [];
    
    for dec = 0: 0.001 : 1
        pos = res >= dec;
        neg = res < dec;
        judge = pos + neg*-1;
        error = [error, size(find(judge == label), 1) / size(dataset, 2)];
        % size(find(judge == label), 1) / size(dataset, 2)
    end
    max(error)
    find(error == max(error))
end

