function confusion_matrix = analyze_errors(labels, predicted_labels)

    tp = 0;
    fp = 0;
    fn = 0;
    tn = 0;
    for k = 1 : size(predicted_labels, 2)
		binary_labels = labels == k;
        kpredicted_labels = predicted_labels(:, k);
        true_positives = kpredicted_labels .* binary_labels;
        true_negatives = (~kpredicted_labels) .* (~binary_labels);
        false_positives = kpredicted_labels .* (~binary_labels);
        false_negatives = (~kpredicted_labels) .* (binary_labels);
        tp = tp + sum(true_positives);
        tn = tn + sum(true_negatives);
        fp = fp + sum(false_positives);
        fn = fn + sum(false_negatives);
        
%         fp_files = fnames(false_positives == 1);
%         fn_files = fnames(false_negatives == 1);
%         disp({'false positives: ', k});
%         disp(fp_files);
%         disp({'false negatives: ', k});
%         disp(fn_files);
    end
    confusion_matrix = [tp, fp; fn, tn];
    disp('confusion matrix: ')
    disp(confusion_matrix);
end
