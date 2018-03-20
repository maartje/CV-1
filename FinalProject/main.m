% run ../vlfeat0921/toolbox/vl_setup
close all
clear

fnames = select_filenames_to_build_vocabulary(0.01);
descriptors = 0;
for i=1:length(fnames)
    fname = fnames(i);
    im = imread(fname{1});
    d = extract_features(im, 'grey'); % 128 (* 3) x 410
    if descriptors
        descriptors = horzcat(descriptors,d);
    else
        descriptors = d;
    end
end
mj = build_vocabulary(transpose(descriptors), 10, 2);

function fnames = select_filenames_to_build_vocabulary(percentage)
    if nargin < 1
        percentage = 0.5;
    end
    
    fnames_airplanes = select_filenames_randomly('Caltech4/ImageData/airplanes_train', 'jpg', percentage);
    fnames_cars = select_filenames_randomly('Caltech4/ImageData/cars_train', 'jpg', percentage);
    fnames_faces = select_filenames_randomly('Caltech4/ImageData/faces_train', 'jpg', percentage);
    fnames_motorbikes = select_filenames_randomly('Caltech4/ImageData/motorbikes_train', 'jpg', percentage);
    
    fnames = cat(1, fnames_airplanes, fnames_cars, fnames_faces, fnames_motorbikes);
end

function [fnames, indices] = select_filenames_randomly(dirname, ext, percentage)
    imagefiles = dir(strcat(dirname, '/*.', ext)); 
    fnames = arrayfun(@(imfile) fullfile(dirname, imfile.name), imagefiles, 'UniformOutput', false);
    if nargin > 2
        count = ceil(percentage * length(fnames));
        indices = randperm(length(fnames), count);
        fnames = fnames(indices);
    else
        indices = 1: length(fnames);
    end
end


% im_example = imread('Caltech4/ImageData/airplanes_test/img014.jpg');
% f1 = extract_features(im_example, 'rgb', 'dense', 10);
% f2 = extract_features(im_example, 'opponent');
