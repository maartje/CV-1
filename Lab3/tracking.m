function tracking(frame_sequence, fname_video, resize_factor)
    % settings
    arrow_scale = 30;
    harris_sigma1 = 2;
    harris_sigma2 = 2;
    harris_local_max_window_size = 9;

    % get number of frames
    [~,~,frame_count] = size(frame_sequence);

    % resize frames and scale harris parameters accordingly
    if nargin > 2
        for i = 1 : frame_count
            frames(:,:,i) = imresize(frame_sequence(:,:,i), resize_factor);
        end
        
        % scale harris parameters so that the same content is matched 
        % in the gaussian and local max windows
        harris_sigma1 = resize_factor*harris_sigma1;
        harris_sigma2 = resize_factor*harris_sigma2;
        harris_local_max_window_size = max(3, ceil(resize_factor * harris_local_max_window_size));
        if mod(harris_local_max_window_size, 2) == 0
            harris_local_max_window_size = harris_local_max_window_size + 1;
        end
    else
        frames = frame_sequence;
    end

    % open video writer
    fig = figure;
    writerObj = VideoWriter(fname_video);
    writerObj.FrameRate = 15;
    open(writerObj); 

    % calculate row and column indices in first frame for points to be tracked
    first_frame = frames(:,:,1);
    [~, r, c] = harris_corner_detector(first_frame, 0.25, harris_sigma1, harris_sigma2, harris_local_max_window_size, false);

    % track r, c values along frames and calculate the flow vectors for these points 
    for i = 1 : (frame_count - 1)

        % calculate flow for tracked points in x and y direction
        % and calculate positions of tracked points in next frame
        [rcflowX, rcflowY, r_next, c_next] = process_frame(frames(:, :, i), frames(:, :, i + 1), r, c);

        % write video frame with current frame and arrows to visualize the flow
        figure(fig);
        imshow(frames(:, :, i));
        hold on;
        quiver(c, r, arrow_scale * rcflowX, arrow_scale * rcflowY, 0, 'color',[1 0 0]);
        frame = getframe(gcf);
        writeVideo(writerObj, frame);
        hold off;
        drawnow, pause(0.15)

        % write figures for report
%         if mod(i,10) == 1
%             figure('Name', strcat('frame ', num2str(i)));
%             imshow(frames(:, :, i));
%             hold on;
%             quiver(c, r, arrow_scale * rcflowX, arrow_scale * rcflowY, 0, 'color',[1 0 0]);
%             hold off;
%         end

        % update r and c values
        r = r_next;
        c = c_next;    
    end
    
    % close video writer
    close(writerObj);
end

% calculate flow in current frame and calculate positions of tracked points in next frame 
function [rcflowX, rcflowY, r_next, c_next] = process_frame(frame_current, frame_next, r_current, c_current)
    
    % calculate flow in x and y direction
    flow = lucas_kanade(frame_current, frame_next, false);
    flowX = flow(:,:,1);
    flowY = flow(:,:,2);    
    idx = sub2ind(size(frame_current), r_current, c_current);
    rcflowX = flowX(idx);
    rcflowY = flowY(idx);
    
    % calculate tracking points for next frame
    r_next = round(r_current + rcflowY);
    c_next = round(c_current + rcflowX);
    
    % remove tracking points outside the image boundery
    [rows, columns] = size(frame_next);
    filter_boundery = r_next <= rows & c_next <= columns;
    r_next = r_next(filter_boundery);
    c_next = c_next(filter_boundery);
end