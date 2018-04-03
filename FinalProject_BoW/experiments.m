%run ../vlfeat0921/toolbox/vl_setup
close all
clear
warning('off','all');

%% Default Config
config = default_config();

%% Alternate Config Settings
vocabulary_sizes = [50, 100, 200, 800, 1600, 2000, 4000];
colorspaces = ["RGB", "rgb", "opponent", "grey"];
detectors = ["dense", "keypoints"];
kernels = {'RBF', 'polynomial'}; % polynomial with order 3 by default
vocabulary_sample_sizes = [1, 10, 25, 50, 100];
train_sample_sizes = [1, 10, 25, 50, 100];

%% EXPERIMENT: use default settings
[fnames_vocabulary, fnames_train, labels_train, ~, ~, fnames_dev, labels_dev] = split_data( ...
        config('VOCABULARY SAMPLE SIZE'), config('DEV SAMPLE SIZE'), config('TRAIN SAMPLE SIZE'));
[classifiers, vocabulary, features_vocabulary, features_train, histograms_train] = BoW(fnames_vocabulary, fnames_train, labels_train, ...
    config('VOCABULARY SIZE'), config('SIFT COLORSPACE'), config('SIFT DETECTOR'), config('KERNEL'));
[predicted_labels_dev, scores_dev] = predict(fnames_dev, classifiers, vocabulary, config('SIFT COLORSPACE'), config('SIFT DETECTOR'));
[MAP, AP_scores, ranked_lists] = evaluate(labels_dev, scores_dev, fnames_dev);
generate_html(config, MAP, AP_scores, ranked_lists);
analyze_errors(labels_dev, predicted_labels_dev);

%% EXPERIMENT: vary kernel type (reuse histograms_train, vocabulary)
for kernel = kernels
    config_kernel = containers.Map(config.keys, config.values);
    config_kernel('KERNEL') = kernel{1};

    classifiers_kernel = train_classifiers(histograms_train, labels_train, config_kernel('KERNEL'));
    [predicted_labels_dev, scores_dev] = predict(fnames_dev, classifiers_kernel, vocabulary, config_kernel('SIFT COLORSPACE'), config_kernel('SIFT DETECTOR'));
    [MAP, AP_scores, ranked_lists] = evaluate(labels_dev, scores_dev, fnames_dev);
    generate_html(config_kernel, MAP, AP_scores, ranked_lists);
end

%% EXPERIMENT: vary vocabulary size (reuse features_vocabulary, features_train)   
for vocabulary_size_idx = 1 : length(vocabulary_sizes)
    config_vocab_size = containers.Map(config.keys, config.values);
    config_vocab_size('VOCABULARY SIZE') = vocabulary_sizes(vocabulary_size_idx);

    vocabulary = build_vocabulary(features_vocabulary, config_vocab_size('VOCABULARY SIZE'));    
    histograms_train = build_histograms(features_train, vocabulary);
    classifiers = train_classifiers(histograms_train, labels_train, config_vocab_size('KERNEL'));

    [predicted_labels_dev, scores_dev] = predict(fnames_dev, classifiers, vocabulary, config_vocab_size('SIFT COLORSPACE'), config_vocab_size('SIFT DETECTOR'));
    [MAP, AP_scores, ranked_lists] = evaluate(labels_dev, scores_dev, fnames_dev);
    generate_html(config_vocab_size, MAP, AP_scores, ranked_lists);
end


%% EXPERIMENT: vary SIFT descriptors (reuse filenames and labels)
for detector_idx = 1 : length(detectors)
    for colorspace_idx = 1 : length(colorspaces)
        config_SIFT = containers.Map(config.keys, config.values);
        config_SIFT('SIFT DETECTOR') = detectors(detector_idx);
        config_SIFT('SIFT COLORSPACE') = colorspaces(colorspace_idx);

        if strcmp(config_SIFT('SIFT COLORSPACE'), config('SIFT COLORSPACE')) && strcmp(config_SIFT('SIFT DETECTOR'), config('SIFT DETECTOR'))
            continue; % default config, already processed
        end
        if strcmp(config_SIFT('SIFT COLORSPACE'), 'rgb') && strcmp(config_SIFT('SIFT DETECTOR'), 'dense')
            continue; % crashes matlab
        end
        [classifiers, vocabulary] = BoW(fnames_vocabulary, fnames_train, labels_train, ...
            config_SIFT('VOCABULARY SIZE'), config_SIFT('SIFT COLORSPACE'), config_SIFT('SIFT DETECTOR'), config_SIFT('KERNEL'));
        [predicted_labels_dev, scores_dev] = predict(fnames_dev, classifiers, vocabulary, config_SIFT('SIFT COLORSPACE'), config_SIFT('SIFT DETECTOR'));
        [MAP, AP_scores, ranked_lists] = evaluate(labels_dev, scores_dev, fnames_dev);
        generate_html(config_SIFT, MAP, AP_scores, ranked_lists);
    end
