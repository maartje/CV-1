function tracking(frames, fname_video)
process_frames(frames);
end

function arrows = process_frames(frames)

% calculate row and column indices in first frame for points to be tracked
first_frame = frames(:,:,1);
[~, r, c] = harris_corner_detector(first_frame, 0.25, false);

% track r, c values along frames and calculate the flow vectors for these points 
[~,~,d] = size(frames);
arrows = zeros(4, length(r), d-1);
for i = 1 : (d-1)
    % calculate flow for tracked points in x and y direction
    [rcflowX, rcflowY] = flow_vectors(frames(:, :, i), frames(:, :, i + 1), r, c);
    arrows (1, :, i) = r;
    arrows (2, :, i) = c;
    arrows (3, :, i) = rcflowX;
    arrows (4, :, i) = rcflowY;

%     if mod(i,10) == 1
%         figure;
%         imshow(frames(:, :, i));
%         hold on
%         quiver(c, r, rcflowX, rcflowY, 'color',[1 0 0]);
%         hold off
%     end


    % update r and c values
    r = round(r + rcflowY);
    c = round(c + rcflowX);    
end
end

function [rcflowX, rcflowY] = flow_vectors(frame_current, frame_next, r_current, c_current)
    flow = lucas_kanade(frame_current, frame_next, false);
    flowX = flow(:,:,1);
    flowY = flow(:,:,2);    
    idx = sub2ind(size(frame_current), r_current, c_current);
    rcflowX = flowX(idx);
    rcflowY = flowY(idx);
end