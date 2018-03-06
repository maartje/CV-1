function tracking(frames)
first_frame = frames(:,:,1);
[~, r, c] = harris_corner_detector(first_frame);
end