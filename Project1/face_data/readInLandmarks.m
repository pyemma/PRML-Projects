function [ X, Y ] = readInLandmarks( path, format )
%Read in all landmarks in a folder
%   path: folder path
%   format: landmarks format, 'txt' or 'dat'
%
%   X: all landmarks pair, X is x coordinate, Y is y coordinate

str = [path, '/*.', format];

file = dir(str);

X = [];
Y = [];

for i = 1:size(file, 1)
    [x, y] = textread([path, '/', file(i).name], '%f%f');
    
    if size(x, 1) > 87
        x = x(end-86:end);
        y = y(end-86:end);
    end
    
    X = [X, x];
    Y = [Y, y];
end

X = X';
Y = Y';

