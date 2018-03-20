function visual_words = build_vocabulary(features, vocabulary_size, replicates)
% Builds a vocabulary by applying kmeans clustering on features
% features: n by p matrix with 
%    p the dimensionality and 
%    n the number of observations
% vocabulary_size: size of vocabulary
% replicates (optional): number of replications to search for optimal clustering
% visual_words: k by p matrix with k the vocabulary size 

    if nargin < 3
        replicates = 1;
    end
    
    % TODO: preprocessing such as normalization?

    [~, visual_words] = kmeans(double(features), vocabulary_size, 'Replicates', replicates);
end