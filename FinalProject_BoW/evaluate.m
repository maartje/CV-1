function [MAP, AP_scores, ranked_lists] = evaluate(labels, scores, fnames)

    ranked_lists = cell(size(scores));
	AP_scores = zeros(size(scores, 2), 1);
	for k = 1 : size(scores, 2)
        kscores = scores(:, k);
		[~, I] = sort(kscores);
        
		ranked_lists(:, k) = fnames(I);
		
		binary_labels = labels == k;
		binary_labels_ranked = binary_labels(I);
		ap = calculate_average_precision(binary_labels_ranked);
		AP_scores(k) = ap; 
	end
	MAP = mean(AP_scores);
end

function ap = calculate_average_precision(binary_labels_ranked)
    labels = binary_labels_ranked(:);
	n = length(labels); % 7
	m = sum(labels);    % 4
    retrievals_at_rank = cumsum(transpose(labels));
    precision_at_rank = retrievals_at_rank ./ (1:n);
    ap = (1/m) * (precision_at_rank * labels);
end
