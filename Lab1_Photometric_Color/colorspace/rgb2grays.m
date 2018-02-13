function [output_image] = rgb2grays(input_image)
% converts an RGB into grayscale by using 4 different methods
R = input_image(:, :, 1);
G = input_image(:, :, 2);
B = input_image(:, :, 3);


% ligtness method
output_image = (max(input_image, [], 3) + min(input_image, [], 3)) ./ 2;   

% average method
output_image(:, :, 2) = (R + G + B) ./ 3;

% luminosity method
output_image(:, :, 3) = 0.21 * R + 0.72 * G + 0.07 * B;

% built-in MATLAB function
output_image(:, :, 4) = rgb2gray(input_image);

end

