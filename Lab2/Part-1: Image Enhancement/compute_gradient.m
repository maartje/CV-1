function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)
im = im2double(image);
GxM = [
    1, 0, -1;
    2, 0, -2;
    1, 0, -1
];

GyM = [
    1, 2, 1;
    0, 0, 0;
    -1, -2, -1
];

Gx = imfilter(im, GxM);
Gy = imfilter(im, GyM);

im_magnitude = sqrt(Gx .^2 + Gy .^2);
im_direction = atan(Gy ./ Gx);

end

