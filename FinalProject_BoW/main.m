%run ../vlfeat0921/toolbox/vl_setup
close all
clear
warning('off','all');

%% Run demo with default config
demo(200, 200, 400, "RGB", "keypoints", 'linear');

%% Run demo with optimized config (but computational expensive)
demo(130, 270, 1000, "RGB", "dense", 'RBF');

function demo(vocabulary_sample_size, train_sample_size, vocabulary_size, colorspace, detector, kernel)
    tic;
    config = configuration(vocabulary_sample_size, train_sample_size, vocabulary_size, colorspace, detector, kernel);
    [fnames_vocabulary, fnames_train, labels_train, fnames_test, labels_test] = split_data( ...
            config('VOCABULARY SAMPLE SIZE'), config('DEV SAMPLE SIZE'), config('TRAIN SAMPLE SIZE'));
    [classifiers, vocabulary] = BoW(fnames_vocabulary, fnames_train, labels_train, ...
        config('VOCABULARY SIZE'), config('SIFT COLORSPACE'), config('SIFT DETECTOR'), config('KERNEL'));
    [predicted_labels, scores] = predict(fnames_test, classifiers, vocabulary, config('SIFT COLORSPACE'), config('SIFT DETECTOR'));
    [MAP, AP_scores, ranked_lists] = evaluate(labels_test, scores, fnames_test);
    generate_html(config, MAP, AP_scores, ranked_lists);
    analyze_errors(labels_test, predicted_labels);
    
    disp({'duration', toc});
end


function config = configuration(vocabulary_sample_size, train_sample_size, vocabulary_size, colorspace, detector, kernel)
    keySet =   {
        'VOCABULARY SAMPLE SIZE', ...
        'TRAIN SAMPLE SIZE', ...
        'VOCABULARY SIZE', ...
        'SIFT COLORSPACE', ...
        'SIFT DETECTOR', ...
        'KERNEL', ...
        'DEV SAMPLE SIZE', ...
        'CONTEXT'
        };
%     valueSet = {2, 2, 'keypoints', 'RGB', 20, 'linear', 10};
    valueSet = {vocabulary_sample_size, train_sample_size, vocabulary_size, colorspace, detector, kernel, 0, 'test'};
    config = containers.Map(keySet,valueSet);
end
