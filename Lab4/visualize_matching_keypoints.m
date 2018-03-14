function visualize_matching_keypoints(matches, im1, im2, f1, f2)

    % random sample of size 50
    r = randperm(size(matches, 2), 50);
    sample_matches = matches(:, r);

    % select pixel coordinates of selected matches 
    X_1 = f1(1,sample_matches(1,:));
    Y_1 = f1(2,sample_matches(1,:));
    X_2 = f2(1,sample_matches(2,:)) + size(im1, 2);
    Y_2 = f2(2,sample_matches(2,:));

    % concatenate the images    
    h1 = size(im1, 1);
    h2 = size(im2, 1);
    h = max(h1, h2);
    im1_padded = zeros(h, size(im1, 2), 'uint8');
    im2_padded = zeros(h, size(im2, 2), 'uint8');    
    im1_padded(1:size(im1, 1),1:size(im1, 2)) = im1;
    im2_padded(1:size(im2, 1),1:size(im2, 2)) = im2;        
    im_concatenated = cat(2, im1_padded, im2_padded);

    % Plot concatenated figure
    figure(1);
    imshow(im_concatenated);

    hold on;

    % plot the lines
    lines = plot([X_1; X_2], [Y_1;Y_2]);
    set(lines,'color','y');

    % plot the points scale and rotation (if available)
    vl_plotframe(f1(:, sample_matches(1,:)));
    f2(1,:) = f2(1,:) + size(im1, 2);
    vl_plotframe(f2(:, sample_matches(2,:)));

    hold off;
end