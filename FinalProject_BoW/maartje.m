keySet =   {
    'VOCABULARY SAMPLE SIZE', ...
    'TRAIN SAMPLE SIZE', ...
    'SIFT DETECTOR', ...
    'SIFT COLORSPACE', ...
    'VOCABULARY SIZE', ...
    'KERNEL',...
    'CONTEXT'};
valueSet = {150, 250, 'keypoints', 'RGB', 400, 'linear', 'test'};
configx = containers.Map(keySet,valueSet);

config = containers.Map(configx.keys, configx.values);

MAP = 0.123456;
AP_scores = [0.1234, 0.2345, 0.3456, 0.7892];

nr_of_test_files = 2;
nr_of_classes = 4;
ranked_lists = cell(nr_of_test_files, nr_of_classes);
ranked_lists(:,1) = {'a1', 'a2'};
ranked_lists(:,2) = {'c1', 'c2'};
ranked_lists(:,3) = {'f1', 'f2'};
ranked_lists(:,4) = {'m1', 'm2'};

generate_html(config, MAP, AP_scores, ranked_lists);