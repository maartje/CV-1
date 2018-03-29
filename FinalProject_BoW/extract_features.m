function descriptors = extract_features(fnames, colorspace, detector, step_size)
% Extract SIFT descriptors
% fnames: names of image files
% colorspace: 'grey', 'RGB', 'rgb', 'opponent'
% detector: 'dense' or 'keypoints'. Default is 'keypoints'
% stepsize: positive integer
% descriptors: cell array filled with matrices 'feature_size x number of descriptors' for all
% files

    descriptors = cell(length(fnames),1);
    for i=1:length(fnames)
        fname = fnames(i);
        im = imread(fname{1});        
        im_single = im2single(im);
        if nargin > 2 && strcmp(detector, 'dense')
            if nargin < 4
                step_size = 15;
            end
            d = extract_features_dense(im_single, colorspace, step_size);
        else
            d = extract_features_frames(im_single, colorspace);
        end        
        descriptors{i} = normc(double(d));
    end
end

function d = extract_features_dense(im, colorspace, step_size)
% extract dense SIFT descriptions for colorspace

    switch colorspace
        case 'grey'
            d = extract_sift_greyscale_dense(im, step_size);
        case 'RGB'
            d = extract_sift_color_dense(im, step_size);
        case 'rgb'
            d = extract_sift_color_dense(rgb2normedrgb(im), step_size);
        case 'opponent'
            d = extract_sift_color_dense(rgb2opponent(im), step_size);
        otherwise
            error('Unknown colorspace. \n');
    end
end

function d = extract_features_frames(im, colorspace)
% extract keypoint SIFT descriptions for colorspace

    % extract keypoints and SIFT descriptions for greyscale 
    [frames, d_grey] = extract_sift_greyscale(im);

    % extract color SIFT descriptions for keypoints
    switch colorspace
        case 'grey'
            d = d_grey;
        case 'RGB'
            d = extract_sift_color(im, frames);
        case 'rgb'
            im_rgb = rgb2normedrgb(im);
            im_rgb(isnan(im_rgb)) = 0;
            d = extract_sift_color(im_rgb, frames);
        case 'opponent'
            d = extract_sift_color(rgb2opponent(im), frames);
        otherwise
            error('Unknown colorspace. \n');
    end
end

function [f, d] = extract_sift_greyscale(im)

    % convert to grey scale
    if size(im, 3) == 3
        im_grey = rgb2gray(im);
    else
        im_grey = im;
    end

    % get keypoints and descriptors
    [f, d] = vl_sift(im_grey);
end

function d = extract_sift_greyscale_dense(im, step_size)

    % convert to grey scale
    if size(im, 3) == 3
        im_grey = rgb2gray(im);
    else
        im_grey = im;
    end

    % get descriptors dense
    [~, d] = vl_dsift(im_grey, 'Step', step_size);
end

function d = extract_sift_color(im, frames)

    % sift per channel for given frames
    [~, d1] = vl_sift(im(:, :, 1), 'Frames', frames);
    [~, d2] = vl_sift(im(:, :, 2), 'Frames', frames);
    [~, d3] = vl_sift(im(:, :, 3), 'Frames', frames);

    % concatenate
    d = cat(1, d1, d2, d3);
end

function d = extract_sift_color_dense(im, step_size)

    % sift per channel dense
    [~, d1] = vl_dsift(im(:, :, 1), 'Step', step_size);
    [~, d2] = vl_dsift(im(:, :, 2), 'Step', step_size);
    [~, d3] = vl_dsift(im(:, :, 3), 'Step', step_size);        

    % concatenate
    d = cat(1, d1, d2, d3);
end