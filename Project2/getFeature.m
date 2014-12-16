% The code used for generate Haar feature with different configuration, the
% window's size is 16*16, the feature contains several rows like
%              | x | y | height | width | +1/-1 |
% x, y, height and width together determine the 

% First kind of Haar feature with one negative part in the middle and
% two positive parts on both sides

% Haar_Features = zeros(16*16, 20000);
% cnt = 1;
% 
% for x = 2 : 15
%     for y = 2 : 8
%         for z = 2 : 8
%             neg = -1 * ones(x, z);
%             pos = 1 * ones(x, y);
%             pat = [pos, neg, pos];
%             
%             [height, width] = size(pat);
%             
%             for ii = 1 : 16 - height
%                 for jj = 1: 16 - width
%                     feature = zeros(16, 16);
%                     feature(ii:ii+height-1, jj:jj+width-1) = feature(ii:ii+height-1, jj:jj+width-1) + pat;
%                     feature = feature(:);
%                     Haar_Features(:, cnt) = feature;
%                     cnt = cnt + 1;
%                 end
%             end
%         end
%     end
% end
% 
% Haar_Features = Haar_Features(:, 1:cnt);

% First kind of Haar feature with one negative part in the middle and two
% positive parts on both sides

Window_Size = 16;
step = 1;

% Haar_Features1 = zeros(3*5, 40000);
Haar_Features1 = [];
cnt = 1;

for x = 2 : Window_Size
    for y = 2 : floor(Window_Size / 3)
    
        height = x;
        width = 3*y;

        for ii = 1 : step : Window_Size - height
            for jj = 1 : step : Window_Size - width

                pat = [ ii, jj,     ii+x-1, jj+y-1,    1;
                        ii, jj+y,   ii+x-1, jj+2*y-1, -1;
                        ii, jj+2*y, ii+x-1, jj+3*y-1,  1];
%                 pat = pat(:);
%                 Haar_Features1(:, cnt) = pat;
                Haar_Features1(cnt).feature = pat;
                cnt = cnt + 1;
            end
        end
    end
end
% Haar_Features1 = Haar_Features1(:, 1:cnt);

% Second kind of Haar feature with one positive part on the right and one
% negative part on the left

% Haar_Features2 = zeros(2*5, 40000);
Haar_Features2 = [];
cnt = 1;

for x = 2 : Window_Size
    for y = 2 : floor(Window_Size / 2)
    
        height = x;
        width = 2*y;

        for ii = 1 : step : Window_Size - height
            for jj = 1 : step : Window_Size - width

                pat = [ ii, jj,   ii+x-1, jj+y-1,    1;
                        ii, jj+y, ii+x-1, jj+2*y-1, -1];
%                 pat = pat(:);
%                 Haar_Features2(:, cnt) = pat;
                Haar_Features2(cnt).feature = pat;
                cnt = cnt + 1;

            end
        end
    end
end

% Haar_Features2 = Haar_Features2(:, 1:cnt);

% Third kind of Haar feature with one positive part on the top and one
% negative on the bottom

% Haar_Features3 = zeros(2*5, 40000);
Haar_Features3 = [];
cnt = 1;

for x = 2 : floor(Window_Size / 2)
    for y = 2 : Window_Size
        
        height = 2*x;
        width = y;
        
        for ii = 1 : step : Window_Size - height
            for jj = 1 : step : Window_Size - width
                
                pat = [ ii,   jj, ii+x-1,   jj+y-1,  1;
                        ii+x, jj, ii+2*x-1, jj+y-1, -1];
%                 pat = pat(:);
%                 Haar_Features3(:, cnt) = pat;
                Haar_Features3(cnt).feature = pat;
                cnt = cnt + 1;
            end
        end
    end
end

% Haar_Features3 = Haar_Features3(:, 1:cnt);

% Forth kind of Haar featur with two positive and two negative on the diag

% Haar_Features4 = zeros(4*5, 40000);
Haar_Features4 = [];
cnt = 1;
for x = 2 : floor(Window_Size / 2)
    for y = 2 : floor(Window_Size / 2)
        
        height = 2*x;
        width = 2*y;
        
        for ii = 1 : step : Window_Size - height
            for jj = 1 : step : Window_Size - width
                
                pat = [ ii,   jj,   ii+x-1,     jj+y-1,     1;
                        ii,   jj+y, ii+x-1,     jj+2*y-1,  -1;
                        ii+x, jj,   ii+2*x-1,   jj+y-1,    -1;
                        ii+x, jj+y, ii+2*x-1,   jj+2*y-1,   1];
%                 pat = pat(:);
%                 Haar_Features4(:, cnt) = pat;
                Haar_Features4(cnt).feature = pat;
                cnt = cnt + 1;
            end
        end
    end
end

% Haar_Features4 = Haar_Features4(:, 1:cnt);