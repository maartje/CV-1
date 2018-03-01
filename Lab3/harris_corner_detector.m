function [H, r, c] = harris_corner_detector(im)
im_gray = im2double(rgb2gray(im)); % TODO: best method to deal with channels?

sigma = 1; % TODO: best value?
fsize = 2 * ceil(2 * sigma) + 1;
G1 = fspecial('gauss', fsize, sigma);
[Gx, Gy] = gradient(G1); 

Ix = imfilter(im_gray, Gx, 'replicate');
Iy = imfilter(im_gray, Gy, 'replicate');

G2 = G1; % TODO: best sigma value?
A = imfilter(Ix .^ 2, G2, 'replicate');
B = imfilter(Ix .* Iy, G2, 'replicate');
C = imfilter(Iy .^ 2, G2, 'replicate');

H = arrayfun(@R, A, B, C);

corner_treshold = mean2(H) + 2*std2(H); %TODO: we temp use this to see something
ksize = 9; % TODO
local_maximum_indicators = indicate_local_maxima(H, ksize);
above_treshold_indicators = H > corner_treshold;
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

function r = R(a, b, c)
k = 0.04; % TODO: configurable
Q = [a,b; b,c];
r = det(Q) - k * (trace(Q) ^ 2);
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