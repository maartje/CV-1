function [fnames_vocabulary, fnames_train, labels_train, fnames_test, labels_test, fnames_dev, labels_dev] = split_data( ...
        vocabulary_sample_size, dev_sample_size, train_sample_size)    
    
    %%%% select filenames for all categories
    fnames_airplanes = select_filenames('Caltech4/ImageData/airplanes_train', 'jpg');
    fnames_cars = select_filenames('Caltech4/ImageData/cars_train', 'jpg');
    fnames_faces = select_filenames('Caltech4/ImageData/faces_train', 'jpg');
    fnames_motorbikes = select_filenames('Caltech4/ImageData/motorbikes_train', 'jpg');
    
    %%%% select a subset to build the vocabulary
    if nargin < 1
        vocabulary_sample_size = 250;
    end
    fnames_vocabulary = cat(1, ...
        fnames_airplanes(1:vocabulary_sample_size), ...
        fnames_cars(1:vocabulary_sample_size), ...
        fnames_faces(1:vocabulary_sample_size), ...
        fnames_motorbikes(1:vocabulary_sample_size));

    %%%% select a subset for development iff dev_sample_size is set
    if nargin < 2
        end_index_dev = vocabulary_sample_size;
    else
        % we assume that sizes are chosen sanely
        end_index_dev = vocabulary_sample_size + dev_sample_size;
        fnames_dev = cat(1, ...
            fnames_airplanes(vocabulary_sample_size + 1:end_index_dev), ...
            fnames_cars(vocabulary_sample_size + 1:end_index_dev), ...
            fnames_faces(vocabulary_sample_size + 1:end_index_dev), ...
            fnames_motorbikes(vocabulary_sample_size + 1:end_index_dev));
        labels_dev = cat(1, ...
            1 + zeros(dev_sample_size, 1), ...
            2 + zeros(dev_sample_size, 1), ...
            3 + zeros(dev_sample_size, 1), ...
            4 + zeros(dev_sample_size, 1));
    end
    

    %%%% select a subset for training, or use the remaining files if train_sample_size not set    
    if nargin < 3
        fnames_airplanes_train = fnames_airplanes(end_index_dev + 1:end);
        fnames_cars_train = fnames_cars(end_index_dev + 1:end);
        fnames_faces_train = fnames_faces(end_index_dev + 1:end);
        fnames_motorbikes_train = fnames_motorbikes(end_index_dev + 1:end);
    else 
        % we assume that sizes are chosen sanely
        end_index_train = end_index_dev + train_sample_size;
        fnames_airplanes_train = fnames_airplanes(end_index_dev + 1:end_index_train);
        fnames_cars_train = fnames_cars(end_index_dev + 1:end_index_train);
        fnames_faces_train = fnames_faces(end_index_dev + 1:end_index_train);
        fnames_motorbikes_train = fnames_motorbikes(end_index_dev + 1:end_index_train);
    end     
    fnames_train = cat(1, fnames_airplanes_train, fnames_cars_train, fnames_faces_train, fnames_motorbikes_train);
    labels_train = cat(1, ...
        1 + zeros(length(fnames_airplanes_train), 1), ...
        2 + zeros(length(fnames_cars_train), 1), ...
        3 + zeros(length(fnames_faces_train), 1), ...
        4 + zeros(length(fnames_motorbikes_train), 1));

    %%% test files and labels
    fnames_airplanes_test = select_filenames('Caltech4/ImageData/airplanes_test', 'jpg');
    fnames_cars_test = select_filenames('Caltech4/ImageData/cars_test', 'jpg');
    fnames_faces_test = select_filenames('Caltech4/ImageData/faces_test', 'jpg');
    fnames_motorbikes_test = select_filenames('Caltech4/ImageData/motorbikes_test', 'jpg');
    fnames_test = cat(1, fnames_airplanes_test, fnames_cars_test, fnames_faces_test, fnames_motorbikes_test);
    labels_test = cat(1, ...
        1 + zeros(length(fnames_airplanes_test), 1), ...
        2 + zeros(length(fnames_cars_test), 1), ...
        3 + zeros(length(fnames_faces_test), 1), ...
        4 + zeros(length(fnames_motorbikes_test), 1));
end


function fnames = select_filenames(dirname, ext)
    imagefiles = dir(strcat(dirname, '/*.', ext)); 
    fnames = arrayfun(@(imfile) fullfile(dirname, imfile.name), imagefiles, 'UniformOutput', false);
    color_image_indicators = cellfun(@(x) size(imread(x),3) == 3, fnames);
    fnames = fnames(color_image_indicators);
    % TODO: shuffle
end
