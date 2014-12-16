% Test on the class image with different size

img = imread('background_2014.JPG');
img = rgb2gray(img);


    window_size = 16;
    step = 4;
    imshow(img);
    falsealarm = [];
    cnt = 0;
    
    for si = 0.5 : 0.05 : 0.75
        nimg = imresize(img, si);
        feature_size = size(RealClassifier, 2);
        [m, n] = size(nimg);
        for i = 1 : step : m - window_size
            for j = 1 : step : n - window_size
                window = nimg(i:i+window_size-1, j:j+window_size-1);
                integral = IntegralImage(window);
                res = 0;
                for k = 1 : feature_size
                    feature = RealClassifier(k).feature;
                    temp = 0;
                    for p = 1 : size(feature, 1)
                        temp = temp + (integral(feature(p,3)+1, feature(p,4)+1) - integral(feature(p,1), feature(p,4)+1) - integral(feature(p,3)+1, feature(p,2)) + integral(feature(p,1), feature(p,2)))*feature(p,5);
                    end
                    id = size(find(spaces <= temp), 2);
                    res = res + RealClassifier(k).htb(id+1);
                end
                if res >= 0.5
                    ox = j / si;
                    oy = i / si;
                    osize = window_size / si;
                    rectangle('Position', [ox, oy, osize, osize], 'EdgeColor', 'r');
                    falsealarm(cnt).integral = integral;
                    cnt = cnt + 1;
                end
            end
        end
    end