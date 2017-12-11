% ENG EC 503 - Fall 2017
% DP Means Implementation for Final Project

function [k, centroids, assignments, wcss, varargout] = DPMeans(X, lambda)
    %% Init
    t_max = 100;
    num_samples = size(X, 1);
    num_features = size(X, 2);

    % start with the global mean as the only cluster center
    centroids = mean(X);
    % and all the points in the same global mean cluster
    assignments = ones(1, num_samples);
    k = 1;
    wcss = zeros(t_max, 1);

    for t = 1:t_max
        %% Assignment Step
        % calc distances from all points to all centroids
        DM = pdist2(X, centroids);
        for i = 1:num_samples
            % if the distance is greater than the threshold
            if min(DM(i, :)) > lambda
                % allocate a new cluster at that point
                k = k + 1;
                assignments(i) = k;
                % and assign its centroid to be the point itself
                centroids = cat(1, centroids, X(i, :));
                DM = pdist2(X, centroids);
                size(centroids);
                assignments(i) = find(min(DM(i, :)) == DM(i, :));
            else
                % otherwise assign it to the closest centroid
                assignments(i) = find(min(DM(i, :)) == DM(i, :));
            end
        end

        %% Calculate WCSS at this iteration
        for clus_num = 1:k
            wcss(t) = wcss(t) + sum(sum(pdist2(X(assignments==clus_num, :), ...
                                                centroids(clus_num, :), ...
                                                'squaredeuclidean')));
        end
        
        %% Update Step
        for c = 1:k
            % new centroid is the mean of all the data points in the cluster
            centroids(c, :) = mean(X(assignments == c, :), 1);
        end
    end
end
