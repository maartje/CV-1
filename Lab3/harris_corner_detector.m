% TODO: what about scale invariance?

function [H, r, c] = harris_corner_detector(im)

% convert to grey scale
im_gray = im2double(rgb2gray(im)); 

% TODO: optimal settings
sigma1 = 1; 
sigma2 = 1;
k = 0.04;
corner_treshold = -1; % TODO: experiment with different values
local_max_window_size = 9;

fsize1 = 2 * ceil(2 * sigma1) + 1;
G1 = fspecial('gauss', fsize1, sigma1);
[Gx, Gy] = gradient(G1); 

Ix = imfilter(im_gray, Gx, 'replicate');
Iy = imfilter(im_gray, Gy, 'replicate');

fsize2 = 2 * ceil(2 * sigma2) + 1;
G2 = fspecial('gauss', fsize2, sigma2);
A = imfilter(Ix .^ 2, G2, 'replicate');
B = imfilter(Ix .* Iy, G2, 'replicate');
C = imfilter(Iy .^ 2, G2, 'replicate');

function r = R(a, b, c)
Q = [a,b; b,c];
r = det(Q) - k * (trace(Q) ^ 2);
end

H = arrayfun(@R, A, B, C);

corner_treshold = mean2(H) + 2*std2(H); %TODO: we temp use this to see something
above_treshold_indicators = H > corner_treshold;
local_maximum_indicators = indicate_local_maxima(H, local_max_window_size); %TODO: fix performance by only looking at above treshold values
corner_indicators = local_maximum_indicators .* above_treshold_indicators;
[r, c] = find(corner_indicators);

figure;
subplot(1,2,1);
imshow(mat2gray(Ix));

subplot(1,2,2);
imshow(mat2gray(Iy));

% figure;
% imshow(mat2gray(H));
% hold on;
% plot(c, r, 'r*', 'LineWidth', 1, 'MarkerSize', 5);

figure;
subplot(1,2,1);
imshow(im);
hold on;
plot(c, r, 'r*', 'LineWidth', 1, 'MarkerSize', 5);

subplot(1,2,2);
imshow(im_gray);
hold on;
plot(c, r, 'r*', 'LineWidth', 1, 'MarkerSize', 5);

end


function indicators = indicate_local_maxima(M, ksize)
if mod(ksize, 2) == 0
    error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
end

padding = (ksize - 1)/2;
Mpadded = padarray(M, [padding, padding]);

[rows, columns] = size(M);
indicators = zeros(rows, columns);
for r = 1:rows
    for c = 1: columns
        cell_value = M(r,c);
        kwindow = Mpadded(r:r+2*padding, c: c + 2 * padding);
        max_value = max(kwindow(:));
        indicators(r,c) = (cell_value == max_value);
        % remark: two peaks in the same window are both 
        % marked as a peak value
        % should we do some suppression here?        
    end
end
end