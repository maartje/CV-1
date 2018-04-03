keySet =   {
    'VOCABULARY SAMPLE SIZE', ...
    'TRAIN SAMPLE SIZE', ...
    'SIFT DETECTOR', ...
    'SIFT COLORSPACE', ...
    'VOCABULARY SIZE', ...
    'KERNEL'};
valueSet = {150, 250, 'keypoints', 'RGB', 400, 'linear'};
config = containers.Map(keySet,valueSet);

MAP = 0.123456;
AP_scores = [0.1234, 0.2345, 0.3456, 0.7892];

nr_of_test_files = 2;
nr_of_classes = 4;
ranked_lists = cell(nr_of_test_files, nr_of_classes);
ranked_lists(:,1) = {'a1', 'a2'};
ranked_lists(:,2) = {'c1', 'c2'};
ranked_lists(:,3) = {'f1', 'f2'};
ranked_lists(:,4) = {'m1', 'm2'};

html = generate_html_string(config, MAP, AP_scores, ranked_lists);

fid = fopen('mj.html', 'w');
fprintf(fid, '%s\n', html);
fclose(fid);

function html = generate_html_string(config, MAP, AP_scores, ranked_lists)
    student_header = generate_student_header('Maartje de Jonge', 'Lea van den Brink');
    settings_table = generate_settings_table(config);
    prediction_header = generate_prediction_header(MAP);
    prediction_table = generate_prediction_table(AP_scores, ranked_lists);
    
    template = strjoin({
        '<!DOCTYPE html>', ...
        '<html lang="en">', ...
          '<head>', ...
            '<meta charset="utf-8">', ...
            '<title>Image list prediction</title>', ...
          '<style type="text/css">', ...
           'img {', ...
             'width:200px;', ...
           '}', ...
          '</style>', ...
          '</head>', ...
          '<body>', ...
        '%s', ...
        '<h1>Settings</h1>', ...
        '%s', ...
        '%s', ...
        '<h3><font color="red">Following are the ranking lists for the four categories. Please fill in your lists.</font></h3>', ...
        '<h3><font color="red">The length of each column should be 200 (containing all test images).</font></h3>', ...
        '%s', ...
        '</body>', ...
        '</html>'});
    html = sprintf(template, student_header, settings_table, prediction_header, prediction_table);
end



%tbody = generate_prediction_table_body(airplanes, cars, faces, motorbikes);

% thead = generate_prediction_table_head(AP_scores);


function h2 = generate_student_header(stud_name1, stud_name2)
    h2 = sprintf('<h2>%s, %s</h2>', stud_name1, stud_name2);
end

function table = generate_settings_table(config)
    template = strjoin({
        '<table>', ...
        '<tr><th>SIFT step size</th><td>%d px</td></tr>', ...
        '<tr><th>SIFT block sizes</th><td>%d pixels</td></tr>', ...
        '<tr><th>SIFT method</th><td>%s-SIFT, %s</td></tr>', ...
        '<tr><th>Vocabulary size</th><td>%d words</td></tr>', ...
        '<tr><th>Vocabulary fraction</th><td>%.2f</td></tr>', ...
        '<tr><th>SVM training data</th><td>%d positive, %d negative per class</td></tr>', ...
        '<tr><th>SVM kernel type</th><td>%s</td></tr>', ...
        '</table>'});

    SIFT_step_size = 10;
    SIFT_block_size = 3;
    SIFT_colorspace = config('SIFT COLORSPACE');
    SIFT_detector = config('SIFT DETECTOR');
    vocab_size = config('VOCABULARY SIZE');
    vocab_fraction = config('VOCABULARY SAMPLE SIZE') / (config('VOCABULARY SAMPLE SIZE') + config('TRAIN SAMPLE SIZE'));
    training_data_positive = config('TRAIN SAMPLE SIZE');
    training_data_negative = 3 * training_data_positive;
    kernel_type = config('KERNEL');
    
    table = sprintf(template, ...
        SIFT_step_size, SIFT_block_size, SIFT_colorspace, SIFT_detector, ...
        vocab_size, vocab_fraction, training_data_positive, training_data_negative, ...
        kernel_type);

end

function h1 = generate_prediction_header(map)
    h1 = sprintf('<h1>Prediction lists (MAP: %.3f)</h1>', map);
end

function table = generate_prediction_table(AP_scores, ranked_lists)
    thead = generate_prediction_table_head(AP_scores);
    tbody = generate_prediction_table_body(ranked_lists);
    table = strcat('<table>', thead, tbody, '</table>');
end

function thead = generate_prediction_table_head(AP_scores)
    template = strjoin({'<thead><tr>', ...
        '<th>Airplanes (AP: %.3f)</th>', ...
        '<th>Cars (AP: %.3f)</th>', ...
        '<th>Faces (AP: %.3f)</th>', ...
        '<th>Motorbikes (AP: %.3f)</th>', ...
        '</tr></thead>'});

    thead = sprintf(template, AP_scores(1), AP_scores(2), AP_scores(3), AP_scores(4));
end

function tbody = generate_prediction_table_body(ranked_lists)
    rows = cellfun(@(a, c, f, m) generate_prediction_row(a, c, f, m), ...
        ranked_lists(:, 1), ranked_lists(:, 2), ranked_lists(:, 3), ranked_lists(:, 4), ...
        'UniformOutput', false);
    tbody =  strcat('<tbody>', strjoin(rows), '</tbody>');
end

function tr = generate_prediction_row(fname1, fname2, fname3, fname4)
    tr = strcat( ...
        '<tr>', ...
        generate_prediction_cell(fname1), ...
        generate_prediction_cell(fname2), ...
        generate_prediction_cell(fname3), ...
        generate_prediction_cell(fname4), ...
        '</tr>');
end

function td = generate_prediction_cell(fname)
    td = strcat('<td><img src="', fname, '" /></td>');
end