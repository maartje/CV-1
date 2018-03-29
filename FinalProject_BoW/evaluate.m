function [map, ap_scores] = evaluate(classifiers, histograms, labels, fnames)

	ap_scores = zeros(length(classifiers), 1);
	for k = 1 : length(classifiers)
		classifier = classifiers{k};
		[predicted_labels, scores] = predict(classifier, transpose(histograms));
		[~, I] = sort(scores(:, 1));
		%ranked_files = fnames(I);
		
		binary_labels = labels == k;
		binary_labels_ranked = binary_labels(I);
		ap = calculate_average_precision(binary_labels_ranked);
		ap_scores(k) = ap; 
	end
	map = mean(ap_scores);
end

function ap = calculate_average_precision(binary_labels_ranked)
    labels = binary_labels_ranked(:);
	n = length(labels); % 7
	m = sum(labels);    % 4
    retrievals_at_rank = cumsum(transpose(labels));
    precision_at_rank = retrievals_at_rank ./ (1:n);
    ap = (1/m) * (precision_at_rank * labels);
end
