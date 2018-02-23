function [ PSNR ] = myPSNR( orig_image, approx_image )

orig_im = im2double(orig_image);
approx_im = im2double(approx_image);
Imax = max(orig_im(:));
errs = (orig_im - approx_im) .^ 2;
MSE = sum(errs(:)) / numel(orig_im);
RMSE = sqrt(MSE);
PSNR = 20 * log10(Imax / RMSE);
end

