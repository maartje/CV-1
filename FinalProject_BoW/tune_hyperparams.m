%run ../vlfeat0921/toolbox/vl_setup
close all
clear
warning('off','all');

%% Default Config
d_vocabulary_size = 400;
d_colorspace = "RGB";
d_detector = "keypoints";
d_kernel = 'linear';

%% Alternate Config Settings
vocabulary_sizes = [800, 1600, 2000, 4000];
colorspaces = ["rgb", "opponent", "grey"];
detectors = ["dense"];
kernels = {'RBF', 'polynomial'}; % polynomial with order 3 by default

%% Fixed parameters
vocabulary_sample_size = 150;
dev_sample_size = 100;
%train_sample_size = 150;

%% split training data into a set for building the vocabulary and a set for training the classifier
[fnames_vocabulary, fnames_train, labels_train, ~, ~, fnames_dev, labels_dev] = split_data( ...
        vocabulary_sample_size, dev_sample_size);
 
disp({
    "vocab size", length(fnames_vocabulary), ...
    "dev set size", length(labels_dev), ...
    "training set size", length(labels_train), ...
    "airplanes", sum(labels_train == 1), ...
    "cars", sum(labels_train == 2), ...
    "faces", sum(labels_train == 3), ...
    "motor_bikes", sum(labels_train == 4), ...
 });

tic;

%% use default settings
features_vocabulary = extract_features(fnames_vocabulary, d_colorspace, d_detector);
features_train = extract_features(fnames_train, d_colorspace, d_detector);
features_dev = extract_features(fnames_dev, d_colorspace, d_detector);
disp({"extract features", length([fnames_vocabulary; fnames_train; fnames_dev]), toc});
vocabulary = build_vocabulary(features_vocabulary, d_vocabulary_size);
disp({"build vocabulary", toc});
histograms_train = build_histograms(features_train, vocabulary);
histograms_dev = build_histograms(features_dev, vocabulary);
disp({"histograms from features", length([fnames_train; fnames_dev]), toc});
classifiers = train_classifiers(histograms_train, labels_train, d_kernel);
disp({"train classifiers", toc});
[map, ap_scores] = evaluate(classifiers, histograms_dev, labels_dev, fnames_dev);
disp({"evaluate", toc});
disp({d_colorspace, d_detector, d_vocabulary_size, d_kernel, map});

%% vary kernel type
for kernel = kernels
    classifiers = train_classifiers(histograms_train, labels_train, kernel{1});
    [map, ap_scores] = evaluate(classifiers, histograms_dev, labels_dev, fnames_dev);            
    disp({d_colorspace, d_detector, d_vocabulary_size, kernel{1}, map});
end

%% vary vocabulary size    
for vocabulary_size_idx = 1 : length(vocabulary_sizes)
    vocabulary_size = vocabulary_sizes(vocabulary_size_idx);
    vocabulary = build_vocabulary(features_vocabulary, vocabulary_size);
    histograms_train = build_histograms(features_train, vocabulary);
    histograms_dev = build_histograms(features_dev, vocabulary);
    classifiers = train_classifiers(histograms_train, labels_train, d_kernel);
    [map, ap_scores] = evaluate(classifiers, histograms_dev, labels_dev, fnames_dev);
    disp({d_colorspace, d_detector, vocabulary_size, d_kernel, map});
end

%% vary color spaces
for colorspace_idx = 1 : length(colorspaces)
    colorspace = colorspaces(colorspace_idx);
    features_vocabulary = extract_features(fnames_vocabulary, colorspace, d_detector);
    features_train = extract_features(fnames_train, colorspace, d_detector);
    features_dev = extract_features(fnames_dev, colorspace, d_detector);
    vocabulary = build_vocabulary(features_vocabulary, d_vocabulary_size);
    histograms_train = build_histograms(features_train, vocabulary);
    histograms_dev = build_histograms(features_dev, vocabulary);
    classifiers = train_classifiers(histograms_train, labels_train, d_kernel);
    [map, ap_scores] = evaluate(classifiers, histograms_dev, labels_dev, fnames_dev);

    disp({colorspace, d_detector, d_vocabulary_size, d_kernel, map});
end
    
%% vary detector types    
for detector_idx = 1 : length(detectors)
    detector = detectors(detector_idx);
    features_vocabulary = extract_features(fnames_vocabulary, d_colorspace, detector);
    features_train = extract_features(fnames_train, d_colorspace, detector);
    features_dev = extract_features(fnames_dev, d_colorspace, detector);
    vocabulary = build_vocabulary(features_vocabulary, d_vocabulary_size);
    histograms_train = build_histograms(features_train, vocabulary);
    histograms_dev = build_histograms(features_dev, vocabulary);
    classifiers = train_classifiers(histograms_train, labels_train, d_kernel);
    [map, ap_scores] = evaluate(classifiers, histograms_dev, labels_dev, fnames_dev);

    disp({d_colorspace, detector, d_vocabulary_size, d_kernel, map});
end

disp({"total time: ", toc});
