
function im_concatenated = concatenate_images(im1, im2)

    % concatenate the images    
    h1 = size(im1, 1);
    h2 = size(im2, 1);
    h = max(h1, h2);
    im1_padded = zeros(h, size(im1, 2), 'uint8');
    im2_padded = zeros(h, size(im2, 2), 'uint8');    
    im1_padded(1:size(im1, 1),1:size(im1, 2)) = im1;
    im2_padded(1:size(im2, 1),1:size(im2, 2)) = im2;        
    im_concatenated = cat(2, im1_padded, im2_padded);
end