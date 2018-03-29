% histograms_train = build_histograms(features_train, vocabulary);
% classifiers = train_classifiers(histograms_train, labels_train, 'linear');
% normalized_features_vocabulary = cellfun(@(f) normc(f), features_vocabulary, 'UniformOutput', false);
% vocabulary = build_vocabulary(features_vocabulary, 400, 1);
%histograms_train = build_histograms(features_train, vocabulary);
%classifiers = train_classifiers(histograms_train, labels_train, 'linear');

% binary_labels_ranked = [1,1,0,1,0,0,1];
% calculate_average_precision(binary_labels_ranked);
% 
% 
% function ap = calculate_average_precision(binary_labels_ranked)
%     labels = binary_labels_ranked(:);
% 	n = length(labels); % 7
% 	m = sum(labels);    % 4
%     retrievals_at_rank = cumsum(transpose(labels));
%     precision_at_rank = retrievals_at_rank ./ (1:n);
%     ap = (1/m) * (precision_at_rank * labels);
% end

%% split training data into a set for building the vocabulary and a set for training the classifier
[xfnames_vocabulary, xfnames_train, xlabels_train, xfnames_test, xlabels_test, xfnames_dev, xlabels_dev] = split_data( ...
        3, 4);
 x = 1;
