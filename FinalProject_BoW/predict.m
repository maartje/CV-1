function [labels, scores] = predict(fnames, classifiers, vocabulary, colorspace, detector)
    features = extract_features(fnames, colorspace, detector);
    histograms = build_histograms(features, vocabulary);

    labels = zeros(length(fnames), 4);
    scores = zeros(length(fnames), 4);
	for k = 1 : length(classifiers)
		classifier = classifiers{k};
		[klabels, kscores] = predict(classifier, transpose(histograms));
        labels(:, k) = klabels;
        scores(:, k) = kscores(:, 1);
end