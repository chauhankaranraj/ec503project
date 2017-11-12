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
    for c_num = 1:size(centroids, 2)
        
        distances_from_centroids(c_num) = (X - centroids(c_num, :)) .^ 2;
    
    end
    
    % get the closest centroid number
    [~, closest_centroids] = max(distances_from_centroids);

end


function initial_centroids = get_smart_centroids(X, k, is_col_xi)
    
    % default assumes X is dxn matrix
    if nargin < 3
        is_col_xi = 1;
    end
    
    % transpose if input is not in the required form
    if ~is_col_xi
        X = transpose(X);
    end

    % initialize matrix as NaN's so that max funcion chooses defined value over other centroids
    initial_centroids = NaN(size(X,1), k);
    
    % select first centroid randomly
    initial_centroids(:, 1) = X(:, randi([1 k]));
    
    % initialize distances of each point from each centroid
    distances = zeros(k, size(X,2));
    
    for c_num = 1:k
        
        % find distance of each point from each centroid
        for c_dists = 1:k
            distances(c_dists, :) = sum((X-initial_centroids(:, c_dists)) .^2);
        end
        
        % get the closest centroid, select the point with max distance to its closest centroid
        c_idx = max(min(distances));
        
        % save the point at c_idx as a new centroid
        initial_centroids(:, c_num) = X(:, c_idx);
        
    end

end


function initial_centroids = get_initial_centroids(X, k, is_col_xi)
% each col of X is a data point
    
    % default assumes X is d x n matrix
    if nargin < 3
        is_col_xi = 1;
    end

    if ~is_col_xi
        X = transpose(X);
    end

    % indices of data points to be selected as initial centroids
    x_indices = randperm(size(X,2), k);
    
    % extract data points at chosen indices
    initial_centroids = X(:, x_indices);

end
