%run ../vlfeat0921/toolbox/vl_setup
close all
clear
warning('off','all');

%% Default Config
d_vocabulary_size = 400;
d_colorspace = "RGB";
d_detector = "dense";
d_kernel = 'linear';

%% Alternate Config Settings
colorspaces = ["rgb", "opponent", "grey"]; %"rgb", 

%% Fixed parameters
vocabulary_sample_size = 150;
dev_sample_size = 100;
train_sample_size = 150;

%% split training data into a set for building the vocabulary and a set for training the classifier
[fnames_vocabulary, fnames_train, labels_train, ~, ~, fnames_dev, labels_dev] = split_data( ...
        vocabulary_sample_size, dev_sample_size, train_sample_size);

 %% vary color spaces
% for colorspace_idx = 1 : length(colorspaces)
%     colorspace = colorspaces(colorspace_idx);
%     features_vocabulary = extract_features(fnames_vocabulary, colorspace, d_detector);
%     features_train = extract_features(fnames_train, colorspace, d_detector);
%     features_dev = extract_features(fnames_dev, colorspace, d_detector);
%     vocabulary = build_vocabulary(features_vocabulary, d_vocabulary_size);
%     histograms_train = build_histograms(features_train, vocabulary);
%     histograms_dev = build_histograms(features_dev, vocabulary);
%     classifiers = train_classifiers(histograms_train, labels_train, d_kernel);
%     [map, ap_scores] = evaluate(classifiers, histograms_dev, labels_dev, fnames_dev);
% 
%     disp({colorspace, d_detector, d_vocabulary_size, d_kernel, map});
%     disp(transpose(ap_scores));
% end

%% Alternate Config Settings
vocabulary_sample_sizes = [1, 10, 25, 50, 100, 150];
train_sample_sizes = [1, 10, 25, 50, 100, 150];
vocabulary_sizes = [10, 100, 500, 1000];

features_dev = extract_features(fnames_dev, "RGB", "keypoints");
d_features_train = extract_features(fnames_train, "RGB", "keypoints");
d_features_vocabulary = extract_features(fnames_vocabulary, "RGB", "keypoints");


for vocab_size_idx = 1 : length(vocabulary_sizes)
    vocab_size = vocabulary_sizes(vocab_size_idx);
    d_vocabulary = build_vocabulary(d_features_vocabulary, vocab_size);
    d_histograms_dev = build_histograms(features_dev, d_vocabulary);

%     for train_sample_size_idx = 1 : length(train_sample_sizes)
%         train_sample_size = train_sample_sizes(train_sample_size_idx);
%         [~, alt_fnames_train, alt_labels_train, ~, ~, ~, ~] = split_data( ...
%         vocabulary_sample_size, dev_sample_size, train_sample_size);
%         alt_features_train = extract_features(alt_fnames_train, "RGB", "keypoints");
%         histograms_train = build_histograms(alt_features_train, d_vocabulary);
%         classifiers = train_classifiers(histograms_train, alt_labels_train, 'linear');
%         [map, ap_scores] = evaluate(classifiers, d_histograms_dev, labels_dev, fnames_dev);
%         [map_train, ap_scores_train] = evaluate(classifiers, histograms_train, alt_labels_train, alt_fnames_train);
% 
%         disp({"train_sample_size", vocab_size, train_sample_size, "map", map, "map_train", map_train});
% %         disp(transpose(ap_scores));
%     
%     end

    for vocab_sample_size_idx = 1 : length(vocabulary_sample_sizes)
        vocab_sample_size = vocabulary_sample_sizes(vocab_sample_size_idx);
        [alt_fnames_vocabulary, ~, ~, ~, ~, ~, ~] = split_data( ...
                vocab_sample_size, dev_sample_size);

        features_vocabulary = extract_features(alt_fnames_vocabulary, "RGB", "keypoints");
        vocabulary = build_vocabulary(features_vocabulary, vocab_size);
        histograms_train = build_histograms(d_features_train, vocabulary);
        histograms_dev = build_histograms(features_dev, vocabulary);
        classifiers = train_classifiers(histograms_train, labels_train, 'linear');
        [map, ap_scores] = evaluate(classifiers, histograms_dev, labels_dev, fnames_dev);
        [map_train, ap_scores_train] = evaluate(classifiers, histograms_train, labels_train, fnames_train);

        disp({"vocab_sample_size", vocab_size, vocab_sample_size, "map", map, "map_train", map_train});
%         disp(transpose(ap_scores));
    end
end


% vocabulary_sizes = [50, 100, 200];
% for vocab_size_idx = 1 : length(vocabulary_sizes)
%     vocab_size = vocabulary_sizes(vocab_size_idx);
%     vocabulary = build_vocabulary(d_features_vocabulary, vocab_size);
%     histograms_dev = build_histograms(features_dev, vocabulary);
% 
%     histograms_train = build_histograms(d_features_train, vocabulary);
%     classifiers = train_classifiers(histograms_train, labels_train, 'linear');
%     [map, ap_scores] = evaluate(classifiers, histograms_dev, labels_dev, fnames_dev);
%     [map_train, ap_scores_train] = evaluate(classifiers, histograms_train, labels_train, fnames_train);
% 
%     disp({"small vocab", vocab_size, train_sample_size, "map", map, "map_train", map_train});
% %     disp(transpose(ap_scores));
% 
% end

clear

%% Run demo with default config
demo(200, 400, "RGB", "keypoints", 'linear');

%% Run demo with optimized config (but computational expensive)
demo(150, 800, "RGB", "dense", 'RBF');

function demo(vocabulary_sample_size, vocabulary_size, colorspace, detector, kernel)

tic;

%% split training data into a set for building the vocabulary and a set for training the classifier
[fnames_vocabulary, fnames_train, labels_train, fnames_test, labels_test] = split_data(vocabulary_sample_size);

%% build vocabulary and train classifier
[classifiers, vocabulary] = BoW(fnames_vocabulary, fnames_train, labels_train, vocabulary_size, colorspace, detector, kernel);

%% calculate AP scores and MAP score
features_test = extract_features(fnames_test, colorspace, detector);
histograms_test = build_histograms(features_test, vocabulary);
[map, ap_scores] = evaluate(classifiers, histograms_test, labels_test, fnames_test);

%% display MAP results
disp({"nr of vocabulary files", length(fnames_vocabulary), "nr of train files", length(fnames_train), "nr of test files", length(fnames_test)});
disp({colorspace, detector, "vocablary size", vocabulary_size, kernel, "MAP", map, "end time", toc});
disp(transpose(ap_scores));

%% display error analysis results
analyze_errors(classifiers, histograms_test, labels_test, fnames_test);
end


