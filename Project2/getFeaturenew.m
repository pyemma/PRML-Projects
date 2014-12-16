Window_Size = 16;
step = 1;

% Haar_Features1 = zeros(3*5, 40000);
Haar1 = [];
cnt = 1;

for x = 2 : Window_Size
    for y = 2 : floor(Window_Size / 3)
    
        height = x;
        width = 3*y;
        mask = zeros(16, 16);
        for ii = 1 : step : Window_Size - height
            for jj = 1 : step : Window_Size - width
                mask = zeros(16, 16);
%                 pat = [ ii, jj,     ii+x-1, jj+y-1,    1;
%                         ii, jj+y,   ii+x-1, jj+2*y-1, -1;
%                         ii, jj+2*y, ii+x-1, jj+3*y-1,  1];
                mask(ii:ii+x-1, jj:jj+y-1) = 1;
                mask(ii:ii+x-1, jj+y:jj+2*y-1) = -1;
                mask(ii:ii+x-1, jj+2*y:jj+3*y-1) = 1;
                Haar1 = [Haar1, mask(:)];
            end
        end
    end
end

% Second kind of Haar feature with one positive part on the right and one
% negative part on the left

Haar2 = [];
cnt = 1;

for x = 2 : Window_Size
    for y = 2 : floor(Window_Size / 2)
    
        height = x;
        width = 2*y;
        mask = zeros(16, 16);
        for ii = 1 : step : Window_Size - height
            for jj = 1 : step : Window_Size - width
                mask = zeros(16, 16);
%                 pat = [ ii, jj,   ii+x-1, jj+y-1,    1;
%                         ii, jj+y, ii+x-1, jj+2*y-1, -1];
                mask(ii:ii+x-1, jj:jj+y-1) = 1;
                mask(ii:ii+x-1, jj+y:jj+2*y-1) = -1;
                Haar2 = [Haar2, mask(:)];

            end
        end
    end
end


% Third kind of Haar feature with one positive part on the top and one
% negative on the bottom

Haar3 = [];
cnt = 1;

for x = 2 : floor(Window_Size / 2)
    for y = 2 : Window_Size
        
        height = 2*x;
        width = y;
        mask = zeros(16, 16);
        for ii = 1 : step : Window_Size - height
            for jj = 1 : step : Window_Size - width
                mask = zeros(16, 16);
%                 pat = [ ii,   jj, ii+x-1,   jj+y-1,  1;
%                         ii+x, jj, ii+2*x-1, jj+y-1, -1];
                mask(ii:ii+x-1, jj:jj+y-1) = 1;
                mask(ii+x:ii+2*x-1, jj:jj+y-1) = -1;
                Haar3 = [Haar3, mask(:)];
            end
        end
    end
end


% Forth kind of Haar featur with two positive and two negative on the diag

Haar4 = [];
cnt = 1;
for x = 2 : floor(Window_Size / 2)
    for y = 2 : floor(Window_Size / 2)
        
        height = 2*x;
        width = 2*y;
        mask = zeros(16, 16);
        for ii = 1 : step : Window_Size - height
            for jj = 1 : step : Window_Size - width
                mask = zeros(16, 16);
%                 pat = [ ii,   jj,   ii+x-1,     jj+y-1,     1;
%                         ii,   jj+y, ii+x-1,     jj+2*y-1,  -1;
%                         ii+x, jj,   ii+2*x-1,   jj+y-1,    -1;
%                         ii+x, jj+y, ii+2*x-1,   jj+2*y-1,   1];
                mask(ii:ii+x-1,jj:jj+y-1) = 1;
                mask(ii:ii+x-1, jj+y:jj+2*y-1) = -1;
                mask(ii+x:ii+2*x-1, jj:jj+y-1) = -1;
                mask(ii+x:ii+2*x-1, jj+y:jj+2*y-1) = 1;
                Haar4 = [Haar4, mask(:)];
            end
        end
    end
end