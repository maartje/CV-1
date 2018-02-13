function [im_recolored] = recoloring(im_reflectance, im_shading, r, g, b)
[R, G, B] = true_uniform_color(im_reflectance);
im_reflectance_recolored = im_reflectance(:,:,:);
im_reflectance_recolored(im_reflectance_recolored == R) = r;
im_reflectance_recolored(im_reflectance_recolored == G) = g;
im_reflectance_recolored(im_reflectance_recolored == B) = b;

im_recolored = iid_image_formation(im_reflectance_recolored, im_shading);
end

function [R, G, B] = true_uniform_color(im)
R = max(max(im(:,:,1)));
G = max(max(im(:,:,2)));
B = max(max(im(:,:,3)));
end