end

vocabulary_sizes = [10, 100, 500, 1000];
for vocab_size_idx = 1 : length(vocabulary_sizes)
    config_vocab_size = containers.Map(config.keys, config.values);
    config_vocab_size('VOCABULARY SIZE') = vocabulary_sizes(vocab_size_idx);

    % default sample sizes of 150 and 150
    [classifiers, vocabulary, ~, ~, ~] = BoW(fnames_vocabulary, fnames_train, labels_train, ...
        config_vocab_size('VOCABULARY SIZE'), config_vocab_size('SIFT COLORSPACE'), config_vocab_size('SIFT DETECTOR'), config_vocab_size('KERNEL'));
    [~, scores_dev] = predict(fnames_dev, classifiers, vocabulary, config_vocab_size('SIFT COLORSPACE'), config_vocab_size('SIFT DETECTOR'));
    [MAP, AP_scores, ranked_lists] = evaluate(labels_dev, scores_dev, fnames_dev);
    generate_html(config_vocab_size, MAP, AP_scores, ranked_lists);

    %% EXPERIMENT: vary train sample sizes (reuse vocabulary)
    for train_sample_size_idx = 1 : length(train_sample_sizes)
        config_sample_train = containers.Map(config_vocab_size.keys, config_vocab_size.values);
        config_sample_train('TRAIN SAMPLE SIZE') = train_sample_sizes(train_sample_size_idx);
        [~, alt_fnames_train, alt_labels_train, ~, ~, alt_fnames_dev, alt_labels_dev] = split_data( ...
            config_sample_train('VOCABULARY SAMPLE SIZE'), config_sample_train('DEV SAMPLE SIZE'), config_sample_train('TRAIN SAMPLE SIZE'));

        features_train = extract_features(alt_fnames_train, config_sample_train('SIFT COLORSPACE'), config_sample_train('SIFT DETECTOR'));
        histograms_train = build_histograms(features_train, vocabulary);
        classifiers = train_classifiers(histograms_train, alt_labels_train, config_sample_train('KERNEL'));

        [~, scores_dev] = predict(alt_fnames_dev, classifiers, vocabulary, config_sample_train('SIFT COLORSPACE'), config_sample_train('SIFT DETECTOR'));
        [MAP, AP_scores, ranked_lists] = evaluate(alt_labels_dev, scores_dev, alt_fnames_dev);
        generate_html(config_sample_train, MAP, AP_scores, ranked_lists);

    end
    for vocab_sample_size_idx = 1 : length(vocabulary_sample_sizes)
        config_sample_vocab = containers.Map(config_vocab_size.keys, config_vocab_size.values);
        config_sample_vocab('VOCABULARY SAMPLE SIZE') = vocabulary_sample_sizes(vocab_sample_size_idx);
        [fnames_vocabulary, fnames_train, labels_train, ~, ~, fnames_dev, labels_dev] = split_data( ...
                config_sample_vocab('VOCABULARY SAMPLE SIZE'), config_sample_vocab('DEV SAMPLE SIZE'), config_sample_vocab('TRAIN SAMPLE SIZE'));
        [classifiers, vocabulary, features_vocabulary, features_train, histograms_train] = BoW(fnames_vocabulary, fnames_train, labels_train, ...
            config_sample_vocab('VOCABULARY SIZE'), config_sample_vocab('SIFT COLORSPACE'), config_sample_vocab('SIFT DETECTOR'), config_sample_vocab('KERNEL'));
        [predicted_labels_dev, scores_dev] = predict(fnames_dev, classifiers, vocabulary, config_sample_vocab('SIFT COLORSPACE'), config_sample_vocab('SIFT DETECTOR'));
        [MAP, AP_scores, ranked_lists] = evaluate(labels_dev, scores_dev, fnames_dev);
        generate_html(config_sample_vocab, MAP, AP_scores, ranked_lists);
    end

end

function config = default_config()
    keySet =   {
        'VOCABULARY SAMPLE SIZE', ...
        'TRAIN SAMPLE SIZE', ...
        'SIFT DETECTOR', ...
        'SIFT COLORSPACE', ...
        'VOCABULARY SIZE', ...
        'KERNEL', ...
        'DEV SAMPLE SIZE', ...
        'CONTEXT'
        };
%     valueSet = {2, 2, 'keypoints', 'RGB', 20, 'linear', 10};
    valueSet = {150, 150, 'keypoints', 'RGB', 400, 'linear', 100, 'validation'};
    config = containers.Map(keySet,valueSet);
end


