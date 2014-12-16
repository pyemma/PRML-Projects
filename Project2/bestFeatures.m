% Find the best feature candidates 

if exist('dataset', 'var') == 0
    face = readImage('newface16', 'bmp');
    nonface = readImage('nonface16', 'bmp');
    dataset = [face, nonface];
end

label = [ones(size(face, 2), 1); -1*ones(size(nonface, 2), 1)];
weight = [ones(size(face, 2), 1) / (size(face, 2)*2); ones(size(nonface, 2), 1) / (size(nonface, 2)*2)];

load Haar_Features_16_n;

feature1_errors = zeros(size(Haar_Features1, 2), 1);

    for j = 1 : size(Haar_Features1, 2)
        feature = Haar_Features1(j).feature;
        [e, decision] = computeError(dataset, label, weight, feature);
        feature1_errors(j) = e;       
    end

feature2_errors = zeros(size(Haar_Features2, 2), 1);

    for j = 1 : size(Haar_Features2, 2)
        feature = Haar_Features2(j).feature;
        [e, decision] = computeError(dataset, label, weight, feature);
        feature2_errors(j) = e;       
    end
    
feature3_errors = zeros(size(Haar_Features3, 2), 1);

    for j = 1 : size(Haar_Features3, 2)
        feature = Haar_Features3(j).feature;
        [e, decision] = computeError(dataset, label, weight, feature);
        feature3_errors(j) = e;       
    end
    
feature4_errors = zeros(size(Haar_Features4, 2), 1);

    for j = 1 : size(Haar_Features4, 2)
        feature = Haar_Features4(j).feature;
        [e, decision] = computeError(dataset, label, weight, feature);
        feature4_errors(j) = e;       
    end

