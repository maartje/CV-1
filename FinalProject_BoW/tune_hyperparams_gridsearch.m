%run ../vlfeat0921/toolbox/vl_setup
close all
clear
warning('off','all');


%% Hyperparameters
vocabulary_sizes = [400, 800, 1600, 2000, 4000];
colorspaces = ["RGB", "rgb", "opponent", "grey"];
detectors = ["keypoints", "dense"];
kernels = {'linear', 'RBF', 'polynomial'};

%% Fixed parameters
vocabulary_sample_size = 120;
dev_sample_size = 100;
train_sample_size = 150;
replicates = 1;

%% split training data into a set for building the vocabulary and a set for training the classifier
[fnames_vocabulary, fnames_train, labels_train, fnames_test, labels_test, fnames_dev, labels_dev] = split_data( ...
        vocabulary_sample_size, dev_sample_size, train_sample_size);

for colorspace_idx = 1 : length(colorspaces)
for detector_idx = 1 : length(detectors)
    colorspace = colorspaces(colorspace_idx);
    detector = detectors(detector_idx);
    features_vocabulary = extract_features(fnames_vocabulary, colorspace, detector);
    features_train = extract_features(fnames_train, colorspace, detector);
    features_dev = extract_features(fnames_dev, colorspace, detector);
    for vocabulary_size_idx = 1 : length(vocabulary_sizes)
        vocabulary_size = vocabulary_sizes(vocabulary_size_idx);
        vocabulary = build_vocabulary(features_vocabulary, vocabulary_size, replicates);
        histograms_train = build_histograms(features_train, vocabulary);
        histograms_dev = build_histograms(features_dev, vocabulary);
        for kernel = kernels
            classifiers = train_classifiers(histograms_train, labels_train, kernel{1});
            [map, ap_scores] = evaluate(classifiers, histograms_dev, labels_dev, fnames_dev);
            
            disp({colorspace, detector, vocabulary_size, kernel{1}, map});
        end
    end
end
end