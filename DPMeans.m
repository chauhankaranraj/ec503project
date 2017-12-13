% ENG EC 503 - Fall 2017
% DP Means Implementation for Final Project
%% ALERT: USE SQUARED EUCLIDEAN DISTANCE

function [assignments, k, varargout] = DPMeans(X, lambda)
%% Init
t_max = 20;
num_samples = size(X, 1);
num_features = size(X, 2);

% start with the global mean as the only cluster center
centroids = mean(X);
% and all the points in the same global mean cluster
assignments = ones(1, num_samples);
k = 1;
obj_func = zeros(1, t_max);

    for t = 1:t_max
        %% Assignment Step
        % calc distances from all points to all centroids
        DM = pdist2(X, centroids, 'squaredeuclidean');
        for i = 1:num_samples
            % if the distance is greater than the threshold
            if min(DM(i, :)) > lambda
                % allocate a new cluster at that point
                k = k + 1;
                assignments(i) = k;
                % and assign its centroid to be the point itself
                centroids = cat(1, centroids, X(i, :));
                DM = pdist2(X, centroids, 'squaredeuclidean');
            else
                % otherwise assign it to the closest centroid
                assignments(i) = find(min(DM(i, :)) == DM(i, :));
            end
        end
        
        %% Update Step
        for c = 1:k
            % new centroid is the mean of all the data points in the cluster
            centroids(c, :) = mean(X(assignments == c, :), 1);
        end
        
        %% Calcualte Objective Function
        if nargout == 3
            objective = 0;
            for c = 1:k
                objective = objective + ...
                        sum(DM(assignments == c, c));
            end
            obj_func(t) = objective + lambda*k;
        end
    end
    
    if nargout == 3
        varargout{1} = obj_func;
    elseif nargout == 4
        varargout{1} = obj_func;
        varargout{2} = centroids;
    end
end
