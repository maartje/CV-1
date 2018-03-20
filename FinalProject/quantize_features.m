function word_frequencies = quantize_features(im, fun_extract_features, vocabulary)
    word_frequencies = zeros(size(vocabulary, 1), 1);
    descriptors = fun_extract_features(im);
    for i=1:size(descriptors, 2)
        descriptor = descriptors(:, i);
        distances = sum((vocabulary - transpose(descriptor)) .^2, 2);
        [~, ivoc] = min(distances);
        word_frequencies(ivoc) = word_frequencies(ivoc) + 1;
    end
end

