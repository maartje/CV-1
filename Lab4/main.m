%run ../vlfeat0921/toolbox/vl_setup
close all
clear

demo_image_alignment('boat1.pgm', 'boat2.pgm');
demo_image_alignment('boat2.pgm', 'boat1.pgm');
demo_stitching('left.jpg', 'right.jpg');
demo_stitching('right.jpg', 'left.jpg');

function demo_stitching(impath1, impath2)
    % stitch two images
    im1 = imread(impath1);
    im2 = imread(impath2);
    im_stitched = stitch(im1, im2);

    % show original images and stitched images
    figure;
    subplot(1,3,1);
    imshow(im1);
    subplot(1,3,2);
    imshow(im2);
    subplot(1,3,3);
    imshow(im_stitched);
end

function demo_image_alignment(impath1, impath2)

    % read two images
    im1 = imread(impath1);
    im2 = imread(impath2);

    % transform image1 to image2
    [f1, f2, kpmatches] = keypoint_matching(im1, im2);
    [M, T] = ransac(f1, f2, kpmatches, 5, 4);    
    im1_to_im2 = transform_image(im1, M, T);

    % transform image1 to image2 using matlab functions
    A = zeros(3,3);
    A(3, 3) = 1;
    A(1:2, 1:2) = transpose(M);
    A(3, 1:2) = T;
    trform = affine2d(A);
    im1_to_im2_mtl = imwarp(im1, trform);

    % plot
    figure;
    subplot(2,2,1);
    imshow(im1);
    subplot(2,2,2);
    imshow(im2);
    subplot(2,2,3);
    imshow(im1_to_im2);
    subplot(2,2,4);
    imshow(im1_to_im2_mtl);

end

