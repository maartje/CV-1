function confusion_matrix = analyze_errors(classifiers, histograms, labels, fnames)

    tp = 0;
    fp = 0;
    fn = 0;
    tn = 0;
    for k = 1 : length(classifiers)
		binary_labels = labels == k;
		classifier = classifiers{k};
		[predicted_labels, ~] = predict(classifier, transpose(histograms));
        true_positives = predicted_labels .* binary_labels;
        true_negatives = (~predicted_labels) .* (~binary_labels);
        false_positives = predicted_labels .* (~binary_labels);
        false_negatives = (~predicted_labels) .* (binary_labels);
        tp = tp + sum(true_positives);
        tn = tn + sum(true_negatives);
        fp = fp + sum(false_positives);
        fn = fn + sum(false_negatives);
        
        fp_files = fnames(false_positives == 1);
        fn_files = fnames(false_negatives == 1);
        disp({'false positives: ', k});
        disp(fp_files);
        disp({'false negatives: ', k});
        disp(fn_files);
    end
    confusion_matrix = [tp, fp; fn, tn];
    disp('confusion matrix: ')
    disp(confusion_matrix);
end
