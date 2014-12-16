function [ output ] = classifyByFeature( dataset, feature )
% Apply the feature to a set of training set
%   Given a set of training data containing both positive samples and
%   negative samples, compute the value of the feature on each image
    
    Data_Size = size(dataset, 2);
%     Data_Width = uint8(sqrt(size(data, 1)));
    
%     feature = reshape(feature, size(feature, 1)/5, 5);    
    Num_point = size(feature, 1);
    
%     points = zeros(Num_point, 4);
%     for i = 1 : Num_point
%         points(i, 1) = feature(i, 1);
%         points(i, 2) = feature(i, 2);
%         points(i, 3) = feature(i, 1) + feature(i, 3) - 1;
%         points(i, 4) = feature(i, 2) + feature(i, 4) - 1;
%     end
    % points
    res = zeros(Data_Size, 1);
    % compute the images' value under the given pattern
    for i = 1 : Data_Size
        temp = 0;
%        integral = dataset(:,i);
%         integral = reshape(integral, Data_Width, Data_Width);
        integral = dataset(i).integral;
        for j = 1 : Num_point
            temp = temp + (integral(feature(j,3)+1, feature(j,4)+1) - integral(feature(j,1), feature(j,4)+1) - integral(feature(j,3)+1, feature(j,2)) + integral(feature(j,1), feature(j,2)))*feature(j,5);
            % (integral(points(j,3)+1, points(j,4)+1) - integral(points(j,1), points(j,4)+1) - integral(points(j,3)+1, points(j,2)) + integral(points(j,1), points(j,2)))*feature(j, 5)
        end
        res(i) = temp;
    end    
    output = res;
end

