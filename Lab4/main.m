%run ../vlfeat0921/toolbox/vl_setup
close all
clear

%demo_image_alignment('boat1.pgm', 'boat2.pgm');
demo_image_alignment('boat2.pgm', 'boat1.pgm');
%demo_stitching('left.jpg', 'right.jpg');
%demo_stitching('right.jpg', 'left.jpg');

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

    % TODO show images side by side with lines connecting the matches
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

end

function visualize_matching_keypoints(matches, im1, im2, f1, f2)

    % concatenate the images    
    h1 = size(im1, 1);
    h2 = size(im2, 1);
    h = max(h1, h2);
    im1_padded = zeros(h, size(im1, 2), 'uint8');
    im2_padded = zeros(h, size(im2, 2), 'uint8');    
    im1_padded(1:size(im1, 1),1:size(im1, 2)) = im1;
    im2_padded(1:size(im2, 1),1:size(im2, 2)) = im2;        
    im_concatenated = cat(2, im1_padded, im2_padded);

    % random sample of size 50
    r = randperm(size(matches, 2), 50);
    sample_matches = matches(:, r);

    % select pixel coordinates of selected matches 
    X_1 = f1(1,sample_matches(1,:));
    Y_1 = f1(2,sample_matches(1,:));
    X_2 = f2(1,sample_matches(2,:)) + size(im1, 2);
    Y_2 = f2(2,sample_matches(2,:));

    % Plot this
    figure(1);
    imshow(im_concatenated);

    hold on;

    % Create the lines
    lines = plot([X_1; X_2], [Y_1;Y_2]);
    set(lines,'color','y');

    % create the points
    vl_plotframe(f1(:, sample_matches(1,:)));
    f2(1,:) = f2(1,:) + size(im1, 2);
    vl_plotframe(f2(:, sample_matches(2,:)));

    hold off;
end