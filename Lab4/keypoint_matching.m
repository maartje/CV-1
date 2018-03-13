function [f1, f2, kpmatches] = keypoint_matching(image1, image2)

    % convert to single precision grey scale
    if size(image1,3) == 3
        im1 = im2single(rgb2gray(image1));
        im2 = im2single(rgb2gray(image2));
    else
        im1 = im2single(image1);
        im2 = im2single(image2);
    end

    % get keypoints and descriptors
    [f1, d1] = vl_sift(im1);
    [f2, d2] = vl_sift(im2);

    % get matches 
    [kpmatches, ~] = vl_ubcmatch(d1, d2) ;
end

