% Function to compute the integral image for an image, the input image
% musth be a single channle image

function [integral] = IntegralImage(img)
    
    [height, width] = size(img);
    img = double(img);
    integral = zeros(height+1, width+1);
    
    for i = 2 : height+1
        for j = 2 : width+1
            
            integral(i, j) = integral(i, j-1) + integral(i-1, j) - integral(i-1, j-1) + img(i-1, j-1);
        end
    end
    
end