function classifiers = train_classifiers(histograms, labels, kernel)

    nr_of_classes = length(unique(labels));
    classifiers = cell(nr_of_classes, 1);
    for k = 1 : nr_of_classes 
       binary_labels = labels == k;
       classifiers{k} = fitcsvm(transpose(histograms), binary_labels, 'KernelFunction', kernel);

       % DEBUG
       mj1 = transpose(predict(classifiers{k}, transpose(histograms)));
       mj2 = transpose(binary_labels);
    end
end