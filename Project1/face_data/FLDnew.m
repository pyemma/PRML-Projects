% Fisher Linear Discrimination with no warpping
Female = readInImages('female_face', 'bmp');
Male = readInImages('male_face', 'bmp');

Female = Female';
Male = Male';

Female_train = double(Female(:, 1:(size(Female, 2) - 10)));
Female_test = double(Female(:, size(Female, 2) - 9:end));

Male_train = double(Male(:, 1:(size(Male, 2) - 10)));
Male_test = double(Male(:, size(Male, 2) - 9:end));

me = mean([Female_train, Male_train], 2);
load NoWarpPCA.mat;

Female_alpha = Comp'*(Female_train - repmat(me, 1, size(Female_train, 2)));
Male_alpha = Comp'*(Male_train - repmat(me, 1, size(Male_train, 2)));

me1 = mean(Female_alpha, 2);
me2 = mean(Male_alpha, 2);

S = 0;
for i = 1 : size(Female_alpha, 2)
    S = S + (Female_alpha(:, i) - me1)*(Female_alpha(:, i) - me1)';
end
for i = 1 : size(Male_alpha, 2)
    S = S + (Male_alpha(:, i) - me2)*(Male_alpha(:, i) - me2)';
end

w = inv(S)*(me1 - me2);

