function histograms = build_histograms(features_of_images, vocabulary)
    histograms = zeros(size(vocabulary,1), length(features_of_images));
    for i=1:length(features_of_images)
        features = features_of_images{i};
        
        % find indices of visual words with minimum distance to features 
        distances = pdist2(transpose(features), vocabulary);
        [~, matching_words] = min(distances, [], 2);
        
        % build normalized histogram 
        histogram = zeros(size(vocabulary, 1), 1);
        for k = 1:length(matching_words)
            histogram(matching_words(k)) = histogram(matching_words(k)) + 1;
        end
%         histogram = histogram ./ size(features, 2);

        % store histogram for image as column
        histograms(:, i) = normc(histogram);
    end
end

