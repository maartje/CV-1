function visualize_matching_keypoints(matches, im1, im2, f1, f2)

    % random sample of size 50
    r = randperm(size(matches, 2), 50);
    sample_matches = matches(:, r);

    % select pixel coordinates of selected matches 
    X1 = f1(1,sample_matches(1,:));
    Y1 = f1(2,sample_matches(1,:));
    X2 = f2(1,sample_matches(2,:)) + size(im1, 2);
    Y2 = f2(2,sample_matches(2,:));

    % concatenate the images    
    im_concatenated = concatenate_images(im1, im2);

    % Plot concatenated figure
    figure();
    imshow(im_concatenated);

    hold on;

    % plot the lines
    lines = plot([X1; X2], [Y1; Y2]);
    set(lines,'color','y');

    % plot the points scale and rotation (if available)
    vl_plotframe(f1(:, sample_matches(1,:)));
    f2(1,:) = f2(1,:) + size(im1, 2);
    vl_plotframe(f2(:, sample_matches(2,:)));

    hold off;
end