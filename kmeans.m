%% ORIGINAL DATA
load fisheriris
X = meas(:,3:4);
k = 3;

figure;
plot(X(:,1),X(:,2), 'k.','MarkerSize', 15);
title 'Fisher''s Iris Data';
xlabel 'Petal Lengths (cm)';
ylabel 'Petal Widths (cm)';


%% K-MEANS

% randomly select k points as centroids
centroids = get_initial_centroids(X, 3);

max_iterations = 100;
for i=1:max_iterations

    % find which is the closest centroid for each point
    closest_centroids = get_closest_centroids(X, centroids);
    
    for j = 1:k
        
        % get all points correspoding to centroid j
        centroid_pts_idx = closest_centroids == j;
        
        % set new centroid j as mean of all points closest to previous j
        centroids(j, :) = mean(X(centroid_pts_idx, :));
    
    end
    
end

figure;
plot(centroids(:,1), centroids(:,2), 'k.','MarkerSize', 15);
title 'K-means centroids for Fisher''s Iris Data';
xlabel 'Petal Lengths (cm)';
ylabel 'Petal Widths (cm)';


%% K-MEANS++

% select k points as centroids as per k-means++
centroids = get_kpp_centroids(X, 3);

max_iterations = 100;
for i=1:max_iterations
    
    % find which is the closest centroid for each point
    closest_centroids = get_closest_centroids(X, centroids);
    
    for j = 1:k
        
        % get all points correspoding to centroid j
        centroid_pts_idx = closest_centroids == j;
        
        % set new centroid j as mean of all points closest to previous j
        centroids(j, :) = mean(X(centroid_pts_idx, :));
    
    end
    
end

figure;
plot(centroids(:,1), centroids(:,2), 'k.','MarkerSize', 15);
title 'K-means++ centroids for Fisher''s Iris Data';
xlabel 'Petal Lengths (cm)';
ylabel 'Petal Widths (cm)';


%% HELPER FUNCTIONS

function closest_centroids = get_closest_centroids(X, centroids)
% get_closest_centroids  Finds closest centroid to each point
%
% Assumes each column of X (nxd) is dimension and each row is data point
% Each column of centroids (kxd) is dimension and each row is data point
%
% Returns closest_centroids  (nx1) of centroid number closest to each point

    % number of centroids
    k = size(centroids,1);

    % nxk matrix where row i,col j is distance of ith pt from jth centroid 
    distances_from_centroids = zeros(size(X,1), k);
    
    % calculate distance from each centroid
    for c_num = 1:k
        
        distances_from_centroids(:, c_num) = sum(((X - centroids(c_num, :)) .^ 2), 2);
    
    end

    % get the closest centroid number
    [~, closest_centroids] = min(distances_from_centroids, [], 2);

end


function initial_centroids = get_kpp_centroids(X, k)
% get_kpp_centroids  Finds initial centroids as per k-means++ algorithm
%
% Assumes each column of X (nxd) is dimension and each row is data point
%
% Returns initial_centroids (kxd)

    % initialize matrix as NaN's so that max funcion chooses defined value 
    % over other centroids
    initial_centroids = NaN(k, size(X,2));
    
    % select first centroid randomly
    initial_centroids(1, :) = X(randi([1 k]), :);
    
    % initialize distances of each point from each centroid
    distances = zeros(size(X,1), k);
    
    for c_num = 1:k
        
        % find distance of each point from each centroid
        for c_dist = 1:k
            distances(:, c_dist) = sum((X-initial_centroids(c_dist, :)).^2, 2);
        end
        
        % get the closest centroid, select the point with max distance to 
        % its closest centroid
        [~, c_idx] = max(min(distances, [], 2));
        
        % save the point at c_idx as a new centroid
        initial_centroids(c_num, :) = X(c_idx, :);
        
    end

end


function initial_centroids = get_initial_centroids(X, k)
% get_initial_centroids  Randomly chooses k points as initial centroids
%
% Assumes each column of X (nxd) is dimension and each row is data point
%
% Returns initial_centroids (kxd)

    % indices of data points to be selected as initial centroids
    x_indices = randperm(size(X,1), k);
    
    % extract data points at chosen indices
    initial_centroids = X(x_indices, :);

end
