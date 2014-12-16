function [ Comp, Coef, me ] = myPca( X, num )
%Given the input of data, return the specific largest components calculated
%specified by the num
%   Input:
%       X: input data, each row is a data
%       num: the number of principle components want
%   Output:
%       Coef: principle components computed
%       Score: corresponding energy of each principle components

X = double(X);
% the mean of the training images
me = mean(X);

% subtract the mean from each training images
newX = X - repmat(me, size(X, 1), 1);

% compute the pca of the input, using the fast method, otherwise the memory
% is not enough
cov = newX*newX' / size(X, 1);
% [U, S, D] = svd(cov);
% 
% Comp = U(:, 1:num);
% Comp = newX'*Comp;

[V, D] = eig(cov);
[Y, I] = sort(-diag(D));

Coef = -Y(1:num, :);
Ind = I(1:num, :);

Comp = V(:, Ind);

Comp = newX'*Comp;
% Coef = diag(D);
% normalize the component so that they have unit norm
for i = 1 : num
    Comp(:, i) = Comp(:, i) / norm(Comp(:, i));
end

% Coef = S(1:num, 1:num);
% Coef = diag(Coef);
end

