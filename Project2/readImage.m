function [ integrals ] = readImage( path, format)
% Read in the images and do some basic preprocess on the images
%   Read in the images in the given path and convert them to gray image
    

    str = [path, '/*.', format];
    file = dir(str);
%     file = file(1:num);
    num = size(file, 1);
%     si = 16;
    integrals = zeros(256, num);
%     integrals = [];
    cnt = 1;
    num = size(file, 1);
    
    for i = 1 : num   
        str = [path, '/', file(i).name];
        img = imread(str);
        
        [~, ~, depth] = size(img);
        if depth == 3
            img = rgb2gray(img);
        end
        
%         integral = IntegralImage(img);
        integrals(:, cnt) = img(:);
%         integrals(cnt).integral = integral;
        cnt = cnt + 1;
    end

end

