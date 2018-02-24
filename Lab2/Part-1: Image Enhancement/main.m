im1 = imread('images/image1.jpg');
im1_salt_pepper = imread('images/image1_saltpepper.jpg');
im1_gaussian = imread('images/image1_gaussian.jpg');

PSNR_q1 = myPSNR(im1, im1_salt_pepper);
PSNR_q2 = myPSNR(im1, im1_gaussian);

fprintf('psnr %d "im1 - im1_salt_pepper" .\n', PSNR_q1);
fprintf('psnr %d "im1 - im1_gaussian" .\n\n', PSNR_q2);

show_denoised_images('images/image1_saltpepper.jpg', ["box", "median"], [3,5,7]);
show_denoised_images('images/image1_gaussian.jpg', ["box", "median"], [3,5,7]);

function show_denoised_images(im_path, ftypes, fsizes)
im = imread(im_path);
figure;
for ft_idx = 1:numel(ftypes)
    for fs_idx = 1:numel(fsizes)
        ft = ftypes(ft_idx);
        fs = fsizes(fs_idx);
        denoised = denoise(im, ft, fs);
        plot_idx = (ft_idx - 1)*numel(fsizes) + fs_idx;
        subplot(numel(ftypes),numel(fsizes), plot_idx);
        imshow(denoised);
        fprintf('psnr %s %d:  %d. \n', ft, fs, myPSNR(denoised, im));
    end
end
end

