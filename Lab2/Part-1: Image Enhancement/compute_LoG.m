function imOut = compute_LoG(image, LOG_type)
im = im2double(image);
switch LOG_type
    case 1
        %method 1
        kguassian = fspecial('gaussian', 5, 0.5);
        im_g = imfilter(im, kguassian, 'replicate');
        klaplacian = fspecial('laplacian', 0.2);
        imOut = imfilter(im_g, klaplacian, 'replicate');
    case 2
        %method 2
        klog = fspecial('log', 5, 0.5);
        imOut = imfilter(im, klog, 'replicate');
    case 3
        %method 3
%         sigma = 0.5;
        sigma = 0.5;
        sigma1 = sigma / sqrt(2);
        sigma2 = sqrt(2) * sigma;
        fsize = 2 * ceil(2 * sigma2) + 1;
        
        kguassian1 = fspecial('gaussian', fsize, sigma1);
        im_g1 = imfilter(im, kguassian1, 'replicate');
        kguassian2 = fspecial('gaussian', fsize, sigma2);
        im_g2 = imfilter(im, kguassian2, 'replicate');
        imOut = im_g1 - im_g2;
        
        %http://www.cse.psu.edu/~rtc12/CSE486/lecture11_6pp.pdf
end
end

