% Use Fisher Linear Discrimination to classify female and male face. First
% we mix apperance and gemotry information together to find a fisher face,
% use this fisher face to calculate the correct ratio. Then, we calculate
% fisher face for apperance and gemotry separately and project each test
% face to a 2D feature space to see how separable these points are.

clc, clear;
warning off;

% Read in image
Female = readInImages('female_face', 'bmp');
Male = readInImages('male_face', 'bmp');

Female = Female';
Male = Male';

Female_train = double(Female(:, 1:(size(Female, 2) - 10)));
Female_test = double(Female(:, size(Female, 2) - 9:end));

Male_train = double(Male(:, 1:(size(Male, 2) - 10)));
Male_test = double(Male(:, size(Male, 2) - 9:end));

me_face = mean([Female_train, Male_train], 2);

% Female_train = Female_train - repmat(me_face, 1, size(Female_train, 2));
% Male_train = Male_train - repmat(me_face, 1, size(Male_train, 2));
% 
% for i = 1 : size(Female_train, 2)
%     Female_train(:, i) = Female_train(:, i) / norm(Female_train(:, i));
% end
% 
% for i = 1 : size(Male_train, 2)
%     Male_train(:, i) = Male_train(:, i) / norm(Male_train(:, i));
% end

% Calculate the vector to project on
w = getFisher(Female_train, Male_train);

% Female_test = Female_test - repmat(me_face, 1, size(Female_test, 2));
% Male_test = Male_test - repmat(me_face, 1, size(Male_test, 2));
% Test on the test images to show the discriminability
Female_proj = Female_test'*w;
Male_proj = Male_test'*w;

scatter(Female_proj, zeros(10, 1), 'r');
hold on;
scatter(Male_proj, zeros(10, 1), 'b');

% Read in landmarks
[Female_X, Female_Y] = readInLandmarks('female_landmark_87', 'txt');
[Male_X, Male_Y] = readInLandmarks('male_landmark_87', 'txt');

Female_X = Female_X';
Male_X = Male_X';
Female_Y = Female_Y';
Male_Y = Male_Y';

Female_X_train = Female_X(:, 1:(size(Female_X, 2) - 10));
Female_X_test = Female_X(:, (size(Female_X, 2) - 9):end);
Male_X_train = Male_X(:, 1:(size(Male_X, 2) - 10));
Male_X_test = Male_X(:, (size(Male_X, 2) - 9):end);
Female_Y_train = Female_Y(:, 1:(size(Female_Y, 2) - 10));
Female_Y_test = Female_Y(:, (size(Female_Y, 2) - 9):end);
Male_Y_train = Male_Y(:, 1:(size(Male_Y, 2) - 10));
Male_Y_test = Male_Y(:, (size(Male_Y, 2) - 9):end);

Female_Landmark_train = [Female_X_train; Female_Y_train];
Female_Landmark_test = [Female_X_test; Female_Y_test];
Male_Landmark_train = [Male_X_train; Male_Y_train];
Male_Landmark_test = [Male_X_test; Male_Y_test];

me_Landmark = mean([Female_Landmark_train, Male_Landmark_train], 2);
me_x = me_Landmark(1:87);
me_y = me_Landmark(88:end);

% Female_Landmark_train = Female_Landmark_train - repmat(me_Landmark, 1, size(Female_Landmark_train, 2));
% Male_Landmark_train = Male_Landmark_train - repmat(me_Landmark, 1, size(Male_Landmark_train, 2));

wl = getFisher(Female_Landmark_train, Male_Landmark_train);

Female_Landmark_proj = Female_Landmark_test'*wl;
Male_Landmark_proj = Male_Landmark_test'*wl;

figure;
scatter(Female_Landmark_proj, zeros(10, 1), 'r');
hold on;
scatter(Male_Landmark_proj, zeros(10, 1), 'b');

% wx = getFisher(Female_X_train, Male_X_train);
% wy = getFisher(Female_Y_train, Male_Y_train);

% me_Landmark = mean([Female_Landmark_train, Male_Landmark_train], 2);
% me_x = me_Landmark(1:87);
% me_y = me_Landmark(88:end);

newFemale = [];
for i = 1:size(Female_train, 2)
    x = Female_X(:, i);
    y = Female_Y(:, i);
    img = warpImage_kent(reshape(Female_train(:,i), 256, 256), [x, y], [me_x, me_y]);
    newFemale = [newFemale, img(:)];
end

newMale = [];
for i = 1:size(Male_train, 2)
    x = Male_X(:, i);
    y = Male_Y(:, i);
    img = warpImage_kent(reshape(Male_train(:, i), 256, 256), [x, y], [me_x, me_y]);
    newMale = [newMale, img(:)];
end
me_newface = mean([newFemale, newMale], 2);
% newFemale = double(newFemale) - repmat(me_newface, 1, size(newFemale, 2));
% newMale = double(newMale) - repmat(me_newface, 1, size(newMale, 2));
w_new = getFisher(newFemale, newMale);

newFemale_test = [];
newMale_test = [];

for i = 1:size(Female_test, 2)
    x = Female_X_test(:, i);
    y = Female_Y_test(:, i);
    img = warpImage_kent(reshape(Female_test(:,i), 256, 256), [x, y], [me_x, me_y]);
    newFemale_test = [newFemale_test, img(:)];
end

for i = 1:size(Male_test, 2)
    x = Male_X_test(:, i);
    y = Male_Y_test(:, i);
    img = warpImage_kent(reshape(Male_test(:,i), 256, 256), [x, y], [me_x, me_y]);
    newMale_test = [newMale_test, img(:)];
end

% newFemale_test = double(newFemale_test) - repmat(me_newface, 1, size(newFemale_test, 2));
% newMale_test = double(newMale_test) - repmat(me_newface, 1, size(newMale_test, 2));

newFemale_test = double(newFemale_test);
newMale_test = double(newMale_test);
newFemale_proj = newFemale_test'*w_new;
newMale_proj = newMale_test'*w_new;

figure;
scatter(1:10, newFemale_proj, 'r');
hold on;
scatter(1:10, newMale_proj, 'b');

figure;
scatter(Female_Landmark_proj, newFemale_proj, 'r');
hold on;
scatter(Male_Landmark_proj, newMale_proj, 'b');