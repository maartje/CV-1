function [output_image] = AWB(input_image)
R = input_image(:, :, 1);
G = input_image(:, :, 2);
B = input_image(:, :, 3);

output_image = (128.0/mean2(R)) * R;
output_image(:, :, 2) = (128.0/mean2(G)) * G;
output_image(:, :, 3) = (128.0/mean2(B)) * B;

end
