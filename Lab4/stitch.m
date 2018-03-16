function im_stitched = stitch(im1, im2)

    % transform image2 so that it aligns with image1
    [f1, f2, kpmatches] = keypoint_matching(im2, im1);
    [M, T] = ransac(f1, f2, kpmatches, 10, 4);    
    [im2_to_im1, translate_x, translate_y] = transform_image(im2, M, T);
    
    % calculate coordinate frame 
    min_y = min(0, translate_y);
    min_x = min(0, translate_x);
    max_y = max(size(im1,1), size(im2_to_im1, 1) + translate_y);
    max_x = max(size(im1,2), size(im2_to_im1, 2) + translate_x);
    
    % fill image values, 
    % translating coordinate frame so that
    % min value for x and y are both 1
    im_stitched = zeros(max_y - min_y, max_x - min_x, 3, 'uint8');
    im_stitched(-min_y + translate_y + 1 : -min_y + size(im2_to_im1, 1) + translate_y, -min_x + translate_x + 1 : -min_x + size(im2_to_im1, 2) + translate_x, :) = im2_to_im1;
    im_stitched(-min_y + 1 : -min_y + size(im1,1), -min_x + 1 : -min_x + size(im1,2), :) = im1;
end