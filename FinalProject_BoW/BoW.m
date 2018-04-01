function [classifiers, vocabulary] = BoW(fnames_vocabulary, fnames_train, labels_train, vocabulary_size, colorspace, detector, kernel)

features_vocabulary = extract_features(fnames_vocabulary, colorspace, detector);
vocabulary = build_vocabulary(features_vocabulary, vocabulary_size);
features_train = extract_features(fnames_train, colorspace, detector);
histograms_train = build_histograms(features_train, vocabulary);
classifiers = train_classifiers(histograms_train, labels_train, kernel);
end