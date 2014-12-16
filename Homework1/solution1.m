%Plot the risk function of each action

resolution = 1000;
[X1, X2] = meshgrid(linspace(0, 18, resolution)', linspace(0, 18, resolution)');
X = [X1(:) X2(:)];

%The mu of each class's likehood function
mu1 = [4, 12];
mu2 = [12, 3];
mu3 = [3, 5];

%The sigma of each class's likehood function, in this case they are all the
%same
Sigma = [9, 0; 0, 9];

%The likehood function of each class
P1 = mvnpdf(X, mu1, Sigma);
P2 = mvnpdf(X, mu2, Sigma);
P3 = mvnpdf(X, mu3, Sigma);
P = [P1 P2 P3];

%Action cost
lamda = [0 3 2; 2 0 1; 3 1 0];

%Prior distribution
Pr1 = 0.2;
Pr2 = 0.2;
Pr3 = 0.6;
Pr = [Pr1, Pr2, Pr3];

%Calculate the risk, eash column of G stores the corresponding risk for i = 1
%2 3
G = (lamda.*repmat(Pr, 3, 1))*P';
G = -G';

% figure;
% title('g1(x) risk function');
% surf(X1, X2, reshape(G(:,1), 100, 100));
% 
% figure; 
% title('g2(x) risk function');
% surf(X1, X2, reshape(G(:, 2), 100, 100));
% 
% figure;
% title('g3(x) risk function');
% surf(X1, X2, reshape(G(:, 3), 100, 100));

g1 = G(:, 1);
g2 = G(:, 2);
g3 = G(:, 3);

%Draw each intersection of the risk function
diff1 = 0.8*P1 - 1.2*P2 - 0.2*P3;
diff2 = 1.2*P1 - 0.8*P2 - 0.4*P3;
diff3 = 0.4*P1 + 0.4*P2 - 0.2*P3;
diff = reshape(g1 - g2, resolution, resolution);
C = contours(X1, X2, diff, [0, 0]);
xL = C(1, 2:end);
yL = C(2, 2:end);
figure, title('g1(x) = g2(x)');
plot(xL, yL);

diff = reshape(g1 - g3, resolution, resolution);
C = contours(X1, X2, diff, [0, 0]);
xL = C(1, 2:end);
yL = C(2, 2:end);
%figure, title('g1(x) = g3(x)');
hold on;
plot(xL, yL, 'r');

diff = reshape(g2 - g3, resolution, resolution);
C = contours(X1, X2, diff, [0, 0]);
xL = C(1, 2:end);
yL = C(2, 2:end);
%figure, title('g2(x) = g3(x)');
hold on;
plot(xL, yL, 'g');
