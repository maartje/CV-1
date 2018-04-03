%run ../vlfeat0921/toolbox/vl_setup
close all
clear
warning('off','all');

%% Default Config
config = default_config();

%% Alternate Config Settings
vocabulary_sizes = [800, 1600, 2000, 4000];
colorspaces = ["rgb", "opponent", "grey"];
detectors = ["dense"];
kernels = {'RBF', 'polynomial'}; % polynomial with order 3 by default


%% split training data into a set for building the vocabulary and a set for training the classifier
[fnames_vocabulary, fnames_train, labels_train, ~, ~, fnames_dev, labels_dev] = split_data( ...
        config('VOCABULARY SAMPLE SIZE'), config('DEV SAMPLE SIZE'), config('TRAIN SAMPLE SIZE'));

%% use default settings
[classifiers, vocabulary] = BoW(fnames_vocabulary, fnames_train, labels_train, ...
    config('VOCABULARY SIZE'), config('SIFT COLORSPACE'), config('SIFT DETECTOR'), config('KERNEL'));
[~, scores_dev] = predict(fnames_dev, classifiers, vocabulary, config('SIFT COLORSPACE'), config('SIFT DETECTOR'));
[MAP, AP_scores, ranked_lists] = evaluate(labels_dev, scores_dev, fnames_dev);
generate_html(config, MAP, AP_scores, ranked_lists);
    
function config = default_config()
    keySet =   {
        'VOCABULARY SAMPLE SIZE', ...
        'TRAIN SAMPLE SIZE', ...
        'SIFT DETECTOR', ...
        'SIFT COLORSPACE', ...
        'VOCABULARY SIZE', ...
        'KERNEL', ...
        'DEV SAMPLE SIZE'
        };
    valueSet = {2, 2, 'keypoints', 'RGB', 20, 'linear', 10};
    valueSet = {150, 150, 'keypoints', 'RGB', 400, 'linear', 100};
    config = containers.Map(keySet,valueSet);
end