figure;
scatter(Female_alpha'*w, zeros(1, size(Female_alpha, 2)), 'b');
hold on;
scatter(Male_alpha'*w, zeros(1, size(Male_alpha, 2)), 'r', '*');
title('Classification of face on training set');
legend('Female', 'Male');

Female_test_alpha = Comp'*(Female_test - repmat(me, 1, size(Female_test, 2)));
Male_test_alpha = Comp'*(Male_test - repmat(me, 1, size(Male_test, 2)));

figure;
scatter(Female_test_alpha'*w, zeros(1, size(Female_test_alpha, 2)), 'b');
hold on;
scatter(Male_test_alpha'*w, zeros(1, size(Male_test_alpha, 2)), 'r', '*');
title('Classification of face on testing set');
legend('Female', 'Male');

% Fisher Linear Discrimination with warpping
[Female_X, Female_Y] = readInLandmarks('female_landmark_87', 'txt');
[Male_X, Male_Y] = readInLandmarks('male_landmark_87', 'txt');

Female_X = Female_X';
Female_Y = Female_Y';
Male_X = Male_X';
Male_Y = Male_Y';

Female_Landmark = [Female_X; Female_Y];
Male_Landmark = [Male_X; Male_Y];

Female_Landmark_train = Female_Landmark(:, 1:(size(Female_Landmark, 2) - 10));
Female_Landmark_test = Female_Landmark(:, (size(Female_Landmark, 2)-9):end);

Male_Landmark_train = Male_Landmark(:, 1:(size(Male_Landmark, 2) - 10));
Male_Landmark_test = Male_Landmark(:, (size(Male_Landmark, 2)-9):end);

me_landmark = mean([Female_Landmark_train, Male_Landmark_train], 2);
me_x = me_landmark(1:87);
me_y = me_landmark(88:end);

load LandmarkPCA.mat;
Female_Landmark_alpha = Comp_land'*(Female_Landmark_train - repmat(me_landmark, 1, size(Female_Landmark_train, 2)));
Male_Landmark_alpha = Comp_land'*(Male_Landmark_train - repmat(me_landmark, 1, size(Male_Landmark_train, 2)));

mel1 = mean(Female_Landmark_alpha, 2);
mel2 = mean(Male_Landmark_alpha, 2);

Sl = 0;
for i = 1:size(Female_Landmark_alpha, 2)
    Sl = Sl + (Female_Landmark_alpha(:, i) - mel1)*(Female_Landmark_alpha(:, i) - mel1)';
end
for i = 1:size(Male_Landmark_alpha, 2)
    Sl = Sl + (Male_Landmark_alpha(:, i) - mel2)*(Male_Landmark_alpha(:, i) - mel2)';
end

wl = inv(Sl)*(mel1 - mel2);

figure;
scatter(Female_Landmark_alpha'*wl, zeros(1, size(Female_Landmark_alpha, 2)), 'b');
hold on;
scatter(Male_Landmark_alpha'*wl, zeros(1, size(Male_Landmark_alpha, 2)), 'r', '*');
title('Classification on Landmarks of training set');

Female_warp = zeros(size(Female));
Male_warp = zeros(size(Male));

for i = 1:size(Female_warp, 2);
    img = Female(:, i);
    x = Female_X(:, i);
    y = Female_Y(:, i);
    warp = warpImage_kent(img, [x, y], [me_x, me_y]);
    warp = double(warp(:));
    Female_warp(:, i) = warp;
end

for i = 1:size(Male_warp, 2);
    img = Male(:, i);
    x = Male_X(:, i);
    y = Male_Y(:, i);
    warp = warpImage_kent(img, [x, y], [me_x, me_y]);
    warp = double(warp(:));
    Male_warp(:, i) = warp;
end

Female_warp_train = double(Female_warp(:, 1:(size(Female_warp, 2) - 10)));
Female_warp_test = double(Female_warp(:, size(Female_warp, 2) - 9:end));

Male_warp_train = double(Male_warp(:, 1:(size(Male_warp, 2) - 10)));
Male_warp_test = double(Male_warp(:, size(Male_warp, 2) - 9:end));

me_warp = mean([Female_warp_train, Male_warp_train], 2);

load WarpPCA.mat;
Female_warp_alpha = new_Comp'*(Female_warp_train - repmat(me_warp, 1, size(Female_warp_train, 2)));
Male_warp_alpha = new_Comp'*(Male_warp_train - repmat(me_warp, 1, size(Male_warp_train, 2)));

me_warp1 = mean(Female_warp_alpha, 2);
me_warp2 = mean(Male_warp_alpha, 2);

Sw = 0;
for i = 1:size(Female_warp_alpha, 2)
    Sw = Sw + (Female_warp_alpha(:, i) - me_warp1)*(Female_warp_alpha(:, i) - me_warp1)';
end
for i = 1:size(Male_warp_alpha, 2)
    Sw = Sw + (Male_warp_alpha(:, i) - me_warp2)*(Male_warp_alpha(:, i) - me_warp2)';
end

ww = inv(Sw)*(me_warp1 - me_warp2);

figure;
scatter(Female_warp_alpha'*ww, zeros(1, size(Female_warp_alpha, 2)), 'b');
hold on;
scatter(Male_warp_alpha'*ww, zeros(1, size(Male_warp_alpha, 2)), 'r', '*');
title('Classification of face on training set after warpping');
legend('Female', 'Male');

figure;
scatter(Female_Landmark_alpha'*wl, Female_warp_alpha'*ww, 'b');
hold on;
scatter(Male_Landmark_alpha'*wl, Male_warp_alpha'*ww, 'r', '*');
title('Classification of face on training set using two features');
legend('Female', 'Male');

Female_Landmark_test_alpha = Comp_land'*(Female_Landmark_test - repmat(me_landmark, 1, size(Female_Landmark_test, 2)));
Male_Landmark_test_alpha = Comp_land'*(Male_Landmark_test - repmat(me_landmark, 1, size(Male_Landmark_test, 2)));

Female_warp_test_alpha = new_Comp'*(Female_warp_test - repmat(me_warp, 1, size(Female_warp_test, 2)));
Male_warp_test_alpha = new_Comp'*(Male_warp_test - repmat(me_warp, 1, size(Male_warp_test, 2)));

figure;
scatter(Female_Landmark_test_alpha'*wl, Female_warp_test_alpha'*ww, 'b');
hold on;
scatter(Male_Landmark_test_alpha'*wl, Male_warp_test_alpha'*ww, 'r', '*');
title('Classification of face on testing set using two features');
legend('Female', 'Male');


