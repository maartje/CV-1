function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb
R = input_image(:, :, 1);
G = input_image(:, :, 2);
B = input_image(:, :, 3);

output_image = R ./(R + G + B);
output_image(:, :, 2) = G ./(R + G + B);
output_image(:, :, 3) = B ./(R + G + B);

end

