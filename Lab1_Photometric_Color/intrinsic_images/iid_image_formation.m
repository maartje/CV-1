function [im_reconstructed] = iid_image_formation(im_reflectance, im_shading)
im_reconstructed = im2double(im_reflectance) .* im2double(im_shading);
end


