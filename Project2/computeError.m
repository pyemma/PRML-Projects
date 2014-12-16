function [ error, decision ] = computeError( dataset, label, weight, feature )
% Compute a given feature's performance on the dataset
%   apply the feature to the dataset and get the optimal decision boundary
%   and minimum error rate

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
    mi = min(output);
    ma = max(output);
    
    errors = zeros(2000, 1);
    cnt = 1;
    scale = 100;
    for boundary  = mi : (ma-mi)/scale : ma
%         for i = 1 : Data_Size
%             if output(i) < boundary
%                 judge(i) = -1;
%             else
%                 judge(i) = 1;
%             end
%         end
        pos = output >= boundary;
        neg = output < boundary;
        
        judge = pos + neg*-1;
        e = sum(weight(judge ~= label));
%         if e < min_error
%             min_error = e;
%             best_boundary = boundary;
%         end
        errors(cnt) = e;
        cnt = cnt + 1;
    end
    errors = errors(1:cnt-1);
    [error, ind] = min(errors);
    decision = (ind-1)*(ma-mi)/scale + mi;
    
end

