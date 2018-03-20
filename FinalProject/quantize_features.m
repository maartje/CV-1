function word_frequencies = quantize_features(fnames, fun_extract_features, vocabulary)
    word_frequencies = zeros(size(vocabulary,1), length(fnames));
    for i=1:length(fnames)
        fname = fnames(i);
        im = imread(fname{1});
        word_frequencies(:,i) = quantize_features_for_image(im, fun_extract_features, vocabulary);
    end
end

function word_frequencies = quantize_features_for_image(im, fun_extract_features, vocabulary)
    word_frequencies = zeros(size(vocabulary, 1), 1);
    descriptors = fun_extract_features(im);
        
    for i=1:size(descriptors, 2)
        descriptor = descriptors(:, i);
        distances = sum((vocabulary - transpose(descriptor)) .^2, 2);
        [~, ivoc] = min(distances);
        word_frequencies(ivoc) = word_frequencies(ivoc) + 1;
    end
    word_frequencies = word_frequencies / size(descriptors, 2);
end

