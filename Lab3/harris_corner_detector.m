% detects corners in image
function [H, r, c] = harris_corner_detector(im, threshold_factor, sigma1, sigma2, local_max_window_size, show_figures)

    % settings
    k = 0.04;
    if nargin < 2
        threshold_factor = 0.25; % set default for threshold factor
    end
    if nargin < 3
        sigma1 = 2; 
    end
    if nargin < 4
        sigma2 = 2; 
    end
    if nargin < 5
        local_max_window_size = 9;
    end
    if nargin < 6
        show_figures = true; 
    end

    % convert to grey scale
    if ndims(im) == 3
        im_gray = im2double(rgb2gray(im));
    else
        im_gray = im2double(im);
    end 

    % calculate derivatives
    fsize1 = 2 * ceil(2 * sigma1) + 1;
    G1 = fspecial('gauss', fsize1, sigma1);
    [Gx, Gy] = gradient(G1); 
    Ix = imfilter(im_gray, Gx, 'replicate', 'conv');
    Iy = imfilter(im_gray, Gy, 'replicate', 'conv');

    % calculate elements of matric Q
    fsize2 = 2 * ceil(2 * sigma2) + 1;
    G2 = fspecial('gauss', fsize2, sigma2);
    A = imfilter(Ix .^ 2, G2, 'replicate');
    B = imfilter(Ix .* Iy, G2, 'replicate');
    C = imfilter(Iy .^ 2, G2, 'replicate');

    % calculate values for cornerness
    function r = R(a, b, c)
        Q = [a,b; b,c];
        r = det(Q) - k * (trace(Q) ^ 2);
    end
    H = arrayfun(@R, A, B, C);

    % select corners by picking local maxima above treshold 
    corner_treshold = mean2(H) + threshold_factor * std2(H); 
    above_treshold_indicators = H > corner_treshold;
    local_maximum_indicators = indicate_local_maxima(H, local_max_window_size); %TODO: improve performance by only looking at above treshold values
    corner_indicators = local_maximum_indicators .* above_treshold_indicators;
    [r, c] = find(corner_indicators);

    % show derivatives Ix, Iy, and show image with marked corners
    if show_figures
        fprintf('%d \n ', corner_treshold);

        figure;
        subplot(2,2,1);
        imshow(mat2gray(Ix));

        subplot(2,2,2);
        imshow(mat2gray(Iy));

        subplot(2,2,3);
        imshow(im);
        hold on;
        plot(c, r, 'r*', 'LineWidth', 1, 'MarkerSize', 5);
        hold off;

        subplot(2,2,4);
        imshow(im_gray);
        hold on;
        plot(c, r, 'r*', 'LineWidth', 1, 'MarkerSize', 5);
        hold off;
    end
end


% returns matrix with zeros and ones denoting local maxima
function indicators = indicate_local_maxima(M, ksize)
    if mod(ksize, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end

    % add zero padding
    padding = (ksize - 1)/2;
    Mpadded = padarray(M, [padding, padding]);

    % detect local maxima with sliding window
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