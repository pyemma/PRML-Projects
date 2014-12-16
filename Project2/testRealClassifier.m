function [ ] = testRealClassifier( img, Classifier )
% Test the Realboost classifier on the class image
    window_size = 16;
    step = 4;
    imshow(img);
    [m, n, depth] = size(img);
    if depth ~= 1
        img = rgb2gray(img);
    end
    
    % integral = IntegralImage(img);
    scale = 200;
    spaces = linspace(-3000, 3000, scale);
    
    feature_size = size(Classifier, 2);
        for i = 1 : step : m - window_size
            for j = 1 : step : n - window_size
                window = img(i:i+window_size-1, j:j+window_size-1);
                integral = IntegralImage(window);
                res = 0;
                for k = 1 : feature_size
                    feature = Classifier(k).feature;
                    temp = 0;
                    for p = 1 : size(feature, 1)
                        temp = temp + (integral(feature(p,3)+1, feature(p,4)+1) - integral(feature(p,1), feature(p,4)+1) - integral(feature(p,3)+1, feature(p,2)) + integral(feature(p,1), feature(p,2)))*feature(p,5);
                    end
                    id = size(find(spaces <= temp), 2);
                    res = res + Classifier(k).htb(id+1);
                end

                if res >= 0.5
                    rectangle('Position', [j, i, window_size, window_size], 'EdgeColor', 'r');
                end
            end
        end

end


