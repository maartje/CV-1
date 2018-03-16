%run ../vlfeat0921/toolbox/vl_setup
close all
clear

demo_image_alignment('boat1.pgm', 'boat2.pgm');
demo_image_alignment('boat2.pgm', 'boat1.pgm');
demo_stitching('left.jpg', 'right.jpg');
demo_stitching('right.jpg', 'left.jpg');
% experiment_ransac('boat1.pgm', 'boat2.pgm');

function demo_image_alignment(impath1, impath2)

    % read two images
    im1 = imread(impath1);
    im2 = imread(impath2);

    % transform image1 to image2
    [f1, f2, kpmatches] = keypoint_matching(im1, im2);
    [M, T] = ransac(f1, f2, kpmatches, 20, 4);    
    im1_to_im2 = transform_image(im1, M, T);

    % transform image1 to image2 using matlab functions
    A = zeros(3,3);
    A(3, 3) = 1;
    A(1:2, 1:2) = transpose(M);
    A(3, 1:2) = T;
    trform = affine2d(A);
    im1_to_im2_mtl = imwarp(im1, trform, 'nearest');

    % show images side by side with lines connecting the matches
    visualize_matching_keypoints(kpmatches, im1, im2, f1, f2);

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
    
    [~, fname1, ~] = fileparts(impath1);
    [~, fname2, ~] = fileparts(impath2);
    imwrite(im1_to_im2, strcat(fname1, '_to_', fname2, '.png'));
    imwrite(im1_to_im2_mtl, strcat(fname1, '_to_', fname2, '_mtl', '.png'));

end

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
    
    [~, fname1, ~] = fileparts(impath1);
    [~, fname2, ~] = fileparts(impath2);
    imwrite(im_stitched, strcat('stitched_', fname1, '_', fname2, '.png'));
end

function experiment_ransac(impath1, impath2)

    % read two images
    im1 = imread(impath1);
    im2 = imread(impath2);
    
    % perform ransac
    [f1, f2, kpmatches] = keypoint_matching(im1, im2);
    ransac(f1, f2, kpmatches, 5, 4, im1, im2);    
%     ransac(f1, f2, kpmatches, 5, 8, im1, im2);    
%     ransac(f1, f2, kpmatches, 5, 3, im1, im2);    
%     ransac(f1, f2, kpmatches, 5, 2, im1, im2);    
end
