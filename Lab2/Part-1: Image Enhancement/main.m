clear
clc
close all

%question6();
question7();
%question8();
%question9();

function question9()
image2 = imread('images/image2.jpg');
im2_gl = compute_LoG(image2, 1);
im2_log = compute_LoG(image2, 2);
im2_dog = compute_LoG(image2, 3);


figure('Name','Question 9');
subplot(1,3,1);
imshow(mat2gray(im2_gl)), title('Laplace after Gaussian');
subplot(1,3,2);
imshow(mat2gray(im2_log)), title('LoG filter');
subplot(1,3,3);
imshow(mat2gray(im2_dog)), title('Dog filter');
end

function question8()
image2 = imread('images/image2.jpg');
[Gx, Gy, Gmag, Gdir] = compute_gradient(image2);

figure('Name','Question 8');
subplot(2,2,1);
imshow(Gx, []), title('Directional gradient: X axis');
subplot(2,2,2);
imshow(Gy, []), title('Directional gradient: Y axis');
subplot(2,2,3);
imshow(Gmag, []), title('Gradient magnitude');
subplot(2,2,4);
imshow(Gdir, []), title('Gradient direction');
end

function question7()
show_denoised_images('images/image1_saltpepper.jpg', ["box", "median"], [3,5,7]);
show_denoised_images('images/image1_gaussian.jpg', ["box", "median"], [3,5,7]);

show_denoised_images('images/image1_saltpepper.jpg', ["gaussian"], [0.5,1,2]);
show_denoised_images('images/image1_gaussian.jpg', ["gaussian"], [0.5,1,2]);

end


function question6()
im1 = imread('images/image1.jpg');
im1_salt_pepper = imread('images/image1_saltpepper.jpg');
im1_gaussian = imread('images/image1_gaussian.jpg');

PSNR_q1 = myPSNR(im1, im1_salt_pepper);
PSNR_q2 = myPSNR(im1, im1_gaussian);

fprintf('psnr %d "im1 - im1_salt_pepper" .\n', PSNR_q1);
fprintf('psnr %d "im1 - im1_gaussian" .\n\n', PSNR_q2);

end

function show_denoised_images(im_path, ftypes, fsizes)
fprintf('\n%s: \n', im_path);

im_orig = imread('images/image1.jpg');
im_noise = imread(im_path);
figure('Name',sprintf('Q7 - %s', im_path));
for ft_idx = 1:numel(ftypes)
    for fs_idx = 1:numel(fsizes)
        ft = ftypes(ft_idx);
        fs = fsizes(fs_idx);
        if ft == "gaussian"
            fsize = 2 * ceil(2 * fs) + 1; % kernel size: at least 2 times sigma to both sizes + 1 to make it odd.
            if mod(fsize,2) == 0
                fsize = fsize - 1; % kernel size must be odd
            end
            denoised = denoise(im_noise, ft, fsize, fs);
        else
            denoised = denoise(im_noise, ft, fs);
        end
        plot_idx = (ft_idx - 1)*numel(fsizes) + fs_idx;
        subplot(numel(ftypes), numel(fsizes), plot_idx);
        imshow(denoised), title(sprintf('%s, %.1f', ft, fs));
        fprintf('psnr %s %.1f:  %.1f \n', ft, fs, myPSNR(im_orig, denoised));
    end
end
end

