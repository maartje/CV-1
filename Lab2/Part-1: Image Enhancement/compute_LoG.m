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
        kguassian1 = fspecial('gaussian', 5, 0.5);
        im_g1 = imfilter(im, kguassian1, 'replicate');
        kguassian2 = fspecial('gaussian', 5, 0.5);
        im_g2 = imfilter(im, kguassian2, 'replicate');
        imOut = im_g1 - im_g2;
end
end

