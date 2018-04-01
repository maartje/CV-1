%run ../vlfeat0921/toolbox/vl_setup
close all
clear
warning('off','all');

demo(10, 10, "RGB", "keypoints", 'linear');

%% Run demo with default config
demo(200, 400, "RGB", "keypoints", 'linear');

%% Run demo with optimized config (but computational expensive)
demo(150, 800, "RGB", "dense", 'RBF');

function demo(vocabulary_sample_size, vocabulary_size, colorspace, detector, kernel)

tic;

%% split training data into a set for building the vocabulary and a set for training the classifier
[fnames_vocabulary, fnames_train, labels_train, fnames_test, labels_test] = split_data(vocabulary_sample_size, 0, 2);

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


