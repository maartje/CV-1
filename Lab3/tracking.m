function tracking(frames)

% calculate row and column indices in first frame for points to be tracked
first_frame = frames(:,:,1);
[~, r, c] = harris_corner_detector(first_frame, 0.25, false);

% track r, c values along frames and calculate the flow vectors for these points 
[~,~,d] = size(frames);
for i = 1 : (d-1)
    % calculate flow for tracked points in x and y direction
    flow = lucas_kanade(frames(:, :, i), frames(:, :, i + 1), false);
    flowX = flow(:,:,1);
    flowY = flow(:,:,2);    
    idx = sub2ind(size(frames(:, :, i)), r, c);
    rcflowX = flowX(idx);
    rcflowY = flowY(idx);

    figure;
    imshow(frames(:, :, i));
    hold on
    quiver(c, r, rcflowX, rcflowY, 'color',[1 0 0]);
    hold off

    % update r and c values
    r = round(r + rcflowY);
    c = round(c + rcflowX);
    

    
end
end