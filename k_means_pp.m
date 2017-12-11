function [centroids, wcss] = k_means_pp(X, k, max_iter)

    % if max iterations is not explicitly specified, set it to 100
    if ~exist('max_iter', 'var')
        max_iter = 100;
    end
    
    % use the kmeans++ smart centroid initialization
    centroids = init_kpp_centroids();
    
    % wcss(i) has within cluster sum of squares at iter num i
    wcss = zeros(max_iter, 1);
    
%     prev_iter_centroids = zeros(k, size(X,2));
    for i = 1:max_iter

        % find which is the closest centroid for each point
        assignments = get_assignments();

        for j = 1:k

            % get all points correspoding to centroid j
            curr_cluster_pts_idx = assignments == j;
            
            % add current cluster sum of squares
            wcss(i) = wcss(i) + sum(sum(pdist2(centroids(j, :), X(curr_cluster_pts_idx, :), 'squaredeuclidean')));

            % set new centroid j as mean of all points closest to previous j
            centroids(j, :) = mean(X(curr_cluster_pts_idx, :));

        end
        
%         % break if converged, otherwise update prev_iter_centroids
%         if prev_iter_centroids == centroids
%             wcss = wcss(1:i);
%             break;
%         else
%             prev_iter_centroids = centroids;
%         end

    end
    
    
    % HELPER FUNCTIONS
    
    function closest_centroids = get_assignments()
    % get_assignments  Finds closest centroid to each point
    %
    % Assumes each column of X (nxd) is dimension and each row is data point
    % Each column of centroids (kxd) is dimension and each row is data point
    %
    % Returns closest_centroids  (nx1) of centroid number closest to each point

        % nxk matrix where row i,col j is distance of ith pt from jth centroid 
        distances_from_centroids = zeros(size(X,1), k);

        % calculate distance from each centroid
        for c_num = 1:k

            distances_from_centroids(:, c_num) = sum(((X - centroids(c_num, :)) .^ 2), 2);

        end

        % get the closest centroid number
        [~, closest_centroids] = min(distances_from_centroids, [], 2);

    end

    function smart_centroids = init_kpp_centroids()
    % get_kpp_centroids  Finds initial centroids as per k-means++ algorithm
    %
    % Assumes each column of X (nxd) is dimension and each row is data point
    %
    % Returns initial_centroids (kxd)

        % initialize matrix as NaN's so that max funcion chooses defined value 
        % over other centroids
        smart_centroids = NaN(k, size(X,2));

        % select first centroid randomly
        smart_centroids(1, :) = X(randi([1 k]), :);

        % initialize distances of each point from each centroid
        distances = zeros(size(X,1), k);

        for c_num = 1:k

            % find distance of each point from each centroid
            for c_dist = 1:k
                distances(:, c_dist) = sum((X-smart_centroids(c_dist, :)).^2, 2);
            end

            % get the closest centroid, select the point with max distance to 
            % its closest centroid
            [~, c_idx] = max(min(distances, [], 2));

            % save the point at c_idx as a new centroid
            smart_centroids(c_num, :) = X(c_idx, :);

        end

    end
    
end