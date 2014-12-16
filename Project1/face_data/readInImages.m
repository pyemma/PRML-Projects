function [ X ] = readInImages( path, format )
%Read all images of the given path in a folder and return them as a matrix,
%each image would be vectorized as a row of the matrix.
%   path:   folder name
%   format: image format
%
%   X:      image matrix, each row would be a data

str = [path, '/*.', format];

% read in all files in the folder
file = dir(str);
X = [];

% read in all images
for i = 1 : size(file, 1)
    x = imread([path, '/', file(i).name]);
    x = x(:);
    X = [X, x];
end

X = X';
end

