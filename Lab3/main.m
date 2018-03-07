close all
clear
warning('off','all');

demo_harris_corner_detection();
demo_lucas_kanade();
demo_feature_tracking();
% tune_harris_threshold();

function demo_harris_corner_detection()
    im_person = imread('person_toy/00000001.jpg');
    im_pingpong = imread('pingpong/0000.jpeg'); 
    dgrees = randi([1,360]);
    im_rotated = imrotate(im_person, dgrees);

    harris_corner_detector(im_person);
    harris_corner_detector(im_pingpong);
    harris_corner_detector(im_rotated);
end

function demo_lucas_kanade()
    im_synth1 = imread('synth1.pgm');
    im_synth2 = imread('synth2.pgm');
    lucas_kanade(im_synth1, im_synth2);

    im_sphere1 = imread('sphere1.ppm');
    im_sphere2 = imread('sphere2.ppm');
    lucas_kanade(im_sphere1, im_sphere2);
end

function demo_feature_tracking()
    function track_fratures_in_frames(dirname, ext, resize_factor)
        imagefiles = dir(strcat(dirname, '/*.', ext));  
        video_name = strcat(dirname, '.avi');
        for i=1:length(imagefiles)
           fname = fullfile(dirname, imagefiles(i).name);
           frame = imread(fname);
           frames(:,:,i) = im2double(rgb2gray(frame));
           fprintf('%s \n', fname);
        end
        tracking(frames, video_name, resize_factor);
    end

    % track person toy with resize factor 0.5, and
    % track pingpong without resizing
    track_fratures_in_frames('person_toy', 'jpg', 0.5);
    track_fratures_in_frames('pingpong', 'jpeg', 1);

end

function tune_harris_threshold()
    % Finding a reasonable threshold
    % by visual inspection on one image
    for i=(0:0.25:3)
        harris_corner_detector(im_person, i);
    end

    % Finetuning a reasonable threshold
    % by visual inspection on two images
    for i=(0.1:0.1:0.4)
        harris_corner_detector(im_person, i);
        harris_corner_detector(im_pingpong, i);
    end
end
