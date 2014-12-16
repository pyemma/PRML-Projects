%Two norm distribution
X = -10 : 0.01 : 20;

mu1 = 6; nmu1 = 4;
mu2 = 2;

Sigma1 = 4;
Sigma2 = 5;

P1 = normpdf(X, nmu1, Sigma1)*0.56; % This is the pdf for negitive
P2 = normpdf(X, mu2, Sigma2)*0.44; % This is the pdf for positive

PP1 = P1 ./ (P1 + P2);
PP2 = P2 ./ (P1 + P2);

plot(X, PP1, 'b');
hold on;
plot(X, PP2, 'r');

% Calculte ROC:
%   Hit rate: the positive that has been classified as positive
%   False alarm: the negitive that has been classified as positive

T = -10 : 0.01 : 20;
Hit_rate = cdf('norm', T, mu2, Sigma2);
False_alarm = cdf('norm', T, mu1, Sigma1);
figure, plot(False_alarm, Hit_rate);

False_alarmn = cdf('norm', T, nmu1, Sigma1);
hold on;
plot(False_alarmn, Hit_rate, 'r');

% Calculate PR:
%   True positive: the decision that classify true to true
%   False positive: the decision that classify false to true
%   False negitive: the decision that classify true to false
%
%   Precision: TP / (FP + TP)
%   Recall: TP / (TP + FN)

T = -10 : 0.01 : 20;

% TP = normcdf(T, mu2, Sigma2)*0.44;
% FP = normcdf(T, mu1, Sigma1)*0.56;
% FN = (1 - normcdf(T, mu2, Sigma2))*0.44;

TP = (1 - normcdf(T, mu1, Sigma1))*0.56;
FP = (1 - normcdf(T, mu2, Sigma2))*0.44;
FN = normcdf(T, mu1, Sigma1)*0.56;

Precision = TP ./ (TP + FP);
Recall = TP ./ (TP + FN);
figure, plot(Recall, Precision);

nFP = normcdf(T, nmu1, Sigma1)*0.56;
nPrecision = TP ./ (TP + nFP);
hold on;
plot(Recall, nPrecision, 'r');