function vocabulary = build_vocabulary(features_vocabulary, vocabulary_size, replicates)
% Builds a vocabulary by applying kmeans clustering on features
% features_vocabulary: extracted features for an image
% vocabulary_size: size of vocabulary
% replicates (optional): number of replications to search for optimal clustering
% vocabulary: k by p matrix with 
%     k the number of visual words and 
%     p the dimension determined by the dimension of the extracted features

    if nargin < 3
        replicates = 1;
    end
    
    features = cat(2, features_vocabulary{:});
    [~, vocabulary] = kmeans(transpose(features), ...
    vocabulary_size, 'Replicates', replicates, ...
    'MaxIter', 50);
    vocabulary = normr(vocabulary);
end