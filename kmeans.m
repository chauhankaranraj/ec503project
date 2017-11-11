load fisheriris
X = meas(:,3:4);
k = 3;

% figure;
% plot(X(:,1),X(:,2),'k*','MarkerSize',5);
% title 'Fisher''s Iris Data';
% xlabel 'Petal Lengths (cm)';
% ylabel 'Petal Widths (cm)';

centroids = get_initial_centroids(X, 3);
closest_centroids = get_closest_centroids(X, inital_centroids);

max_iterations = 10;
for i=1:max_iterations

    closest_centroids = get_closest_centroids(X, centroids);
    
    for j = 1:k
        centroid_pts_idx = closest_centroids == j;
        centroids(:, j) = mean(X(:, centroid_pts_idx));
    end
    
end

function closest_centroids = get_closest_centroids(X, centroids)

    % mxn matrix where row i,col j is distance of jth pt from ith centroid 
    distances_from_centroids = zeros(size(centroids,2), size(X,2));
    
    % calculate distance from each centroid
    for centroid_num = 1:size(centroids, 2)
        
        distances_from_centroids(centroid_num) = ...
            (X - centroids(centroid_num, :)) .^ 2;
    
    end
    
    % get the closest centroid number
    [~, closest_centroids] = max(distances_from_centroids);

end


function initial_centroids = get_initial_centroids(X, k, is_col_vectors)
% each col of X is a data point
    
    % default assumes X is d x n matrix
    if nargin < 3
        is_col_vectors = 1;
    end

    if ~is_col_vectors
        X = transpose(X);
    end

    % indices of data points to be selected as initial centroids
    x_indices = randperm(size(X,2), k);
    
    % extract data points at chosen indices
    initial_centroids = X(:, x_indices);

end
