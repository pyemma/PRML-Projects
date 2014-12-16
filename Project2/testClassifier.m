function [ ] = testClassifier( img, Classifier )
% Test the Adaboost classifier on the class image
    
    window_size = 16;
    step = 4;
    imshow(img);
    [m, n, depth] = size(img);
    if depth ~= 1
        img = rgb2gray(img);
    end
    
    % integral = IntegralImage(img);
    
    feature_size = size(Classifier, 2);
    for i = 1 : step : m - window_size
        for j = 1 : step : n - window_size
            window = img(i:i+window_size-1, j:j+window_size-1);
            integral = IntegralImage(window);
            res = 0;
            for k = 1 : feature_size
                feature = Classifier(k).feature;
                threshold = Classifier(k).threshold;
                alpha = Classifier(k).alpha;
                temp = 0;
                for p = 1 : size(feature, 1)
                    temp = temp + (integral(feature(p,3)+1, feature(p,4)+1) - integral(feature(p,1), feature(p,4)+1) - integral(feature(p,3)+1, feature(p,2)) + integral(feature(p,1), feature(p,2)))*feature(p,5);
                end
                if temp >= threshold
                    res = res + alpha;
                else
                    res = res - alpha;
                end
            end
            if res >= 0.7450
                rectangle('Position', [j, i, window_size, window_size], 'EdgeColor', 'r');
            end
        end
    end

end

