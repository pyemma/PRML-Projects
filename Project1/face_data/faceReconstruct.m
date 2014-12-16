% Part one
% In this part, we first only use apperance to find the principle component
% and then use these to code the test images, then we find the principle
% compnonent of landmarks and then try to code the gemotry feature. Then
% we combine these two part, first use gemotry information to align the
% face, then use the apperance codebook to code the face, then we wrap back
% to the reconstructed landmarks to compare it with original face. We would
% compare the reconstruction error of these steps. At last we use gauss
% distribution to generate random coefficient and get a random face.

clc, clear;
warning off all;

% Load the images and landmarks
Imgs = readInImages('face' ,'bmp');
[X, Y] = readInLandmarks('landmark_87', 'dat');

% Split the data
Train_Imgs = Imgs(1:150, :);
Test_Imgs = Imgs(151:end, :);

Train_X = X(1:150, :);
Test_X = X(151:end, :);

Train_Y = Y(1:150, :);
Test_Y = Y(151:end, :);

% Stack the X coordinate and Y coordinate together to train the gemotry
% information
Train_landmarks = [Train_X, Train_Y];
Test_landmarks = [Test_X, Test_Y];
% Get the principle of images
[Comp, Coef, me] = myPca(Train_Imgs, 20);

% Code the test face and calculate the reconstruction error
Error = [];
rec_example = [];
for i = 1:20
    error = 0;
    Sub_Comp = Comp(:, 1:i);
    
    for j = 1:size(Test_Imgs, 1)
        img = Test_Imgs(j, :);
        img = double(img);
        img = img - me;
        alpha = Sub_Comp'*img';
        rec = Sub_Comp*alpha + me';
        if j == 1
            rec_example = [rec_example, rec];
        end
        % calculate the reconstruct error
        org = double(Test_Imgs(j, :)');
        error = error + sum((rec - org).^2) / size(org, 1);
    end
    error = error / size(Test_Imgs, 1);
    Error = [Error, error];
end

figure, plot(1:20, Error);
title('Reconstruction error of face with no landmarks');
xlabel('Number of eign-face used');
ylabel('Reconstruct error per pixel');
        
% Code the landmarks and calculate the reconstruction error        
[Comp_land, Coef_land, me_land] = myPca(Train_landmarks, 10);
me_X = me_land(1:87);
me_Y = me_land(88:end);

Error_land = [];
recx_example = [];
recy_example = [];
for i = 1:5
    error = 0;
%     Sub_CompX = Comp_X(:, 1:i);
%     Sub_CompY = Comp_Y(:, 1:i);
    Sub_CompLand = Comp_land(:, 1:i);
    for j = 1:size(Test_Imgs, 1)
        x = Test_X(j, :);
        y = Test_Y(j, :);
        land = [x, y];
        
        land = land - me_land;
        
        beta = Sub_CompLand'*land';
        recland = Sub_CompLand*beta + me_land';
        recx = recland(1:87);
        recy = recland(88:end);
        recx_example = [recx_example, recx];
        recy_example = [recy_example, recy];
        
        error = error + sum((recland - [x, y]').^2) / size(recland, 1);
    end
    error = error / size(Test_Imgs, 1);
    Error_land = [Error_land, error];
end

figure, plot(1:5, Error_land);
title('Reconstruction error of landmark');
xlabel('Number of eign-warpping used');
ylabel('Reconstruction error per point');
        
% Combine the first two part
%   1. Warp all images to the mean landmarks and compute the new PC at
%   these new training data
%   2. Given a test image, warp it according to the mean landmarks, then
%   project it to the new PC
%   3. Reconstruct the image and landmarks using k-eign value, then compute
%   the reconstruction error

% Warp all training images
new_Train_Imgs = [];
for i = 1:size(Train_Imgs, 1)
    img = reshape(Train_Imgs(i, :)', 256, 256);
    img = uint8(img);
    
    x = Train_X(i, :)';
    y = Train_Y(i, :)';
    
    warp = warpImage_kent(img, [x, y], [me_X', me_Y']);
    new_Train_Imgs = [new_Train_Imgs; warp(:)'];
end

[new_Comp, new_Coef, new_me] = myPca(new_Train_Imgs, 10);

Error_warp = [];
warp_example = [];
for i = 1:10
    error = 0;
    sub_Comp = new_Comp(:, 1:i);
    sub_CompLand = Comp_land;
        
    for j = 1 : size(Test_Imgs, 1)
        img = reshape(Test_Imgs(j, :)', 256, 256);
        img = uint8(img);

        x = Test_X(j, :);
        y = Test_Y(j, :);
        land = [x, y];
        
        % warp the image to the mean landmark position and then reconstruct
        % the image at this position
        warp = warpImage_kent(img, [x', y'], [me_X', me_Y']);
        
        % reconstruct the image
        warp = double(warp(:)');
        warp = warp - new_me;
        alpha = sub_Comp'*warp';
        rec = sub_Comp*alpha + new_me';
        rec = reshape(rec', 256, 256);
        
        % warp the reconstructed image back to the reconstructed landmarks
        land = land - me_land;
        
        % reconstruct the landmarks
        beta = sub_CompLand'*land';
        recland = sub_CompLand*beta + me_land';
        recx = recland(1:87);
        recy = recland(88:end);

        rec_warp = warpImage_kent(rec, [me_X', me_Y'], [recx, recy]);

        rec_warp = (double(rec_warp(:)));
        img = double(img(:));
        if i == 10
            warp_example = [warp_example, rec_warp];
        end
        error = error + sum((img - rec_warp).^2) / size(img, 1);
    end
    error = error / size(Test_Imgs, 1);
    Error_warp = [Error_warp, error];
end

figure, plot(1:10, Error_warp);
title('Reconstruction error of face with landmark');
xlabel('Number of eign-face used');
ylabel('Reconstruction error per pixel');


% Random sample coefficents for apperance and gemotry information, that is
% get a random apperance and landmarks to genearte a rand face.rand
rnd_face = [];
for i = 1:20
    rand_alpha = normrnd(0, 1, 10, 1);
    rand_beta = normrnd(0, 1, 10, 1);
    
    rand_alpha = rand_alpha.*sqrt(new_Coef);
    rand_beta = rand_beta.*sqrt(Coef_land);
    
    land = Comp_land*rand_beta + me_land';
    x = land(1:87);
    y = land(88:end);

    rec = new_Comp*rand_alpha + new_me';
    
    rec = warpImage_kent(reshape(rec, 256, 256), [me_X', me_Y'], [x, y]);
    rnd_face = [rnd_face, rec(:)];
    
    figure, imshow(rec);
    title(['random-face   ', num2str(i)]);
end







        